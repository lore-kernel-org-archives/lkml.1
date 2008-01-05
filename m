Return-Path: <linux-kernel-owner+w=401wt.eu-S1758004AbYAEVfh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758004AbYAEVfh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 16:35:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757422AbYAEVf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 16:35:28 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:50475 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757046AbYAEVf1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 16:35:27 -0500
Date: Sat, 5 Jan 2008 22:35:36 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Alessandro Guido <alessandro.guido@gmail.com>
Cc: ACPI mailing list <linux-acpi@vger.kernel.org>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: Kohjinsha sleep problems
Message-ID: <20080105213536.GA2307@elf.ucw.cz>
References: <20080101231955.GA1931@ucw.cz> <200801042233.44827.alessandro.guido@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801042233.44827.alessandro.guido@gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HI!

> > On kohjinsha, wakeup code does not seem to be reached at all. I tried
> > looking around FACS, but it seems very empty:
> >
> > ...
> 
> The same on my laptop:
> 
> FACS @ 0x2fefafc0
>   0000: 46 41 43 53 40 00 00 00 62 12 00 00 00 00 00 00  FACS@...b.......
>   0010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>   0020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>   0030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> 
> 
> I've never been able to resume from STR with Linux (works with Windows Vista). 
> STD works, although I have to press the power button in order to
> resume.

Hmm, it is pretty empty on thinkpad x60, too, and s2ram actually works
here:

root@amd:/home/pavel# acpidump -t FACS
FACS @ 0x7f6f4000
  0000: 46 41 43 53 40 00 00 00 95 15 00 00 00 00 00 00 FACS@...........
  0010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
  0020: 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
  0030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................

...and iasl actually segfaults here, too :-(

root@amd:/data/l/kohji# iasl -d FACS.x60.aml 

Intel ACPI Component Architecture
AML Disassembler version 20061109 [May 18 2007]
Copyright (C) 2000 - 2006 Intel Corporation
Supports ACPI Specification Revision 3.0a

Loading Acpi table from file FACS.x60.aml
Segmentation fault (core dumped)
root@amd:/data/l/kohji# 

...hmm, if it is buffer overflow, we have security problem in
iasl. Anyway, how do I decode FACS?
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
