Return-Path: <linux-kernel-owner+w=401wt.eu-S1758223AbYABUSq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758223AbYABUSq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 15:18:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756106AbYABUSL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 15:18:11 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:57140 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755855AbYABUSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 15:18:10 -0500
Date: Wed, 2 Jan 2008 13:18:09 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] scsi: revert "[SCSI] Get rid of scsi_cmnd->done"
Message-ID: <20080102201809.GD11638@parisc-linux.org>
References: <20080102162534.GA4041@elte.hu> <1199292381.3258.32.camel@localhost.localdomain> <alpine.LFD.1.00.0801021113150.32517@woody.linux-foundation.org> <20080102194030.GC11638@parisc-linux.org> <alpine.LFD.1.00.0801021151420.32517@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0801021151420.32517@woody.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 02, 2008 at 11:57:10AM -0800, Linus Torvalds wrote:
> On Wed, 2 Jan 2008, Matthew Wilcox wrote:
> > 
> > sd_done and sr_done are called for REQ_TYPE_FS -- if the request comes
> > in through one of the SG interfaces, we call scsi_setup_blk_pc_cmnd()
> > which sets the ->done callback to scsi_blk_pc_done.
> 
> Why do you think that REQ_TYPE_BLOCK_PC has anything to do with SG?
> 
> It has *nothing* to do with SG, and anybody who uses SG in this day and 
> age on a block device is just crazy. 
> 
> The way you do generic SCSI commands (on perfectly normal block device 
> nodes) is using the SCSI ioctl() interfaces.  That's how you are supposed 
> to do things like burn DVD's or do any kind of special ops.
> 
> So REQ_TYPE_BLOCK_PC does quite commonly happen on perfectly regular block 
> devices, it's how all commands that aren't pure reads or writes done by 
> the kernel behave.

I spoke imprecisely; a raw command one through SG or ioctl is
REQ_TYPE_BLOCK_PC and did not go through sd_done or sr_done before this
patch.

> If you actually use /dev/sg*, you will be using the SG driver, and if you 
> don't want that to have a ->done callback, then just set "done" to NULL 
> for sg_driver.

Unless you think that we should see different behaviour when using
/dev/sg* and /dev/sd*, the aspect of the patch you criticised was
correct.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
