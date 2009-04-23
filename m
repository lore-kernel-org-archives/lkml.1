Return-Path: <linux-kernel-owner+w=401wt.eu-S1754711AbZDWGf4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711AbZDWGf4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 02:35:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753629AbZDWGfo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 02:35:44 -0400
Received: from brick.kernel.dk ([93.163.65.50]:58411 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752252AbZDWGfn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 02:35:43 -0400
Date: Thu, 23 Apr 2009 08:35:42 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH] libata: rewrite SCSI host scheme to be one per ATA host
Message-ID: <20090423063542.GK4593@kernel.dk>
References: <20090422090929.GA14928@havoc.gtf.org> <49EEE225.3010700@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49EEE225.3010700@garzik.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 22 2009, Jeff Garzik wrote:
> Jeff Garzik wrote:
>> Currently, libata creates a Scsi_Host per port.  This was originally
>> done to leverage SCSI's infrastructure to arbitrate among master/slave
>> devices, but is not needed for most modern SATA controllers.   And I
>> _think_ it is not needed for master/slave if done properly, either.
>
> BTW note the above, with regards to the libata SCSI->block conversion.  
> libata currently relies on SCSI for some amount of generic device  
> arbitration, in several situations (see ->qc_defer,  
> SCSI_MLQUEUE_.*_BUSY).  libata expects SCSI to be intelligent and not  
> starve devices, etc.

Defer looks like internal policy, I don't see that functioning any
different in the block layer. SCSI_MLQUEUE_*_BUSY in SCSI is primarily
using the block layer functionality of BLKPREP_DEFER to begin with, so I
think we're pretty close to providing all that already.

-- 
Jens Axboe

