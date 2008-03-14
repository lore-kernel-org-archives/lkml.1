Return-Path: <linux-kernel-owner+w=401wt.eu-S1758501AbYCNSmd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758501AbYCNSmd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 14:42:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753830AbYCNSm0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 14:42:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48677 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884AbYCNSmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 14:42:25 -0400
Message-ID: <47DAC66D.2000902@zytor.com>
Date: Fri, 14 Mar 2008 19:39:41 +0100
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Jiri Slaby <jirislaby@gmail.com>, mingo@redhat.com,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Mark early_printk as asmlinkage
References: <1205330034-28828-1-git-send-email-jirislaby@gmail.com> <1205330034-28828-2-git-send-email-jirislaby@gmail.com> <47D7E2FB.2020801@zytor.com> <20080314180401.GA6722@ucw.cz>
In-Reply-To: <20080314180401.GA6722@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> On Wed 2008-03-12 15:04:43, H. Peter Anvin wrote:
>> Jiri Slaby wrote:
>>> It's not explicitly marked as asmlinkage, but invoked 
>> >from x86_32
>>> startup code with parameters on stack.
>>>
>>> No other architectures define early_printk and none of 
>>> them are affected
>>> by this change, since defines asmlinkage as empty token.
>> NAK.
>>
>> The regparm ABI for x86-32 uses parameters on the stack 
>> when the function is varadic (as it is here), so this is 
>> unnecessary.
> 
> I'd call asmlinkage kind of documentation, then. Not everyone is as
> good with x86 abi as you are...
> 

Since it's already only used on x86-32 and we no longer support 
non-regparm x86, I'd like to at least get to the point where x86-32 
doesn't have any function.  We can retain it for documentation's sake, 
but even then it's iffy... is "this is callable from assembly" really 
something arch-invariant.

	-hpa
