Return-Path: <linux-kernel-owner+w=401wt.eu-S1756647AbYLaRkG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756647AbYLaRkG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 12:40:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755970AbYLaRjy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 12:39:54 -0500
Received: from mail.gmx.net ([213.165.64.20]:36830 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755888AbYLaRjy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 12:39:54 -0500
X-Authenticated: #1045983
X-Provags-ID: V01U2FsdGVkX1+yxdx5Z9eyAQO9/tdq644oz6Xeg9enyXGewU5bM1
	0BZfxyEQ8SDrV7
Message-ID: <495BAE6B.2030100@gmx.de>
Date: Wed, 31 Dec 2008 18:39:55 +0100
From: Helge Deller <deller@gmx.de>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>
CC: linux-parisc <linux-parisc@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Kyle McMartin <kyle@mcmartin.ca>, Randolph Chung <randolph@tausq.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       John David Anglin <dave@hiauly1.hia.nrc.ca>
Subject: Re: [PATCH] parisc: fix module loading failure of large kernel modules
 (take 4)
References: <4959346E.7060600@gmx.de> <200812310915.41693.rusty@rustcorp.com.au> <495B5806.3080505@gmx.de> <alpine.LFD.2.00.0812310926450.5086@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0812310926450.5086@localhost.localdomain>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.55
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Wed, 31 Dec 2008, Helge Deller wrote:
>> [PATCH 1/2] module.c: fix module loading failure of large kernel modules
>>
>> When creating the final layout of a kernel module in memory, allow the
>> module loader to reserve some additional memory in front of a given section.
>> This is currently only needed for the parisc port which needs to put the
>> stub entries there to fulfill the 17/22bit PCREL relocations with large
>> kernel modules like xfs.
>>
>> Differences of this patch to previous versions:
>> - added weak funtion arch_module_section_size()
> 
> This doesn't work.
> 
> We've had this bug several times now, and one of them just very recently.
> 
> Some gcc versions will inline weak functions if they are in scope - even 
> if there is a non-weak function somewhere else. So you MUST NOT have the 
> weak definition in the same file (or indirectly called through some inline 
> functions in a header file) as the call. Because if you do, then any user 
> with the wrong version of gcc will get the weak function semantics, even 
> if it was meant to be overridden by something else.

Ok, that might explain why I saw some strange things in the unwind tables
after that I switched to using the weak function (hppa-crosscompiler, gcc-3.3.4).

>> +/* Additional bytes needed by arch in front of individual sections */
>> +unsigned int __attribute__ ((weak)) arch_module_section_size(
>> +		struct module *mod, unsigned int section)
> 
> We don't write out that whole "__attribute__" crud. We use
> 
> 	unsigned in __weak arch_module_section_size(struct module *mod, unsigned int section)
> 
> instead.

Ok.

> But as mentioned, it needs to be in another compilation unit.

Understood.

Rusty, back to you for an advise on how to continue ;-)
(I assume Rusty is just right now celebrating new-year)

Helge
