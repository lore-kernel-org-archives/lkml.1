Return-Path: <linux-kernel-owner+w=401wt.eu-S1756184AbYBYOpk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184AbYBYOpk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 09:45:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754571AbYBYOpc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 09:45:32 -0500
Received: from ti-out-0910.google.com ([209.85.142.189]:44266 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754455AbYBYOpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 09:45:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:to:cc:subject:message-id:reply-to:mail-followup-to:references:mime-version:content-type:content-disposition:content-transfer-encoding:in-reply-to:user-agent:from;
        b=svbDhuZ+zH0F7T6XzGEdoa5/DSDTIJF+LzfShUN/NiXsd5GCSTjf7OvoUnjTL0VajQjuf5VynzgRhDzfaDSGsIjGJ32DxzIIWwZZMc+2qGp4oX+X7npwMIQ93vrVj7rJchowIpPVlUJRs3KrNuL3sorJa1DyoSzqHRR6d8BnSHo=
Date: Mon, 25 Feb 2008 15:45:19 +0100
To: Brad Rosser <brad.rosser@gmail.com>
Cc: bzolnier@gmail.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: IDE cdrom problem with PLEXTOR DVDR PX-608AL
Message-ID: <20080225144519.GB3816@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com, Brad Rosser <brad.rosser@gmail.com>,
	bzolnier@gmail.com, linux-ide@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <426a98560802232138q41d45d52ta515f1b791e937f4@mail.gmail.com> <20080224173451.GB11998@gollum.tnic> <426a98560802241758j7a9be21m5eecc120ada804e4@mail.gmail.com> <20080225053404.GA3816@gollum.tnic> <426a98560802242157j61294ba6i2aaa9cce4d836a7b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <426a98560802242157j61294ba6i2aaa9cce4d836a7b@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2008 at 03:57:06PM +1000, Brad Rosser wrote:
> Hi Boris,
> 
> >  Well, this sounds strange. Are you sure you're entering the boot options
> >  correctly on the kernel command line? Which is your boot loader? I just booted
> >  my machine with 'hdc=noprobe'  (hdc is my cdrom drive) and here's what i get:
> >
> >  ...
> >  [    0.304774] Probing IDE interface ide0...
> >  [    0.569359] hdb: SAMSUNG SP2014N, ATA DISK drive
> >  [    0.613977] Switched to NOHz mode on CPU #1
> >  [    0.773368] Switched to NOHz mode on CPU #0
> >  [    0.874486] hda: QUANTUM FIREBALLlct10 20, ATA DISK drive
> >  [    0.874506] hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
> >  [    0.874506] hda: drive side 80-wire cable detection failed, limiting max speed to UDMA33
> >  [    0.874506] hda: UDMA/33 mode selected
> >  [    0.874533] hdb: host max PIO4 wanted PIO255(auto-tune) selected PIO4
> >  [    0.874620] hdb: UDMA/100 mode selected
> >  [    0.874744] Probing IDE interface ide1...
> 
> >  so it seems you should check whether your kernel is receiving the 'hda=noprobe'
> >  boot option at all, or something along that path is going wrong...
> 
> I'm entering the option 'hda=noprobe' (as one example) right after my boot
> label in LILO.  The dmesg output I attached last time was a boot of straight
> 2.6.25-rc2 without any options; I've attached 'dmesg.noprobe.out' which is
> the result of a boot with 'hda=noprobe'.
> 
> I must have done something stupid, but I can't see what; if you look at this
> line from the dmesg output:
> 
> Kernel command line: BOOT_IMAGE=linux_2.6.25rc2 ro root=900
> md=0,/dev/sda5,/dev/sdb5 hda=noprobe
> 
> ... it would suggest the option 'hda=noprobe' was entered correctly?

ok, let's try something else: change the line "#if 0" to "#if 1" at the
beginning of kernel/params.c, it looks like:

#if 0
#define DEBUGP printk
#else
#define DEBUGP(fmt, a...)
#endif

rebuild your kernel, and reboot with it. Then, please send me that boot log to
see whether the kernel command line is being received from the boot loader and
what exactly is getting parsed. Thanks.

> >  > I tried to apply the patch but failed; I probably did something wrong.
> >  > I deleted everything in your message above 'Index: b/drivers/ide/ide-cd.c'
> >  > and ran 'patch --dry-run -b -p1 < ../bart_patch'.  This is part of my script
> >  > log:
> >
> >  are you sure you're _really_ using 2.6.25-rc2? Applying the patch against that
> >  kernel works just fine, no fuzziness or even rejects. Care to try out on a fresh
> >  kernel source tarball? After all, building a kernel with your quad core cpu won't
> >  take that long :-) when using make -j8 or something in that order.
> 
> Heh.  This is my first new machine in 8 years, and I couldn't wait to start
> using multiple cores.  I was quick to discover the '-j' option ... but I only
> do '-j 4'.  Anyway ... I'd downloaded the full baseline linux-2.6.24.tar.bz2,
> unpacked it, and then ran the patch patch-2.6.25-rc2.bz2 against it.  That
> patch ran perfectly.  And I was in the right directory when I ran Bart's patch,
> as I listed in my earlier e-mail!  All indications were that I was running the
> 2.6.25-rc2 kernel as required, I thought.
> 
> Well, I see that rc3 is out; maybe I'll give that a shot.

Please see whether you can apply the patch Bart just sent and if that still gets
mangled and cannot be applied, consider making those changes to ide-cd.c by hand
- after all, there are only several lines that need to be changed so it won't
take that long.

Thanks.

-- 
Regards/Gruﬂ,
    Boris.
