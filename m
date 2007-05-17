Return-Path: <linux-kernel-owner+w=401wt.eu-S1757366AbXEQNIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757366AbXEQNIS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 09:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755412AbXEQNIL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 09:08:11 -0400
Received: from wr-out-0506.google.com ([64.233.184.235]:37413 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754797AbXEQNIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 09:08:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Gl2WZYgSmBSZrzsI2SDYsKobgNBjCoZ5LERmgad9IcVVBUnRkomDyqy5fKRUDCVo3HTVL7sbphs9CRNGJn4g2FvzLLBFALo03qPUv7EATCIj0v0fb7yoq9DNEcFDAPoZeLv5ErFcVA5r9WE6Dz3aSzlizyZqCxAKHXWv+DR5uWM=
Message-ID: <64d833020705170608rbab5e56t605fa64c8e6ecb3c@mail.gmail.com>
Date: Thu, 17 May 2007 09:08:08 -0400
From: koan <koan00@gmail.com>
To: "Neil Brown" <neilb@suse.de>
Subject: Re: [2.6.20.11] File system corruption with degraded md/RAID-5 device
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <17995.47339.651121.146258@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <64d833020705161326m51922f63n31ef5b528a514ed7@mail.gmail.com>
	 <17995.47339.651121.146258@notabene.brown>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Neil,

I ran the drives in RAID-0 as you suggested and noticed the same problem.

I also ran memtest86 over night but there were no errors.

I did notice this SIL3114 card doesn't play nice with the other
promise cards (or vice versa). I had to swap them arroudn in the PCI
slots for the system to boot at all. I'll try removing the additional
hardware and see if that resolves the issue.

Thanks, Jesse



On 5/16/07, Neil Brown <neilb@suse.de> wrote:
> On Wednesday May 16, koan00@gmail.com wrote:
> >
> > Here is what I am doing to test:
> >
> > fdisk /dev/sda1 and /dev/sb1 to type fd/Linux raid auto
> > mdadm --create /dev/md1 -c 128 -l 5 -n 3 /dev/sda1 /dev/sdb1 missing
> > mke2fs -j -b 4096 -R stride=32 /dev/md1
> > e2fsck -f /dev/md1
> > ---------------------
> > Result: FAILS - fsck errors (Example: "Inode 3930855 is in use, but
> > has dtime set.")
>
> Very odd.  I cannot reproduce this, but then my drives are somewhat
> smaller than yours (though I'm not sure how that could be
> significant).
>
> Can you try a raid0 across 2 drives?  That would be more like the
> raid5 layout than raid1.
>
> My guess is some subtle hardware problem,  as I would be very
> surprised in the raid5 code is causing this.  Maybe run memtest86?
>
> NeilBrown
>
