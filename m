Return-Path: <linux-kernel-owner+w=401wt.eu-S1760696AbYEWB13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760696AbYEWB13 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 21:27:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750750AbYEWB1U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 21:27:20 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60057 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750696AbYEWB1T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 21:27:19 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: Tree for May 22
Date: Fri, 23 May 2008 03:27:49 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Borislav Petkov <petkovbb@gmail.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Andrew Morton <akpm@linux-foundation.org>
References: <20080522165209.ef2cb160.sfr@canb.auug.org.au>
In-Reply-To: <20080522165209.ef2cb160.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805230327.51067.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 22 of May 2008, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since next-20080522:
> 
> The three patches reverted from the driver-core tree yesterday have been
> removed from there.
> 
> The net tree (actually the wireless tree) had a trivial conflict with the
> wireless-current tree.
> 
> One of the sound tree build patches has been merged.
> 
> The semaphore-removal tree still needed three patches reverted because similar
> patches were merged into upstream and the scsi-rc-fixes trees.
> 
> The bkl-removal tree had a conflict with the arm tree because the arm
> tree removed a file that was changed.
> 
> I have applied the following temporary patch for known build problems:
> 
> 	"Fix various 8390 builds" - the net tree broke builds on various
> architectures - hopefully this patch will go into the net tree shortly.
> 	"build failure with netfilter on __nf_ct_helper_find()" - breakage
> due to the moving of stuff from list.h to rculist.h

This one and the previous linux-next can't resume from suspend to RAM on my
HP nx6325.  The problem is reliably reproducible 100% of the time.

The patch that causes it to happen, as identified by bisection, is:

commit 3dcefa9419f3b8a49921d2218c93a3ddba8e0855
Author: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date:   Thu May 22 10:40:19 2008 +1000

    ide: use __generic_unplug_device() in ide_do_drive_cmd()

    Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
    Cc: Borislav Petkov <petkovbb@gmail.com>
    Cc: Jens Axboe <jens.axboe@oracle.com>
    Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Reverting it along with the next IDE patches (up to and including
commit fd42e6df0fd163411f5c655b4bde4fb6a8910edc
"ide: remove action argument in ide_do_drive_cmd") makes the problem go away.

Thanks,
Rafael
