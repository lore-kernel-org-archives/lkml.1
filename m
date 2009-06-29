Return-Path: <linux-kernel-owner+w=401wt.eu-S1757835AbZF2InV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757835AbZF2InV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 04:43:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751434AbZF2InM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 04:43:12 -0400
Received: from mga09.intel.com ([134.134.136.24]:33368 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750860AbZF2InL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 04:43:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,308,1243839600"; 
   d="scan'208";a="528663550"
Subject: Re: [PATCH 0/10] Per-bdi writeback flusher threads v12
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz, richard@rsk.demon.co.uk,
       damien.wyart@free.fr, fweisbec@gmail.com, Alan.Brunelle@hp.com
In-Reply-To: <1245926523-21959-1-git-send-email-jens.axboe@oracle.com>
References: <1245926523-21959-1-git-send-email-jens.axboe@oracle.com>
Content-Type: text/plain
Date: Mon, 29 Jun 2009 16:43:37 +0800
Message-Id: <1246265017.2560.446.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-06-25 at 12:41 +0200, Jens Axboe wrote:
> Hi,
> 
> Here's the 12th version of the writeback patches. Changes since v11:
> 
> - Fixup kthread_run() error check, it should use IS_ERR() instead of
>   checking for NULL. Thanks Andrew.
> - Fix a silly buglet that would quickly respawn otherwise idle threads
>   once they had exited. This was due to an inverted if test. Didn't cause
>   any harm except potentially too many writeback threads setting idle in
>   the system.
> - Integrate kupdate periodic writeback with the explicit writeback. Cleans
>   that part up.
> - Update to 2.6.31-rc1. With the recent patches from viro and hch, v11
>   did not apply cleanly at all to 2.6.31-rc1.
> 
> For ease of patching, I've put the full diff here:
> 
>   http://kernel.dk/writeback-v12.patch
> 
> and also stored this in a writeback-v12 branch that will not change,
> you can pull that into Linus tree from here:
> 
>   git://git.kernel.dk/linux-2.6-block.git writeback-v12
> 

> Please test and report results/interesting finds.
I tested it against 2.6.31-rc1 on a couple of machines.
1) System didn't hang;
2) Comapring with previous bdi flusher versions, I didn't find clear performance
different.

>  Thanks! The target
> for this patchset is 2.6.32 and it'll be sitting (and has been for the past


