Return-Path: <linux-kernel-owner+w=401wt.eu-S1752720AbZGAORN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720AbZGAORN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 10:17:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753005AbZGAOQ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 10:16:58 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43413 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752534AbZGAOQ5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 10:16:57 -0400
Date: Wed, 1 Jul 2009 15:17:27 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Theodore Tso <tytso@mit.edu>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Pavel Machek <pavel@ucw.cz>,
       tridge@samba.org, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       john.lanza@linux.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Steve French <sfrench@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] Added CONFIG_VFAT_FS_DUALNAMES option
Message-ID: <20090701151727.38928bd9@lxorguk.ukuu.org.uk>
In-Reply-To: <20090701140503.GA21185@mit.edu>
References: <19013.8005.541836.436991@samba.org>
	<20090630063102.GB1351@ucw.cz>
	<200907012019.53932.rusty@rustcorp.com.au>
	<20090701122558.3a7c80d3@lxorguk.ukuu.org.uk>
	<20090701140503.GA21185@mit.edu>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > shouldn't accidentally be able to specify -o vfat and get non-vfat. Thats
> > asking for incompatibility, data loss and unpleasant unwarned of suprises.
> 
> There really was no such thing as "vfat" anyway.  VFAT in the Windows

In the eyes of the end user there is such a thing as vfat. This is about
expectations not technical issues.
 
> Arguably what we should have done is kept it as a single filesystem,
> with a mount options "lfn" and "nolfn", but that's water under the
> bridge now.

Well we didn't so now we need to add "lfat" or similar for our fat style.
Doesn't need new code just making sure that USSA_COMPLIANCE_MODE=y
causes mount -o lfat to work and without it both lfat and vfat work.

> The other big user I can think of are digital cameras, but (a)
> normally most users read from them and then delete the pictures, and
> rarely write to media meant for a digital camera, and (b) the DCIM

Except when they hit save instead of "save as" and they get a long file
name and invisible loss of space on the camera.

> standard for digital cameras explicitly only supports 8.3 filenames
> and so digital camera manufacturers explicitly don't need to deal with
> Long File Names at all.  (Hmm.... I wonder why....)  

Can't think - but HAL should clearly mount those 8.3 to avoid the
problem. It seems to use the dcim to find them.

> This suggests that some userspace mechanism for detecting media cards
> used for cameras and explicitly mounting them with FAT might be useful

HAL is very good at that already.

> Ultimately, though, requiring that every single possible device be
> tested is probably not reasonable, so the best way to do this testing
> is the way do most of our testing; we do basic due diligence, but then
> we merge it into mainline and let our huge user community try it out.
> If there are regressions we can work through those issues if and when
> they arise.

>From the funnies we've had in the past with FAT my gut impression is
there are only a few implementations out there. Psion seems to have their
own but most of the rest behave remarkably similarly which makes me
suspect they all licensed a tiny number of implementations (DRDOS one
perhaps ?). If we can keep most of those devices mounted 8.3 we nicely
sidestep the issue anyway.

Alan
