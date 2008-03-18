Return-Path: <linux-kernel-owner+w=401wt.eu-S1759113AbYCRFgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759113AbYCRFgV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 01:36:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754836AbYCRF1C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 01:27:02 -0400
Received: from [217.13.205.113] ([217.13.205.113]:54445 "HELO mput.de"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with SMTP
	id S1754773AbYCRF1A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 01:27:00 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Mar 2008 01:27:00 EDT
Subject: Re: suspend not working on macbook pro
From: Kristian Mueller <kernel@mput.de>
To: Pozsar Balazs <pozsy@uhulinux.hu>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080308110626.GE4491@ojjektum.uhulinux.hu>
References: <20080308110626.GE4491@ojjektum.uhulinux.hu>
Content-Type: text/plain; charset=utf-8
Date: Tue, 18 Mar 2008 06:15:18 +0100
Message-Id: <1205817318.7840.21.camel@mac>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi pozsy

On Mar 8, 12:20 pm, Pozsar Balazs <po...@uhulinux.hu> wrote:
> I'm using a macbook pro 3,1 (mid-2007), and suspend worked ok with 
> kernel 2.6.23.x, but with 2.6.25-rc{1,2,3,4} it just freezes during 
> suspend. The console is still on, the disk is powered off, but no 
> response or poweroff...

I've had the same problem (tried with 2.6.25-rc3, -rc5 and -rc6). 
Got a MacBook Pro 2,2 (first Core 2 Duo series) here. 

﻿
> Did anyone else met the same thing? How could I help debug it?
> What other info would you need?

I've solved some issues, using "init=/bin/sh" in the kernel commandline.
You can then call "/usr/sbin/pm-suspend" and system will actually output
messages while suspending - does not happen with normal Ubuntu init.

The first issue I got was the "hangs after Suspending console(s)"
Solution: kernel command line += "no_console_suspend"
 
The 2nd one is a problem with /dev/hda (CDROM) error "drive not ready". 
I could kind of solve this by not using the piix driver from the
"ATA/ATAPI/MFM/RLL" section anymore. I only use ata_piix driver from the
Serial ATA section now, which seems to support the CD drive to.

Well, after that my system goes into suspend. yay!, but when it wakes 
up. I get the following sequenze:

- Fan starts running
- Sound klicks softly
- CD drive makes a short noise
- CD drive makes the same noise again (moving the laser i guess)
- EFI Bootloader appears

(the second CD drive noise is already part of boot sequence - 
I am not sure about the first one though)

Anyway, I am not sure if it's nessesary, but I also disabled:
 - dynamic tics
 - smp
 - forced preemption
 - modular USB and SATA drivers

I still suspect the CD drive to be a problem. - searching for a way to
disable it for now.

Greetings from Berlin

Kristian
-- 
/* Web:  http://www.mput.de  | Jabber: kristian@mput.de        *
 * Blog: http://mput.de/blog | MSN:    mueller.kristian@vdi.de *
 * Wiki: http://mput.de/wiki | ICQ:    93248497                *
 * Tel:  0170/6692447        | GPG-ID: 4BBB6525 (2008 - 2009)  */

