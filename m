Return-Path: <linux-kernel-owner+w=401wt.eu-S1759587AbXFSFwl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759587AbXFSFwl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 01:52:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755501AbXFSFw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 01:52:28 -0400
Received: from verein.lst.de ([213.95.11.210]:36261 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753947AbXFSFw1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 01:52:27 -0400
Date: Tue, 19 Jun 2007 07:51:58 +0200
From: Christoph Hellwig <hch@lst.de>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       Jens Axboe <axboe@kernel.dk>,
       "James E.J. Bottomley" <James.Bottomley@SteelEye.com>,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 5/6] ps3: ROM Storage Driver
Message-ID: <20070619055158.GC18542@lst.de>
References: <20070615113919.142332000@pademelon.sonytel.be> <20070615120848.454492000@pademelon.sonytel.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070615120848.454492000@pademelon.sonytel.be>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Looks pretty nice.

Some more comments:

 - no need for the BLK_DEV_SR dependency, it should depend on SCSI
   instead (which might be implied by beeing in the scsi menu, don't
   remember that detail)
 - ps3rom_priv should probably be an inline
 - the cmd field in struct ps3rom_private should probably be renamed
   to curr_cmd or something along the line to make sure this is the
   current command we deal with and the driver can only deal with one
   command at a time.
 - The comment in ps3rom_queuecommand should explain why we prefer
   lv1_storage_{read,write} over just sending down the scsi cdb,
   not just that we prefer it.
 - I don't think you need to decode the 6 byte commands at all,
   ATAPI only has the 10 byte variants and you can tell the scsi
   layer not to ever send the 6 byte ones by setting the use_10_for_rw
   flag in ->slave_configure
 - same comment about the free_irq/request_irq pair as in the disk
   driver.
 - please use the new shost_priv helper in scsi-misc for accessing
   the hostdata file in struct Scsi_Host so that the ugly casts
   can go away.
