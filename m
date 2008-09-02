Return-Path: <linux-kernel-owner+w=401wt.eu-S1752468AbYIBKte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752468AbYIBKte (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 06:49:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751087AbYIBKt0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 06:49:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:60612 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751061AbYIBKtZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 06:49:25 -0400
Message-ID: <48BD19B1.9040207@kernel.org>
Date: Tue, 02 Sep 2008 12:47:13 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
CC: device-mapper development <dm-devel@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Problem w/ CONFIG_DEBUG_BLOCK_EXT_DEVT
References: <48BD173B.3090600@hp.com>
In-Reply-To: <48BD173B.3090600@hp.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 02 Sep 2008 10:48:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Alan D. Brunelle wrote:
> I have found two problems in LVM2/DM w/ a potential new "experimental
> feature" in 2.6.28: CONFIG_DEBUG_BLOCK_EXT_DEVT (this is from Jens
> Axboe's origin/for-2.6.28 git branch)

It's a debug option and I don't expect it to be enabled in any
production kernel.

> "Conventionally, block device numbers are allocated from predetermined
> contiguous area.  However, extended block area may introduce
> non-contiguous block device numbers.  This option forces most block
> device numbers to be allocated from the extended space and spreads them
> to discover kernel or userland code paths which assume predetermined
> contiguous device number allocation."
> 
> W/ LVM2 & DM there are (at least) two issues:
> 
> (1) Device major numbers for some reason are /not/ being entered
> correctly into /proc/devices -- w/ CONFIG_DEBUG_BLOCK_EXT_DEVT=y I am
> seeing some devices w/ major "259" (a SATA controller) but no entry in
> /proc/devices. LVM2/DM will not find the entry in /proc/devices, and not
> allow any device w/ that major to be used with LVM commands.

Hmmm.. Adding a call to register_blkdev(), which will create the
corresponding entry in /proc/devices, isn't difficult at all but which
name would it use?  It'll be mix of block devices (hd and sds
currently).  If we introduce a new name there, say, ext-block, would
that work?  BTW, is there any specific reason why LVM2/DM can't use
/sys/block/* ?

> (2) Device minor numbers can be quite large, and the 10-character limits
> in dm/lib/libdm-deptree.c are too small.

Would it be difficult to increase that?

Thanks.

-- 
tejun
