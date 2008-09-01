Return-Path: <linux-kernel-owner+w=401wt.eu-S1753416AbYIAIB0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416AbYIAIB0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 04:01:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751968AbYIAIBR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 04:01:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:35856 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751960AbYIAIBQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 04:01:16 -0400
Message-ID: <48BBA0B0.5070309@kernel.org>
Date: Mon, 01 Sep 2008 09:58:40 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       dm-devel@redhat.com, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: 2.6.27-rc5-mmotm0829 - lvm issues at boot, possible disk_devt()
 related?
References: <4963.1220240176@turing-police.cc.vt.edu>
In-Reply-To: <4963.1220240176@turing-police.cc.vt.edu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 01 Sep 2008 07:59:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu wrote:
> I bisected this down to the 08/28 version of linux-next.patch that was in
> mmotm-0829.  27-rc3-mmotm0814 works fine.
> 
> System boots, loads the initrd, starts running.  The initrd tries to run lvm
> to find my root file system (the one drive has sda1 a small /boot, and sda2
> is the rest of the disk, and LVM space).  Every single partition complains:
> 
> device-mapper: core: bdget failed in dm_suspend
> device-mapper: resume ioctl failed: invalid argument
> Unable to resume Volgroup00-root (254:0)
> 
> and repeats the 3 lines with different Volgroup-foo and 254:N values for
> each LVM logical volume.  After this, it rolls over and dies because it
> didn't find the root filesystem.  
> 
> This is with an initrd build with Fedora Rawhide current as of last night.
> Using an older initrd that's been working just fine for several releases
> just silently hangs around the lvm startup. (My initrd config does not include
> any .ko files, just nash and lvm and similar early-userspace stuff).
> 
> Any ideas?  Am willing to try patches/debugging code, if anybody can think
> what I should be instrumenting to get more info.
> 
> My gut feeling is an issue in Tejun Heo's patches to implement extended dev
> numbers - one of these two or a related patch:

Yeah, I made a mistake converting two of them and devt lookup fails when
the disk is zero sized.  Bartlomiej debugged the problem and posted a
patch and I followed up with an updated patch.  It should be fine in the
next round.

  http://article.gmane.org/gmane.linux.kernel.next/2663
  http://article.gmane.org/gmane.linux.kernel.next/2676

If you're seeing other problems, please let me know.

Thanks.

-- 
tejun
