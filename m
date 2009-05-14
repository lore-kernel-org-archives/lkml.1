Return-Path: <linux-kernel-owner+w=401wt.eu-S1755481AbZENPgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481AbZENPgh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 11:36:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753064AbZENPg0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 11:36:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:36087 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753579AbZENPgZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 11:36:25 -0400
Message-ID: <4A0C3AAA.2080908@kernel.org>
Date: Fri, 15 May 2009 00:37:14 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
CC: mingo@elte.hu, andi@firstfloor.org, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, linux-kernel-owner@vger.kernel.org,
       hpa@zytor.com
Subject: Re: [PATCH 2/4] x86: simplify cpa_process_alias()
References: <1242305390-21958-1-git-send-email-tj@kernel.org> <1242305390-21958-3-git-send-email-tj@kernel.org> <4A0C43C50200007800000ECA@vpn.id2.novell.com>
In-Reply-To: <4A0C43C50200007800000ECA@vpn.id2.novell.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 14 May 2009 15:35:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Jan Beulich wrote:
>>>> Tejun Heo <tj@kernel.org> 14.05.09 14:49 >>>
>> The two existing alias conditions in cpa_process_alias() are mutually
>> exclusive and future ones are likely to be exclusive too.  Simplify
>> control flow to ease adding other alias cases.
>>
>> The within(vaddr, (unsigned long)_text, _brk_end) test is removed as
>> it's guaranteed to be false if vaddr is in the page mapped area.
> 
> I don't think that's correct - just consider the case where the
> originally passed in virtual address is from the vmalloc area: In
> that case, both the 1:1 mapping *and* the kernel mapping need to be
> checked.

Yeap, you're right.  I was reading the second condition in reversal.
Will update and repost.  Thanks for spotting it.

-- 
tejun
