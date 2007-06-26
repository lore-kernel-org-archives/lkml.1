Return-Path: <linux-kernel-owner+w=401wt.eu-S1758808AbXFZSi4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758808AbXFZSi4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 14:38:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757580AbXFZSis
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 14:38:48 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45848 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757507AbXFZSir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 14:38:47 -0400
Date: Tue, 26 Jun 2007 11:38:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Pekka Enberg <penberg@cs.helsinki.fi>, suresh.b.siddha@intel.com
Subject: Re: [patch 12/26] SLUB: Slab defragmentation core
Message-Id: <20070626113823.d78d8c0c.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0706261114320.18010@schroedinger.engr.sgi.com>
References: <20070618095838.238615343@sgi.com>
	<20070618095916.297690463@sgi.com>
	<20070626011831.181d7a6a.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0706261114320.18010@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Jun 2007 11:19:26 -0700 (PDT)
Christoph Lameter <clameter@sgi.com> wrote:

>  
> > But slab_lock() isn't taken for slabs whose objects are larger than 
> > PAGE_SIZE. How's that handled?
> 
> slab lock is always taken. How did you get that idea?

Damned if I know.  Perhaps by reading slob.c instead of slub.c.  When can
we start deleting some slab implementations?

> > How much testing has been done on this code, and of what form, and with
> > what results?
> 
> I posted them in the intro of the last full post and then Michael 
> Piotrowski did some stress tests.
> 
> See http://marc.info/?l=linux-mm&m=118125373320855&w=2

hm, OK, thin.

I think we'll need to come up with a better-than-usual test plan for this
change.  One starting point might be to ask what in-the-field problem
you're trying to address here, and what the results were.


Also, what are the risks of meltdowns in this code?  For example, it
reaches the magical 30% ratio, tries to do defrag, but the defrag is for
some reason unsuccessful and it then tries to run defrag again, etc.

And that was "for example"!  Are there other such potential problems in
there?  There usually are, with memory reclaim.


(Should slab_defrag_ratio be per-slab rather than global?)
