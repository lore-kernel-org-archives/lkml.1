Return-Path: <linux-kernel-owner+w=401wt.eu-S937325AbXFGXVM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937325AbXFGXVM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 19:21:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936875AbXFGXU4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 19:20:56 -0400
Received: from ozlabs.org ([203.10.76.45]:56269 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935898AbXFGXUy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 19:20:54 -0400
Date: Thu, 7 Jun 2007 18:16:21 -0500
From: Anton Blanchard <anton@samba.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Will Schmidt <will_schmidt@vnet.ibm.com>, linux-kernel@vger.kernel.org,
       liuxppc-dev@ozlabs.org
Subject: Re: [PATCH 1/3] [PATCH i386] during VM oom condition, kill all threads in process group
Message-ID: <20070607231621.GB32549@kryten>
References: <20070605174831.21740.33119.stgit@farscape.rchland.ibm.com> <20070607153459.2a1b3230.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070607153459.2a1b3230.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 
Hi,

> zap_other_threads() requires tasklist_lock.
> 
> If we're going to do this then we should probably create some new function
> (with a better name) which takes tasklsit_lock and then calls
> zap_other_threads().
> 
> Does this patch fix any observed-in-the-real-world problem?  If so, please
> describe it.

Yeah we have had complaints where threaded apps have only one thread
shot down instead of the entire process. This leaves the application in
a bad state, whereas if it had been killed cleanly the application could
have restarted.

My understanding is that fatal signals should kill all threads in the
group.

Anton
