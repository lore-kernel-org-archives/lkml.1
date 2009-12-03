Return-Path: <linux-kernel-owner+w=401wt.eu-S1754967AbZLCCbe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754967AbZLCCbe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 21:31:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754829AbZLCCbd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 21:31:33 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:50208 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753988AbZLCCbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 21:31:32 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4B1722FD.3080807@jp.fujitsu.com>
Date: Thu, 03 Dec 2009 11:31:25 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
CC: mingo@elte.hu, stable@kernel.org, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [PATCH] x86/mce: timer must be setup unconditionally
References: <4B162A3C0200007800022F98@vpn.id2.novell.com> <4B1629A0.60403@jp.fujitsu.com> <4B1638FE0200007800022FC2@vpn.id2.novell.com>
In-Reply-To: <4B1638FE0200007800022FC2@vpn.id2.novell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich wrote:
>>>> Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com> 02.12.09 09:47 >>>
>> Jan Beulich wrote:
>>> mce_timer must be passed to setup_timer() in all cases, no matter
>>> whether it is going to be actually used. Otherwise, when the CPU gets
>>> brought down, its call to del_timer_sync() will never return, as the
>>> timer won't have a base associated, and hence lock_timer_base() will
>>> loop infinitely.
>> No, what we need to fix is hotplug callbacks.
>> So correct fix should be like "del/add timer conditionally when hotplug."
> 
> Why? This makes the logic just more complicated (you'd need to track
> whether the timer was ever setup or added), and I can't see any
> non-tolerable side effect of calling setup_timer() without ever adding
> the timer anywhere.

Ah, sorry, I mistook your patch.
It seems that I just found an another bug here...

Reviewed-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>


Thanks,
H.Seto

