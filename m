Return-Path: <linux-kernel-owner+w=401wt.eu-S1753838AbYABT6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838AbYABT6V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 14:58:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751837AbYABT6N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 14:58:13 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51334 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751144AbYABT6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 14:58:12 -0500
Date: Wed, 2 Jan 2008 11:57:10 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Matthew Wilcox <matthew@wil.cx>
cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] scsi: revert "[SCSI] Get rid of scsi_cmnd->done"
In-Reply-To: <20080102194030.GC11638@parisc-linux.org>
Message-ID: <alpine.LFD.1.00.0801021151420.32517@woody.linux-foundation.org>
References: <20080102162534.GA4041@elte.hu> <1199292381.3258.32.camel@localhost.localdomain> <alpine.LFD.1.00.0801021113150.32517@woody.linux-foundation.org> <20080102194030.GC11638@parisc-linux.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 2 Jan 2008, Matthew Wilcox wrote:
> 
> sd_done and sr_done are called for REQ_TYPE_FS -- if the request comes
> in through one of the SG interfaces, we call scsi_setup_blk_pc_cmnd()
> which sets the ->done callback to scsi_blk_pc_done.

Why do you think that REQ_TYPE_BLOCK_PC has anything to do with SG?

It has *nothing* to do with SG, and anybody who uses SG in this day and 
age on a block device is just crazy. 

The way you do generic SCSI commands (on perfectly normal block device 
nodes) is using the SCSI ioctl() interfaces.  That's how you are supposed 
to do things like burn DVD's or do any kind of special ops.

So REQ_TYPE_BLOCK_PC does quite commonly happen on perfectly regular block 
devices, it's how all commands that aren't pure reads or writes done by 
the kernel behave.

If you actually use /dev/sg*, you will be using the SG driver, and if you 
don't want that to have a ->done callback, then just set "done" to NULL 
for sg_driver.

			Linus
