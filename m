Return-Path: <linux-kernel-owner+w=401wt.eu-S933233AbYBNNnW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933233AbYBNNnW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 08:43:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932250AbYBNNnD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 08:43:03 -0500
Received: from el-out-1112.google.com ([209.85.162.178]:38134 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753914AbYBNNnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 08:43:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=NbRZ9hahzhjaIGI0h0wcy8VAgApXRtaZCXGKkZTL0JIJCf7an83ve6+FHHXohM1mh3mFuyTCa8ouhMyI0jRsivtEgiO+wSDd6gGbfYmoSSULPOmkN0hveReGRpyTnQjeHk9GWaK5r4AGphoO0NwqlMAa1uPJpQfjv05sq3rjtL4=
Message-ID: <9ea470500802140542m325f05bdq256d3578950e4240@mail.gmail.com>
Date: Thu, 14 Feb 2008 14:42:58 +0100
From: "Boris Petkov" <petkovbb@googlemail.com>
To: "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>
Subject: Re: IDE cdrom problem with PLEXTOR DVDR PX-608AL
Cc: petkovbb@gmail.com, "Hans-Peter Jansen" <hpj@urpla.net>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
In-Reply-To: <200802141324.06731.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200802121026.17420.hpj@urpla.net>
	 <200802140037.51450.hpj@urpla.net>
	 <20080214062652.GE13446@gollum.tnic>
	 <200802141324.06731.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/14/08, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> On Thursday 14 February 2008, Borislav Petkov wrote:
> > On Thu, Feb 14, 2008 at 12:37:50AM +0100, Hans-Peter Jansen wrote:
> >
> > [Added Bart to CC]
> >
> > > Am Dienstag, 12. Februar 2008 schrieb Borislav Petkov:
> > > > On Tue, Feb 12, 2008 at 10:26:17AM +0100, Hans-Peter Jansen wrote:
> > > > > Hi,
> > > > >
> > > > > I suffer from unreliable cdrom operations (failing DAE and burn
> > > > > sessions) with the openSUSE 2.6.18.8-0.7-bigsmp kernel.
> > > >
> > > >                   ^^^^
> > > > Hi,
> > > >
> > > > can please you test this with a more recent kernel. Yours is almost
> > > > ancient - from Sep. 2006.
> > >
> > > Sure, sorry. Here we go:
> > >
> > > Feb 14 00:18:18 kernel: hde: cdrom_pc_intr: The drive appears confused (ireason = 0x01).
> > >  Trying to recover by ending request.
> > > Feb 14 00:27:27 kernel: hdc: cdrom_pc_intr: The drive appears confused (ireason = 0x01).
> > >  Trying to recover by ending request.
> > >
> > > ~> uname -a
> > > Linux xrated 2.6.24.1-35-pae #1 SMP 2008/02/12 01:00:18 UTC i686 athlon i386 GNU/Linux
> >
> > Actually the interrupt handler in ide-cd got rewritten and you're still using the
> > old one (cdrom_pc_intr vs cdrom_newpc_intr). Those changes went into mainline before
> > the 2.6.25-rc1 so we'll be able to test the new one only when you try out 2.6.25-rc1
> > or wait until 2.6.25 is released in case you don't want to try hazardous materials
> > such as an -rc kernel[*] :).
> >
> > Bart?
> >
> > *. As a matter of fact it runs quite smoothly on my machines.
>
> 2.6.25-rc1-git1 if you are using IDE.
>
> however it may still have this problem
>
>        if (ireason == 0) {
>                write = 1;
>                xferfunc = HWIF(drive)->atapi_output_bytes;
>        } else if (ireason == 2 || (ireason == 1 &&
>                   (blk_fs_request(rq) || blk_pc_request(rq)))) {
>
> we problably need to call ide_cd_check_ireason() also for REQ_TYPE_ATA_PC
> requests and remove (blk_fs_request(rq) || blk_pc_request(rq) here
>
>                write = 0;
>                xferfunc = HWIF(drive)->atapi_input_bytes;
>        } else {
>                printk(KERN_ERR "%s: %s: The drive "
>                                "appears confused (ireason = 0x%02x). "
>                                "Trying to recover by ending request.\n",
>                                drive->name, __FUNCTION__, ireason);
>                goto end_request;
>        }
>
> Bart
>
Hans-Peter,

i will prepare a patch against 2.6.24 for you to try later.

Thanks,
Boris.
