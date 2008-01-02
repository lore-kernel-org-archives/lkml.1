Return-Path: <linux-kernel-owner+w=401wt.eu-S1756626AbYABTkj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756626AbYABTkj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 14:40:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753152AbYABTkc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 14:40:32 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:48254 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153AbYABTkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 14:40:32 -0500
Date: Wed, 2 Jan 2008 12:40:30 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] scsi: revert "[SCSI] Get rid of scsi_cmnd->done"
Message-ID: <20080102194030.GC11638@parisc-linux.org>
References: <20080102162534.GA4041@elte.hu> <1199292381.3258.32.camel@localhost.localdomain> <alpine.LFD.1.00.0801021113150.32517@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0801021113150.32517@woody.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 02, 2008 at 11:19:14AM -0800, Linus Torvalds wrote:
> It's totally immaterial if we have one reporter or many. The fact is, that 
> thing has been outstanding for almost two months now. The root cause is 
> almost certainly known (and Matthew is apparently even aware of it), but 

I really don't think the root cause is known.

> By now, it needs to either have a patch, or to be reverted. It's too late 
> to make excuses.

I think reverting it is the correct thing to do.

> And no, it doesn't really need any more reporters or ways to reproduce it, 
> all it needs is looking at the patch and seeing what the differences are 
> AT A SOURCE level. And quite frankly, I see one huge honking difference, 
> which is that new test for 
> 
> 	if (cmd->request->cmd_type != REQ_TYPE_BLOCK_PC) 
> 
> which will disable all the crud that sd_done() does.

sd_done and sr_done are called for REQ_TYPE_FS -- if the request comes
in through one of the SG interfaces, we call scsi_setup_blk_pc_cmnd()
which sets the ->done callback to scsi_blk_pc_done.

> So I think you are making totally idiotic excuses. I may not know the SCSI 
> layer all that intimately, and maybe I'm wrong and there is some other 
> cause for this, but quite frankly, I doubt it. And I can look at just the 
> patch and have a damn good idea of why something is broken, but I can't 
> actually fix it myself because I don't know how to look up a a 
> "scsi_driver" from a "scsi_cmnd" sanely.

That's in the patch.  But it would be the wrong thing to do because SG
commands should not be molested by the sr/sd driver.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
