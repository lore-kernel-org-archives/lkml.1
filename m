Return-Path: <linux-kernel-owner+w=401wt.eu-S1755506AbZGCGrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506AbZGCGrT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 02:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752982AbZGCGrI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 02:47:08 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:54672 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856AbZGCGrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 02:47:07 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: tridge@samba.org
Cc: Jan Engelhardt <jengelh@medozas.de>, Theodore Tso <tytso@mit.edu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Rusty Russell <rusty@rustcorp.com.au>, Pavel Machek <pavel@ucw.cz>,
       john.lanza@linux.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, corbet@lwn.net,
       jcm@jonmasters.org
Subject: Re: CONFIG_VFAT_FS_DUALNAMES regressions
References: <19013.8005.541836.436991@samba.org>
	<20090630063102.GB1351@ucw.cz>
	<200907012019.53932.rusty@rustcorp.com.au>
	<20090701122558.3a7c80d3@lxorguk.ukuu.org.uk>
	<20090701140503.GA21185@mit.edu>
	<alpine.LSU.2.00.0907030056210.17183@fbirervta.pbzchgretzou.qr>
	<alpine.LSU.2.00.0907030134291.17183@fbirervta.pbzchgretzou.qr>
	<19021.19842.663727.146474@samba.org>
	<87hbxu60qm.fsf@devron.myhome.or.jp>
	<19021.23231.213863.726785@samba.org>
	<alpine.LSU.2.00.0907030347210.24650@fbirervta.pbzchgretzou.qr>
	<19021.26102.80885.330380@samba.org>
	<alpine.LSU.2.00.0907030403330.26905@fbirervta.pbzchgretzou.qr>
	<19021.31291.642416.956966@samba.org>
Date: Fri, 03 Jul 2009 15:46:59 +0900
In-Reply-To: <19021.31291.642416.956966@samba.org> (tridge@samba.org's message
	of "Fri, 3 Jul 2009 13:25:47 +1000")
Message-ID: <87tz1up8kc.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tridge@samba.org writes:

> right, that is not unexpected. It creates both the long name and the
> short name in this case as the short name is constrained to not be
> case preserving, and the filesystem normally tries to be both
> case-insensitive and case-preserving. As the long name has no
> constraints on the case of characters it creates both so that devices
> (like your camera I think) that only look at the 8.3 entries will see
> a file.
>
> That is why setting shortname=winnt is desirable when using the "no
> dualnames" patch I posted. That tells Linux to behave more like what
> current windows versions behave, which is to try and put it in the 8.3
> entry if it can, even if it is all lowercase.
>
> What I would like to see us do for maximum compatibility with devices
> like this, while still maximising the legal safety, is to take mixed
> case prefixes or suffixes that fit in 8.3 and uppercase them and set
> the CASE_LOWER_BASE and CASE_LOWER_EXT bits appropriately in the flags
> field, and not store a long name. That would makes us really nicely
> compatible with devices like your camera, at the price of losing mixed
> case preservation for 8.3 names.
>
> It would be another departure from previous behaviour however, so I
> want to get some feedback from Hirofumi-san first. 

I guess it would be depending on how many shortname only devices are
there though. At least for now, I'd like to keep that small.

Thanks.

> btw, if you still think your camera really is looking at the long
> filename entries, then try creating a file like DsCf2000.jpg with a
> unpatched kernel, mounted with shortname=winnt. That will create two
> directory entries for the file, one being DSCF2000.JPG and the other
> being DsCf2000.jpg.
>
> Then view the list of photos on the LCD back panel of your
> camera. Assuming it has a way to see the filename, does it display the
> mixed case name DsCf2000.jpg, or does it display a non-mixed name like
> dscf2000.jpg or DSCF2000.JPG.
>
> If it displays a mixed name (ie. DsCf) then your camera can indeed
> read long filename entries. If it displays a all uppercase or all
> lowercase name then I think it is only capable of reading short names
> from FAT filesystems. That is what I think you will find.
>
> Cheers, Tridge

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
