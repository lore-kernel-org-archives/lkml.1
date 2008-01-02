Return-Path: <linux-kernel-owner+w=401wt.eu-S1757236AbYABUSQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757236AbYABUSQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 15:18:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752893AbYABUSA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 15:18:00 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:48936 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786AbYABUR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 15:17:59 -0500
Date: Wed, 2 Jan 2008 20:17:34 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Wilcox <matthew@wil.cx>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] scsi: revert "[SCSI] Get rid of scsi_cmnd->done"
Message-ID: <20080102201734.GA13881@infradead.org>
References: <20080102162534.GA4041@elte.hu> <1199292381.3258.32.camel@localhost.localdomain> <alpine.LFD.1.00.0801021113150.32517@woody.linux-foundation.org> <20080102194030.GC11638@parisc-linux.org> <alpine.LFD.1.00.0801021151420.32517@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0801021151420.32517@woody.linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 02, 2008 at 11:57:10AM -0800, Linus Torvalds wrote:
> 
> 
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

I think you misunderstood Matthew here.  REQ_TYPE_BLOCK_PC is indeed
used by any kind of SG_IO or similar passthrough no matter where it
originates.  And exactly because REQ_TYPE_BLOCK_PC are entirely passthru
the actual driver (sd, sr or sg) is not doing the actual command
completion but it's handled in the scsi layer because it's exactly
the same no matter what driver it came on.

