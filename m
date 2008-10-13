Return-Path: <linux-kernel-owner+w=401wt.eu-S1756923AbYJMOgM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756923AbYJMOgM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 10:36:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754757AbYJMOf4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 10:35:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48535 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754519AbYJMOfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 10:35:55 -0400
Message-ID: <48F378C6.7030206@linux-foundation.org>
Date: Mon, 13 Oct 2008 09:35:18 -0700
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: penberg@cs.helsinki.fi, nickpiggin@yahoo.com.au, hugh@veritas.com,
       linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: SLUB defrag pull request?
References: <1223883004.31587.15.camel@penberg-laptop> <1223883164.31587.16.camel@penberg-laptop> <Pine.LNX.4.64.0810131227120.20511@blonde.site> <200810132354.30789.nickpiggin@yahoo.com.au> <E1KpNwq-0003OW-8f@pomaz-ex.szeredi.hu> <E1KpOOL-0003Vf-9y@pomaz-ex.szeredi.hu>
In-Reply-To: <E1KpOOL-0003Vf-9y@pomaz-ex.szeredi.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi wrote:
> And the things kick_inodes() does without any sort of locking look
> even more dangerous.
>
> It should be the other way round: first make sure nothing is
> referencing the inode, and _then_ start cleaning it up with
> appropriate locks held.  See prune_icache().
>
>   
kick_inodes() only works on inodes that first have undergone 
get_inodes() where we establish a refcount under inode_lock(). The final 
cleanup in kick_inodes() is done under iprune_mutex. You are looking at 
the loop that does writeback and invalidates attached dentries. This can 
fail for various reasons.

