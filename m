Return-Path: <linux-kernel-owner+w=401wt.eu-S1759352AbYBYFeY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759352AbYBYFeY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 00:34:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753055AbYBYFeP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 00:34:15 -0500
Received: from hs-out-0708.google.com ([64.233.178.244]:63893 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639AbYBYFeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 00:34:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:to:cc:subject:message-id:reply-to:mail-followup-to:references:mime-version:content-type:content-disposition:content-transfer-encoding:in-reply-to:user-agent:from;
        b=iYAPHpniKcDm2+KV8/2e1LAqrsPHodcZHdUKFwlwHClYbGGlR1U09i9PcrAUEPcGzU7Cm9IrEDgdJQpt+3aD4PgwA9YZgFIirLoSsf7j0aupI2Tpmp732bCKvy9jukH+DyS/mARt8cgodGTfEj3hrvRc8rziXNYtiLXiP/NHsxo=
Date: Mon, 25 Feb 2008 06:34:04 +0100
To: Brad Rosser <brad.rosser@gmail.com>
Cc: bzolnier@gmail.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: IDE cdrom problem with PLEXTOR DVDR PX-608AL
Message-ID: <20080225053404.GA3816@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com, Brad Rosser <brad.rosser@gmail.com>,
	bzolnier@gmail.com, linux-ide@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <426a98560802232138q41d45d52ta515f1b791e937f4@mail.gmail.com> <20080224173451.GB11998@gollum.tnic> <426a98560802241758j7a9be21m5eecc120ada804e4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <426a98560802241758j7a9be21m5eecc120ada804e4@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2008 at 11:58:57AM +1000, Brad Rosser wrote:
> On Mon, Feb 25, 2008 at 3:34 AM, Borislav Petkov
> <petkovbb@googlemail.com> wrote:
> > On Sun, Feb 24, 2008 at 03:38:34PM +1000, Brad Rosser wrote:
> > >
> > > There's nothing in the bios that allows me to move one away from
> > > the other.  I can 'reserve' or block IRQs, but that only shifts them
> > > both to another interrupt.
> >
> >  well the driver probes the bios for that data and assigns the irq line it gets
> >  from it.
> 
> Oh.  I thought from all the 'IRQ routing/balancing' and the like in the
> kernel there might be a way to switch things around, give the
> Realtek driver a different IRQ than the one being used by the ide driver.
> Just my crossed-fingers hope.
> 
> >  Can you please send me your whole boot log of 2.6.25-rc2? Thanks.
> 
> It's attached as file 'dmesg.bug.out'.
> 
> >  since your cdrom seems to be hda from what i've seen above, try booting with
> >  'hda=noprobe' or maybe 'hda=none' to see which one turns the probing off for
> >  you. See Documentation/ide.txt for details.
> 
> I tried both options, but in both cases there was no difference; the ide_cd_mod
> module was still loaded and the 'confused' message still popped up.
> 
> I did four boots/tests of the 2.6.25-rc2 kernel, with and without those
> boot parameters ... on all four I had the 'confused' message several times:
> 
> hda: cdrom_newpc_intr: The drive appears confused (ireason = 0x01).
> Trying to recover by ending request.

Well, this sounds strange. Are you sure you're entering the boot options
correctly on the kernel command line? Which is your boot loader? I just booted
my machine with 'hdc=noprobe'  (hdc is my cdrom drive) and here's what i get:

...
[    0.304774] Probing IDE interface ide0...
[    0.569359] hdb: SAMSUNG SP2014N, ATA DISK drive
[    0.613977] Switched to NOHz mode on CPU #1
[    0.773368] Switched to NOHz mode on CPU #0
[    0.874486] hda: QUANTUM FIREBALLlct10 20, ATA DISK drive
[    0.874506] hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
[    0.874506] hda: drive side 80-wire cable detection failed, limiting max speed to UDMA33
[    0.874506] hda: UDMA/33 mode selected
[    0.874533] hdb: host max PIO4 wanted PIO255(auto-tune) selected PIO4
[    0.874620] hdb: UDMA/100 mode selected
[    0.874744] Probing IDE interface ide1...
-->
[    0.877750] hdc: ide_wait_not_busy() skipped
-->
[    1.136180] hdd: IC35L120AVV207-0, ATA DISK drive
[    1.186959] hdd: host max PIO4 wanted PIO255(auto-tune) selected PIO4
[    1.186959] hdd: host side 80-wire cable detection failed, limiting max speed to UDMA33
[    1.186959] hdd: UDMA/33 mode selected
[    1.186959] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[    1.194971] ide1 at 0x170-0x177,0x376 on irq 15
[    1.206876] Probing IDE interface ide2...
[    1.720661] Probing IDE interface ide3...
[    2.233564] Probing IDE interface ide4...
[    2.746462] Probing IDE interface ide5...
[    3.259395] hda: max request size: 128KiB
[    3.259571] hda: 39876480 sectors (20416 MB) w/418KiB Cache, CHS=39560/16/63
[    3.259571] hda: cache flushes not supported
[    3.259571]  hda: hda1 hda2 hda3
[    3.269291] hdb: max request size: 512KiB
[    3.269511] hdb: 390721968 sectors (200049 MB) w/8192KiB Cache, CHS=24321/255/63
[    3.269962] hdb: cache flushes supported
[    3.270078]  hdb: hdb1
[    3.280914] hdd: max request size: 512KiB
[    3.281247] hdd: 241254720 sectors (123522 MB) w/1821KiB Cache, CHS=16383/255/63
[    3.281729] hdd: cache flushes supported
[    3.281729]  hdd: hdd1
[    3.296760] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
...

so it seems you should check whether your kernel is receiving the 'hda=noprobe'
boot option at all, or something along that path is going wrong...

[...]

> I tried to apply the patch but failed; I probably did something wrong.
> I deleted everything in your message above 'Index: b/drivers/ide/ide-cd.c'
> and ran 'patch --dry-run -b -p1 < ../bart_patch'.  This is part of my script
> log:
> 
> root:/usr/src/linux-2.6.25-rc2# pwd
> /usr/src/linux-2.6.25-rc2
> root:/usr/src/linux-2.6.25-rc2# cat ../bart_patch
> Index: b/drivers/ide/ide-cd.c
> ===================================================================
> --- a/drivers/ide/ide-cd.c
> +++ b/drivers/ide/ide-cd.c
> @@ -670,8 +670,8 @@ static void cdrom_buffer_sectors (ide_dr
>  * and attempt to recover if there are problems.  Returns  0 if everything's
> ...
> ...
> root:/usr/src/linux-2.6.25-rc2# patch --dry-run -b -p1 < ../bart_patch
> patching file drivers/ide/ide-cd.c
> Hunk #1 FAILED at 670.
> Hunk #2 FAILED at 701.
> Hunk #3 FAILED at 1074.
> Hunk #4 FAILED at 1104.
> 4 out of 4 hunks FAILED -- saving rejects to file drivers/ide/ide-cd.c.rej
> 
> Since it found drivers/ide/ide-cd.c I guess I got the '-p' level right (?),
> and that's about the sum total of my 'patch' experience to date.
> Sorry.  Can you tell me what I did wrong?

are you sure you're _really_ using 2.6.25-rc2? Applying the patch against that
kernel works just fine, no fuzziness or even rejects. Care to try out on a fresh
kernel source tarball? After all, building a kernel with your quad core cpu won't
take that long :-) when using make -j8 or something in that order.

-- 
Regards/Gruﬂ,
    Boris.
