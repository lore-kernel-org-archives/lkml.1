Return-Path: <linux-kernel-owner+w=401wt.eu-S1754940AbZLBIxA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754940AbZLBIxA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 03:53:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754754AbZLBIw7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 03:52:59 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:36571 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754752AbZLBIw7 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com;5:1>);
	Wed, 2 Dec 2009 03:52:59 -0500
Message-Id: <4B1638FE0200007800022FC2@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Wed, 02 Dec 2009 08:53:02 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: "Hidetoshi Seto" <seto.hidetoshi@jp.fujitsu.com>
Cc: <mingo@elte.hu>, <stable@kernel.org>, <tglx@linutronix.de>,
       <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [PATCH] x86/mce: timer must be setup unconditionally
References: <4B162A3C0200007800022F98@vpn.id2.novell.com>
 <4B1629A0.60403@jp.fujitsu.com>
In-Reply-To: <4B1629A0.60403@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com> 02.12.09 09:47 >>>
>Jan Beulich wrote:
>> mce_timer must be passed to setup_timer() in all cases, no matter
>> whether it is going to be actually used. Otherwise, when the CPU gets
>> brought down, its call to del_timer_sync() will never return, as the
>> timer won't have a base associated, and hence lock_timer_base() will
>> loop infinitely.
>
>No, what we need to fix is hotplug callbacks.
>So correct fix should be like "del/add timer conditionally when hotplug."

Why? This makes the logic just more complicated (you'd need to track
whether the timer was ever setup or added), and I can't see any
non-tolerable side effect of calling setup_timer() without ever adding
the timer anywhere.

Jan

