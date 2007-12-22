Return-Path: <linux-kernel-owner+w=401wt.eu-S1753759AbXLVStX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753759AbXLVStX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 13:49:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752716AbXLVStQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 13:49:16 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:55506 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752662AbXLVStQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 13:49:16 -0500
Date: Sat, 22 Dec 2007 19:47:59 +0100
From: Pavel Machek <pavel@ucw.cz>
To: David Newall <david@davidnewall.com>
Cc: Richard D <richard@embunus.com>,
       "'Matthew Bloch'" <matthew@bytemark.co.uk>,
       linux-kernel@vger.kernel.org
Subject: Re: Testing RAM from userspace / question about memmap= arguments
Message-ID: <20071222184759.GB31809@elf.ucw.cz>
References: <fk8umh$n7o$1@ger.gmane.org> <20071221125812.GA4052@ucw.cz> <000001c84472$74b245e0$5e16d1a0$@com> <20071222134612.GA4098@ucw.cz> <476D35F6.90900@davidnewall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <476D35F6.90900@davidnewall.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2007-12-23 02:36:14, David Newall wrote:
> Pavel Machek wrote:
>> On Sat 2007-12-22 13:42:47, Richard D wrote:
>>   
>>> Cant you, modify bootmem allocator to test with memtest patterns and then
>>> use kexec (as Pavel suggested) to test the one where kernel was sitting
>>> earlier?
>>
>> I do not think you need to modify anything in kernel. Just use
>> /dev/mem to test areas that kernel doesn't see, then kexec into place
>> you already tested, and test the rest.
>
> That's still an insufficient test.  One failure mode is writes at one 
> location corrupting cells at another.
>
> The idea of wanting to do comprehensive and robust memory testing from 
> within the operating system seems dubious at best, to me.  If there is 
> something wrong with memtest86, doing the tests from within Linux is not 
> the answer.  The answer is to fix memtest86.  If the problem is that you 
> automation, e.g. switching a server from production to memory test mode at 
> midnight and back again at 6am, the answer is still to "fix" memtest86.  
> Writing something that grabs some physical RAM from Linux's control, tests 
> it, and then moves the kernel itself so that it can test the rest, is 
> adding a whole extra layer of complexity to an already challenging (I 
> assume, based on errors that dedicated software-based testers miss) 
> problem.

Well, we have kexec. We already have way for kernel to relocate itself.

> Give up on this misguided idea and build on the best tools that are already 
> available.

Yes, the idea is "interesting". I do not think it quite cuts
"misguided" part.

memtest has following problems:

	0) it is kind of hard to run memtest over ssh

	1) if linux fixes some problem with PCI quirk or microcode
	upload, memtest will not see the fix

	2) if memory only fails while something else happens (DMA to
	other piece of memory? Hard disk load glitching powre
	supply?), memtest will not see the problem.

(Of course, memtest-under-linux has some problems too. Like "if it
freezes, was it bad memory or kernel problem").
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
