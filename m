Return-Path: <linux-kernel-owner+w=401wt.eu-S1758978AbYABUpx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758978AbYABUpx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 15:45:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754658AbYABUpo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 15:45:44 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47239 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752875AbYABUpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 15:45:43 -0500
Date: Wed, 2 Jan 2008 12:45:25 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
cc: Matthew Wilcox <matthew@wil.cx>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] scsi: revert "[SCSI] Get rid of scsi_cmnd->done"
In-Reply-To: <1199304735.3258.53.camel@localhost.localdomain>
Message-ID: <alpine.LFD.1.00.0801021227140.32517@woody.linux-foundation.org>
References: <20080102162534.GA4041@elte.hu>  <1199292381.3258.32.camel@localhost.localdomain>  <alpine.LFD.1.00.0801021113150.32517@woody.linux-foundation.org>  <20080102194030.GC11638@parisc-linux.org> <1199304735.3258.53.camel@localhost.localdomain>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 2 Jan 2008, James Bottomley wrote:
> 
> OK ... I'll revert it.  However, I still think it's the wrong course of
> action, because as far as my analysis goes, this code is functionally
> equivalent to what went before with the exception that we now rely on
> the request->cmd_type information in the post processing (previously we
> just relied on the cmnd->done pointer).

To say that another way:

 "the code is functionally equivalent, EXCEPT IT ISN'T, and it's 
  known to be broken".

wouldn't you say my version is more honest and correct?

The old code did a per-command callback. The new one doesn't. The code was 
*supposed* to be equivalent, but it clearly isn't. Why argue the point?

And no, maybe it's not that REQ_TYPE_BLOCK_PC should be calling ->done, 
maybe it's that some REQ_TYPE_FS commands should *not* be calling ->done. 
Or maybe we somehow got the wrong ->done in the first place, because we 
now get it from a different source.

I don't know, but what I'm arguing (very strongly) against is this 
attitude of "we don't know what's wrong, but wë́'ll leave it broken because 
we can't be bothered to figure it out".

That is exactly what reverting is there for. It doesn't matter one *whit* 
if the new code is cleaner and prettier, if it doesn't work.

			Linus
