Return-Path: <linux-kernel-owner+w=401wt.eu-S1754002AbXJVUR2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002AbXJVUR2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 16:17:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752633AbXJVURS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 16:17:18 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:37592 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752587AbXJVURR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 16:17:17 -0400
Date: Mon, 22 Oct 2007 21:16:17 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Erez Zadok <ezk@cs.sunysb.edu>, Ryan Finnie <ryan@finnie.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, cjwatson@ubuntu.com, linux-mm@kvack.org
Subject: Re: msync(2) bug(?), returns AOP_WRITEPAGE_ACTIVATE to userland
In-Reply-To: <84144f020710150447o94b1babo8b6e6a647828465f@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0710222101420.23513@blonde.wat.veritas.com>
References: <Pine.LNX.4.64.0710142049000.13119@sbz-30.cs.Helsinki.FI> 
 <200710142232.l9EMW8kK029572@agora.fsl.cs.sunysb.edu>
 <84144f020710150447o94b1babo8b6e6a647828465f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Oct 2007, Pekka Enberg wrote:
> 
> I wonder whether _not setting_ BDI_CAP_NO_WRITEBACK implies that
> ->writepage() will never return AOP_WRITEPAGE_ACTIVATE for
> !wbc->for_reclaim case which would explain why we haven't hit this bug
> before. Hugh, Andrew?

Only ramdisk and shmem have been returning AOP_WRITEPAGE_ACTIVATE.
Both of those set BDI_CAP_NO_WRITEBACK.  ramdisk never returned it
if !wbc->for_reclaim.  I contend that shmem shouldn't either: it's
a special code to get the LRU rotation right, not useful elsewhere.
Though Documentation/filesystems/vfs.txt does imply wider use.

I think this is where people use the phrase "go figure" ;)

Hugh
