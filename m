Return-Path: <linux-kernel-owner+w=401wt.eu-S1751624AbZKNNSE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751624AbZKNNSE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Nov 2009 08:18:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751819AbZKNNSD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Nov 2009 08:18:03 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:25306 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540AbZKNNSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Nov 2009 08:18:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=UbMT/5Au1hZJrjVJPLinPH5Ea31nYiIRpShqlPfe45eNTr7SBGxUvdGLOZ+fKLO7vK
         knKH04RkWn4f9gSqYsRdCnM8r2H7u3T9rCHE8jZ1p9jdDj4X9TzEOiMa4dHRA2/vThN5
         iU16j/GEdRfUWqbwBadBf+okc7fAgqH0bJrlY=
Date: Sat, 14 Nov 2009 14:18:09 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: Frans Pop <elendil@planet.nl>, Nick Piggin <npiggin@suse.de>,
       jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Mount -o sync regression in 2.6.31
Message-ID: <20091114131804.GA5245@nowhere>
References: <20091111123340.703f5c86@nehalam> <200911112234.24180.elendil@planet.nl> <20091113144727.575cf038@nehalam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091113144727.575cf038@nehalam>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 13, 2009 at 02:47:27PM -0800, Stephen Hemminger wrote:
> Bisecting between 2.6.30 and 2.6.31-rc1 reduced it down to:
> 
> 8f184f27300f66f6dcc8296c2dae7a1fbe8429c9 is first bad commit
> commit 8f184f27300f66f6dcc8296c2dae7a1fbe8429c9
> Author: Frederic Weisbecker <fweisbec@gmail.com>
> Date:   Sat May 16 06:24:36 2009 +0200
> 
>     tracing/stat: replace linked list by an rbtree for sorting
>     
>     When the stat tracing framework prepares the entries from a tracer
>     to output them to the user, it starts by computing a linear sort
>     through a linked list to give the entries ordered by relevance
>     to the user.
>     
>     This is quite ugly and causes a small latency when we begin to
>     read the file.
>     
>     This patch changes that by turning the linked list into a red-black
>     tree. Athough the whole iteration using the start and next tracer
>     callbacks while opening the file remain the same, it is now much
>     more fast and scalable.
>     
>     The rbtree guarantees O(log(n)) insertions whereas a linked
>     list with linear sorting brought us a O(n) despair. Now the
>     (visible) latency has disapeared.
>     
>     [ Impact: kill the latency while starting to read a stat tracer file ]
>     
>     Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> 
> Which seems totally out of the path related to this, and no tracing is being done!


The trace stat thing is only used for workqueue profiling,
functions profiling, branch profiling:

CONFIG_WORKQUEUE_TRACER
CONFIG_FUNCTION_PROFILER
CONFIG_PROFILE_ANNOTATED_BRANCHES
CONFIG_PROFILE_ALL_BRANCHES


And none of them seem enabled in your config.

