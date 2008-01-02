Return-Path: <linux-kernel-owner+w=401wt.eu-S1759266AbYABUuK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759266AbYABUuK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 15:50:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753437AbYABUt6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 15:49:58 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:32802 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753408AbYABUt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 15:49:57 -0500
Date: Wed, 2 Jan 2008 12:49:32 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Christoph Hellwig <hch@infradead.org>
cc: Matthew Wilcox <matthew@wil.cx>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] scsi: revert "[SCSI] Get rid of scsi_cmnd->done"
In-Reply-To: <20080102201734.GA13881@infradead.org>
Message-ID: <alpine.LFD.1.00.0801021245460.32517@woody.linux-foundation.org>
References: <20080102162534.GA4041@elte.hu> <1199292381.3258.32.camel@localhost.localdomain> <alpine.LFD.1.00.0801021113150.32517@woody.linux-foundation.org> <20080102194030.GC11638@parisc-linux.org> <alpine.LFD.1.00.0801021151420.32517@woody.linux-foundation.org>
 <20080102201734.GA13881@infradead.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 2 Jan 2008, Christoph Hellwig wrote:
> 
> I think you misunderstood Matthew here.  REQ_TYPE_BLOCK_PC is indeed
> used by any kind of SG_IO or similar passthrough no matter where it
> originates.  And exactly because REQ_TYPE_BLOCK_PC are entirely passthru
> the actual driver (sd, sr or sg) is not doing the actual command
> completion but it's handled in the scsi layer because it's exactly
> the same no matter what driver it came on.

You say that, but you then ignore that something *did* change.

Maybe it's not that one suspicious test. Maybe it's somethign else. But 
that commit was confirmed to break something, almost two months ago. You 
guys seem to be in denial, and saying "it didn't change anything".

And no, waiting for more reporters when one reporter has already narrowed 
it down to the exact (smallish) commit, is simply not good. Either you can 
fix it by looking at the source, or it gets reverted.

I was hoping somebody in SCSI-land would actually look at the commit and 
try to find out what's wrong, instead of all of you apparently trying to 
say "nothing is wrong".

I hate the excuses of "but, but, but.. it *should* work". It doesn't. Face 
that, *then* you can argue about why.

			Linus
