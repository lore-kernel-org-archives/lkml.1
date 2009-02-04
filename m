Return-Path: <linux-kernel-owner+w=401wt.eu-S1759318AbZBDUOl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759318AbZBDUOl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 15:14:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753244AbZBDUOc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 15:14:32 -0500
Received: from smtp3.ultrahosting.com ([74.213.175.254]:46302 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752691AbZBDUOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 15:14:32 -0500
Date: Wed, 4 Feb 2009 15:09:15 -0500 (EST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, Nick Piggin <npiggin@suse.de>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Lin Ming <ming.m.lin@intel.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch] SLQB slab allocator
In-Reply-To: <200902041522.01307.nickpiggin@yahoo.com.au>
Message-ID: <alpine.DEB.1.10.0902041507050.8154@qirst.com>
References: <20090114155923.GC1616@wotan.suse.de> <84144f020902031042i31eaec14v53a0e7a203acd28b@mail.gmail.com> <84144f020902031047o2e117652w28886efb495688c4@mail.gmail.com> <200902041522.01307.nickpiggin@yahoo.com.au>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Feb 2009, Nick Piggin wrote:

> That's very true, and we touched on this earlier. It is I guess
> you can say a downside of queueing. But an analogous situation
> in SLUB would be that lots of pages on the partial list with
> very few free objects, or freeing objects to pages with few
> objects in them. Basically SLUB will have to do the extra work
> in the fastpath.

But these are pages with mostly allocated objects and just a few objects
free. The SLAB case is far worse: You have N objects on a queue and they
are keeping possibly N pages away from the page allocator and in those
pages *nothing* is used.

