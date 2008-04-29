Return-Path: <linux-kernel-owner+w=401wt.eu-S1759181AbYD2SuN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759181AbYD2SuN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 14:50:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757838AbYD2St4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 14:49:56 -0400
Received: from relay2.sgi.com ([192.48.171.30]:51129 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756430AbYD2Stz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 14:49:55 -0400
Date: Tue, 29 Apr 2008 11:49:54 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Arjan van de Ven <arjan@infradead.org>
cc: Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [2/2] vmallocinfo: Add caller information
In-Reply-To: <20080428124849.4959c419@infradead.org>
Message-ID: <Pine.LNX.4.64.0804291143080.12128@schroedinger.engr.sgi.com>
References: <20080318222701.788442216@sgi.com> <20080318222827.519656153@sgi.com>
 <20080429084854.GA14913@elte.hu> <Pine.LNX.4.64.0804291001420.10847@schroedinger.engr.sgi.com>
 <20080428124849.4959c419@infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Apr 2008, Arjan van de Ven wrote:

> > Sorry lost track of this issue. Adding stracktrace support is not a 
> > trivial thing and will change the basic handling of vmallocinfo.
> > 
> > Not sure if stacktrace support can be enabled without a penalty on
> > various platforms. Doesnt this require stackframes to be formatted in
> > a certain way?
> 
> it doesn't.

Hmmm... Why do we have CONFIG_FRAMEPOINTER then?

The current implementation of vmalloc_caller() follows what we have done 
with kmalloc_track_caller. Its low overhead and always on.

It would be great if we could have stacktrace support both for kmalloc and 
vmalloc in the same way also with low overhead but I think following a 
backtrace requires much more than simply storing the caller address. A 
mechanism like that would require an explicit kernel CONFIG option. A 
year or so ago we had patches to implement stacktraces in the slab 
allocators but they were not merged due to various arch specific issues 
with backtraces.

We could dump the offending x86_64 pieces. Some detail of what
/proc/vmallocinfo would be lost then.
