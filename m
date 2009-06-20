Return-Path: <linux-kernel-owner+w=401wt.eu-S1754573AbZFTOjX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573AbZFTOjX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 10:39:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752952AbZFTOjE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 10:39:04 -0400
Received: from netrider.rowland.org ([192.131.102.5]:38794 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752289AbZFTOjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 10:39:01 -0400
Date: Sat, 20 Jun 2009 10:39:03 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Ravish Tayal <ravish.tayal@gmail.com>
cc: linux-kernel@vger.kernel.org, <linux-fsdevel@vger.kernel.org>,
       <linux-scsi@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: generic_make_request fucntion for scsi_disk
In-Reply-To: <e42309110906200705j6a731ecay204969f639af5330@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.0906201032170.12994-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Jun 2009, Ravish Tayal wrote:

> Hello,
> 
> I am debugging Filesystem code for USB mass storage devices.

What part of the filesystem code are you debugging?

Your questions talk about four separate layers: the filesystem, the
block layer, the SCSI layer, and the usb-storage driver.  Normally
people work on only one layer at a time.

Why are you concerned with more than one layer?

>  I need
> help to figure out after generic_make_request how the request is
> placed to scsi disk (sd) requeset queue and than how sd qeueuecommand
> to usb_storeage thread.  (in which context, is it system call context)
> 
> 
> inside generic_make_request
> 
> 1.   q = bdev_get_queue(bio->bi_bdev);  [is sd.c register queue this
> queue or any other scsi file?]

See scsi_alloc_sdev() in scsi_scan.c.  That's where the queue is 
allocated.

> 2.     ret = q->make_request_fn(q, bio);  [which file contain this
> make_request_fn for scsi disk driver (generic)]

scsi_request_fn() is in scsi_lib.c.  You could have found this out by 
yourself very easily with grep.  sd_prep_fn() is in sd.c.

> As per my unsderanding flow is like
> Fat_writepage ->_block_write_full_page --> blkdev_writepage-->
> block_write_full_page-->submit_bh-->generic_make_request ???  (sd ??)
> ----> queuecommand
> 
> Please suggest any sorce file, link or document.

The most relevant source files are scsi_lib.c and scsi.c.

Alan Stern

