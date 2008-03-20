Return-Path: <linux-kernel-owner+w=401wt.eu-S1760399AbYCTUap@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760399AbYCTUap (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 16:30:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758350AbYCTUXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 16:23:16 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2619 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758321AbYCTUXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 16:23:14 -0400
Date: Thu, 20 Mar 2008 21:14:24 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Kristian Mueller <kernel@mput.de>
Cc: Pozsar Balazs <pozsy@uhulinux.hu>, linux-kernel@vger.kernel.org
Subject: Re: suspend not working on macbook pro
Message-ID: <20080320201424.GB4397@ucw.cz>
References: <20080308110626.GE4491@ojjektum.uhulinux.hu> <1205817318.7840.21.camel@mac>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1205817318.7840.21.camel@mac>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-03-18 06:15:18, Kristian Mueller wrote:
> Hi pozsy
> 
> On Mar 8, 12:20 pm, Pozsar Balazs <po...@uhulinux.hu> wrote:
> > I'm using a macbook pro 3,1 (mid-2007), and suspend worked ok with 
> > kernel 2.6.23.x, but with 2.6.25-rc{1,2,3,4} it just freezes during 
> > suspend. The console is still on, the disk is powered off, but no 
> > response or poweroff...
> 
> I've had the same problem (tried with 2.6.25-rc3, -rc5 and -rc6). 
> Got a MacBook Pro 2,2 (first Core 2 Duo series) here. 
> 
> ???
> > Did anyone else met the same thing? How could I help debug it?
> > What other info would you need?
> 
> I've solved some issues, using "init=/bin/sh" in the kernel commandline.
> You can then call "/usr/sbin/pm-suspend" and system will actually output
> messages while suspending - does not happen with normal Ubuntu init.
> 
> The first issue I got was the "hangs after Suspending console(s)"
> Solution: kernel command line += "no_console_suspend"
>  
> The 2nd one is a problem with /dev/hda (CDROM) error "drive not ready". 
> I could kind of solve this by not using the piix driver from the
> "ATA/ATAPI/MFM/RLL" section anymore. I only use ata_piix driver from the
> Serial ATA section now, which seems to support the CD drive to.
> 
> Well, after that my system goes into suspend. yay!, but when it wakes 
> up. I get the following sequenze:
> 
> - Fan starts running
> - Sound klicks softly
> - CD drive makes a short noise
> - CD drive makes the same noise again (moving the laser i guess)
> - EFI Bootloader appears
> 
> (the second CD drive noise is already part of boot sequence - 
> I am not sure about the first one though)
> 
> Anyway, I am not sure if it's nessesary, but I also disabled:
>  - dynamic tics
>  - smp
>  - forced preemption
>  - modular USB and SATA drivers
> 
> I still suspect the CD drive to be a problem. - searching for a way to
> disable it for now.

Try inserting infinite loop into wakeup.S. If it hangs instead of efi
appearing, you have a data point.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
