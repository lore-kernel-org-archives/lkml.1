Return-Path: <linux-kernel-owner+w=401wt.eu-S1752614AbYLSQ7f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614AbYLSQ7f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 11:59:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751574AbYLSQ7Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 11:59:25 -0500
Received: from boogie.lpds.sztaki.hu ([193.224.70.237]:53266 "EHLO
	boogie.lpds.sztaki.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466AbYLSQ7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 11:59:24 -0500
X-Greylist: delayed 629 seconds by postgrey-1.27 at vger.kernel.org; Fri, 19 Dec 2008 11:59:23 EST
Date: Fri, 19 Dec 2008 17:48:51 +0100
From: Gabor Gombas <gombasg@sztaki.hu>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>,
       Christoph Hellwig <hch@infradead.org>, sfr@canb.auug.org.au,
       steved@redhat.com, rwheeler@redhat.com, bfields@fieldses.org,
       nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: Pull request for FS-Cache, including NFS patches
Message-ID: <20081219164851.GG5209@boogie.lpds.sztaki.hu>
References: <20081218123601.11810b7f.akpm@linux-foundation.org> <8930.1229560221@redhat.com> <20081218224418.804f10bc.sfr@canb.auug.org.au> <20081218142420.GA16728@infradead.org> <7633.1229653644@redhat.com> <20081218184443.d73f5431.akpm@linux-foundation.org> <1229690036.7789.113.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1229690036.7789.113.camel@heimdal.trondhjem.org>
X-Copyright: Forwarding or publishing without permission is prohibited.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 19, 2008 at 07:33:56AM -0500, Trond Myklebust wrote:

> One interesting use case that I didn't see David mention is for cluster
> boot up. In a lot of the HPC clustered set-ups there tend be a number of
> 'hot' files that all clients need to access at roughly the same time in
> the boot cycle. Pre-loading these files into the persistent cache before
> booting the cluster is one way to solve this problem. Server replication
> and/or copying the files to local storage on the clients are other
> solutions.

Not just boot up. Consider a room full of thin clients using nfsroot and
the lecturer saying "Now everybody open a browser" or "Now everybody
open Openoffice". With just NFS, it takes ages (there is a bottleneck of
a single gigabit link between the clients and the NFS server even though
the server itself has a 10gig card). If we redirect most of /usr/lib to
a small local flash with some LD_LIBRARY_PATH and bind mount trickery we
get an acceptable startup time. The flash is too small to hold even
/usr/lib (flash size: 500M, /usr/lib is: 927M) so it is not possible to
keep everything locally.

It would be really nice if the local caching could be handled
automatically and we would not need so many hacks, so I really look
forward trying FS-Cache if I have time. I used cachefs on Solaris ages
ago and I had good experiences back then; it would be really nice if
Linux would catch up.

Gabor

-- 
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences
     ---------------------------------------------------------
