Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936073Ab0COJ4O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 05:56:14 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:52690 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936058Ab0COJ4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 05:56:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=a02r5vHujK6g0BaZaRpnLpOaHuhVFgaJu9Hi1EFbMm2JgKvAzC4NhrSI/JU4a4oRSd
         P5+nfsTMO/2KAYhbpFuMVtH7nhfOWrJlp11qfiHRhXlSzSdImWdHUnY+qoF7YH8MdlZg
         kGJA9QDUFbaVjCharuVmG559upvoC8JJYvbAs=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: david@lang.hm
Subject: Re: ATA 4 KiB sector issues.
Date: Mon, 15 Mar 2010 10:56:05 +0100
User-Agent: KMail/1.8.2
Cc: "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>,
       Tejun Heo <tj@kernel.org>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Daniel Taylor <Daniel.Taylor@wdc.com>, Jeff Garzik <jeff@garzik.org>,
       Mark Lord <kernel@teksavvy.com>, tytso@mit.edu,
       hirofumi@mail.parknet.co.jp, Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, irtiger@gmail.com,
       Matthew Wilcox <matthew@wil.cx>, aschnell@suse.de, knikanth@suse.de,
       jdelvare@suse.de
References: <4B947393.2050002@kernel.org> <201003150326.22262.vda.linux@googlemail.com> <alpine.DEB.2.00.1003142216380.15263@asgard.lang.hm>
In-Reply-To: <alpine.DEB.2.00.1003142216380.15263@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201003151056.05833.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 15 March 2010 06:20, david@lang.hm wrote:
> >>> For any other partition, pick start cylinder which is a multiple of 8:
> >>>
> >>> cyl 8*x head 0 sector 1: LBA sector 8*x*255*63 - good (4k aligned)
> >>>
> >>> This will actually work well for *any* geometry, not only for 63s/255h.
> >>
> >> Yes, but it does squat for a flash disk that wants, say, 256K alignment.
> >
> > 4K makes sense. 256K not so much.
> >
> > 256K alignment is hard to swallow for a lot of reasons anyway.
> > Unless the filesystem packs small files into blocks a-la reiserfs,
> > 256K block filesystems will be very inefficient for a typical
> > storage scenarios.
> 
> the thing is, if the OS can learn that it's more efficiant to write in 
> 256K aligned chunks, then it can batch up things so that the drive doesn't 
> have to do a read-modify-write cycle and can instead just replace the 
> entire chunk.

I think Linux already is doing this. The problem is, in many cases
OS can't possibly do this, short of using a specially designed
filesystem.

If you untar a Linux kernel source tarball on a seriously
fragmented ext2 filesystem, there will be a lot of discontiguous
and/or misaligned writes smaller than 256K.
Only smart firmware can help in this case.
-- 
vda
