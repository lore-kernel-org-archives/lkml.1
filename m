Return-Path: <linux-kernel-owner+w=401wt.eu-S1756765AbYJMO1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756765AbYJMO1q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 10:27:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754825AbYJMO1h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 10:27:37 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:47878 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033AbYJMO1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 10:27:36 -0400
To: penberg@cs.helsinki.fi
CC: nickpiggin@yahoo.com.au, hugh@veritas.com, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       cl@linux-foundation.org, akpm@linux-foundation.org
In-reply-to: <E1KpNwq-0003OW-8f@pomaz-ex.szeredi.hu> (message from Miklos
	Szeredi on Mon, 13 Oct 2008 15:59:00 +0200)
Subject: Re: SLUB defrag pull request?
References: <1223883004.31587.15.camel@penberg-laptop> <1223883164.31587.16.camel@penberg-laptop> <Pine.LNX.4.64.0810131227120.20511@blonde.site> <200810132354.30789.nickpiggin@yahoo.com.au> <E1KpNwq-0003OW-8f@pomaz-ex.szeredi.hu>
Message-Id: <E1KpOOL-0003Vf-9y@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 13 Oct 2008 16:27:25 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Oct 2008, Miklos Szeredi wrote:
> On Mon, 13 Oct 2008, Nick Piggin wrote:
> > In many cases, yes it seems to. And some of the approaches even if
> > they work now seem like they *might* cause problematic constraints
> > in the design... Have Al and Christoph reviewed the dentry and inode
> > patches?
> 
> This d_invalidate() looks suspicious to me:

And the things kick_inodes() does without any sort of locking look
even more dangerous.

It should be the other way round: first make sure nothing is
referencing the inode, and _then_ start cleaning it up with
appropriate locks held.  See prune_icache().

Miklos
