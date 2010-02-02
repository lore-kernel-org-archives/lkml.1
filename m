Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512Ab0BBGVu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 01:21:50 -0500
Received: from mail-yx0-f189.google.com ([209.85.210.189]:55226 "EHLO
	mail-yx0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752945Ab0BBGVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 01:21:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=qI3R/UFa3jivI+B4DMGiFwdVCHYr5JhcHPmwHdWbhaCJvbEzD84LTigNGV7yCks2Mi
         rHeGkBWPrpHSyen8EnDs17TXL/Yd4uOJFnUYwzWTq2WGVAhG0ALZA23rOeQWUaf+tvlA
         mo7iLtG45yD8s6+l5CAHYElbYCX1ktOZwEsps=
Message-ID: <4B67C4D2.5050205@gmail.com>
Date: Mon, 01 Feb 2010 22:23:14 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: Dan Carpenter <error27@gmail.com>, linux1394-devel@lists.sourceforge.net,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: ohci1394_dma=early crash since 2.6.32 (was Re: [Bug #14487] PANIC:
 early exception 08 rip 246:10 error	ffffffff810251b5 cr2 0)
References: <UgwvXSBS_tM.A.alD.1EiZLB@chimera> <de962C6zBxL.A.H1G.1HiZLB@chimera> <4B6630CA.9010207@gmail.com> <20100201125441.GB2576@bicker> <4B671606.3080405@gmail.com> <4B673233.8000300@s5r6.in-berlin.de> <4B6740B5.5070601@gmail.com> <4B675534.5070107@s5r6.in-berlin.de> <4B676917.2080506@gmail.com> <4B67BC12.4080709@s5r6.in-berlin.de>
In-Reply-To: <4B67BC12.4080709@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/10 21:45, Stefan Richter wrote:
> Justin P. Mattock wrote:
>> So(correct me if I'm wrong), I'm generating a 64 bit register
>> and the kernel is looking for a 32 bit register causing the crash.
>
> No, the class = read_pci_config(); if (class == ...) ... parts of the
> code are entirely innocent as far as I can tell.  This is just the
> FireWire--PCI chip detection.  It is the subsequent driver setup for the
> chip that crashes somewhere.
>
> When you modified that chip detection code earlier, you only prevented
> crashes when your modifications ended up as "ignore all PCI devices,
> also FireWire ones" == "do nothing at all".
>
> Perhaps the bootup sequence of the x86(-64) platform was changed from
> 2.6.31 to .32 thus that some assumptions in init_ohci1394_dma about when
> are what resources available are not true anymore.  According to your
> screenshot in http://lkml.org/lkml/2009/10/27/335 the issue is about
> memory allocation, not about PCI bus access.


Alright.. I'll keep focus on that
and see if I can figure this out.

As for anything changed in the kernel
(2.6.31 - present), tough to say
from what I remember I had created a new fresh
lfs system using these CFLAGS:

CFLAGS="-mtune=core2 -march=core2 -O2 -pipe -fomit-frame-pointer" 
CXXFLAGS="${CFLAGS}" MAKEOPTS="{-j3}"
(without -m option gcc defaults(I think)to -m32).

which booted with ohci1394_dma=early just fine.

then decided to build another lfs system with the same CFLAGS except
added -m64 (pure64) to the build process.
(then this showed up).

What I can try is do a git revert to 2.6.29/27 to see if this thing
fires off(before going any further). if the system boots then do a bisect.

Justin P. Mattock
