Return-Path: <linux-kernel-owner+w=401wt.eu-S1755916AbXFZIWI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916AbXFZIWI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 04:22:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751817AbXFZIVo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 04:21:44 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33009 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751289AbXFZIVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 04:21:43 -0400
Date: Tue, 26 Jun 2007 01:18:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: clameter@sgi.com
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Pekka Enberg <penberg@cs.helsinki.fi>, suresh.b.siddha@intel.com
Subject: Re: [patch 15/26] Slab defrag: Support generic defragmentation for
 inode slab caches
Message-Id: <20070626011836.f4abb4ff.akpm@linux-foundation.org>
In-Reply-To: <20070618095917.005535114@sgi.com>
References: <20070618095838.238615343@sgi.com>
	<20070618095917.005535114@sgi.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jun 2007 02:58:53 -0700 clameter@sgi.com wrote:

> This implements the ability to remove inodes in a particular slab
> from inode cache. In order to remove an inode we may have to write out
> the pages of an inode, the inode itself and remove the dentries referring
> to the node.
> 
> Provide generic functionality that can be used by filesystems that have
> their own inode caches to also tie into the defragmentation functions
> that are made available here.

Yes, this is tricky stuff.  I have vague ancestral memories that the sort
of inode work which you refer to here can cause various deadlocks, lockdep
warnings and such nasties when if we attempt to call it from the wrong
context (ie: from within fs code).

Possibly we could prevent that by skipping all this code if the caller
didn't have __GFP_FS.


I trust all the code in kick_inodes() was carefuly copied from
prue_icache() and such places - I didn't check it.

