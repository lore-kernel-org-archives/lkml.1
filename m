Return-Path: <linux-kernel-owner+w=401wt.eu-S1758592AbXHRVUy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758592AbXHRVUy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 17:20:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754762AbXHRVUp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 17:20:45 -0400
Received: from wx-out-0506.google.com ([66.249.82.230]:49871 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754545AbXHRVUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 17:20:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=jFd9ghZ8nXju0j6yznZxKRdPBJfJZsQMXJwOu4O2zTuXyyU6GqCmz/dt/9CKDML4H2llW3/Fp04Qyw9gkYteYx3Gg2s3hqJa1oMPBIQ1i7pjnSrUU4GC96G02llLgdtx+ZeOiIedNh8k6HsjFS2eFPo8selF3ouX2/ip4VSMAfo=
Message-ID: <b2d05de20708181420x1dab449ch97e59487a4fff12a@mail.gmail.com>
Date: Sat, 18 Aug 2007 13:20:42 -0800
From: "Brennan Ashton" <comphappy@gmail.com>
To: "Jan Engelhardt" <jengelh@computergmbh.de>
Subject: Re: power off disk drives while running
Cc: "Robert Hancock" <hancockr@shaw.ca>,
       "Marty Leisner" <leisner@rochester.rr.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0708182305220.5186@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fa.l/ISoqsJwIs1QBGVs0hodyygNPM@ifi.uio.no>
	 <fa.FVj1AVbAlk/6U33GB0rOY45WWqM@ifi.uio.no>
	 <fa.CQDcAiLY+yM/ENberToamsw+vFw@ifi.uio.no> <46C7551E.7090408@shaw.ca>
	 <Pine.LNX.4.64.0708182305220.5186@fbirervta.pbzchgretzou.qr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/18/07, Jan Engelhardt <jengelh@computergmbh.de> wrote:
>
> On Aug 18 2007 14:22, Robert Hancock wrote:
> >> I see this a a very important feature in the embedded system relm, I
> >> have worked on two projects that required extreme power management,
> >> and massive data storage.  The ability to fully turn off a drive while
> >> the system is running is key. It seems like this should be able to be
> >> done from a kernel point of view rather than extra hardware. Although
> >> if is not in the IDE/SATA spec then extra hardware would be necessary.
> >
> > You can put a drive into sleep mode with ATA commands, that one requires a
> > reset to take it out of that state (as opposed to standby which spins down but
> > will spin up on any command that's issued afterwards). That's as close as it
> > gets to fully powering off a drive through software.
>
> An IDE reset bringing the disk up again -- that does not sound like
> it is powered down. Power down for me means: as if the plug was pulled.
>
>
> Well, you could also rewrite the standy ioctl to do this:
>
>  - flush data
>  - send spindown request
>  - wait 1ms - 1s (give drive some time to park heads)
>  - outportb(0x378, 0) - poweroff by setting LPT data line to 0
>    (who knows? they might control the disk power!)
>
> But you'd still have to fiddle with bringing it up again. That is, you have to
> patch the block or device driver to outportb(0x378, 255) again when something
> is supposed to spin up again.
>
> Oh and of course you have to deal with the problem that all userspace apps may
> hang because they are waiting for the disk.
>
> Also consider that frequently spinning up/down is said to reduce lifetime.
>
>
>         Jan
> --
>
In my experience with embedded systems, usually the OS is residing in
flash with all of the apps. The hard disks are used a storage. Example
remote off grid high resolution time laps photography. the device
itself is simple OS, web server, and image grabber all reside in flash
32MB or so. Then HDs are used to store the images and turn off
completely at night and when disk is full.

-- 
Brennan Ashton
Bellingham, Washington

"The box said, 'Requires Windows 98 or better'. So I installed Linux"
