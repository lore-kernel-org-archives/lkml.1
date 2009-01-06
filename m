Return-Path: <linux-kernel-owner+w=401wt.eu-S1756180AbZAFX6t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756180AbZAFX6t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 18:58:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751230AbZAFX6j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 18:58:39 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:38329 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751477AbZAFX6i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 18:58:38 -0500
Subject: Re: [RFC][PATCH 2/4] sunrpc: Use utsnamespaces
From: Matt Helsley <matthltc@us.ibm.com>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>,
       Linux Containers <containers@lists.linux-foundation.org>,
       linux-nfs@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "J. Bruce Fields" <bfields@fieldses.org>,
       Chuck Lever <chuck.lever@oracle.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Containers <containers@lists.osdl.org>,
       Cedric Le Goater <clg@fr.ibm.com>
In-Reply-To: <1231285417.8041.15.camel@heimdal.trondhjem.org>
References: <20090106011314.534653345@us.ibm.com>
	 <20090106011314.961946803@us.ibm.com>  <20090106200229.GA17031@us.ibm.com>
	 <1231274682.20316.65.camel@heimdal.trondhjem.org>
	 <1231283935.14345.142.camel@localhost>
	 <1231285417.8041.15.camel@heimdal.trondhjem.org>
Content-Type: text/plain
Date: Tue, 06 Jan 2009 15:58:35 -0800
Message-Id: <1231286315.14345.184.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-01-06 at 18:43 -0500, Trond Myklebust wrote:
> On Tue, 2009-01-06 at 15:18 -0800, Matt Helsley wrote:
> > Yes, I was aware that the inode might be dirtied by another container. I
> > was thinking that, at least in the case of NFS, it makes sense to report
> > the node name of the container that did the original mount. Of course
> > this doesn't address the general RPC client case and, like patch 3, it
> > makes the superblock solution rather NFS-specific. That brings me to a
> > basic question: Are there any RPC clients in the kernel that do not
> > operate on behalf of NFS?
> 
> Yes. There is, for instance, the portmapper/rpcbind client.

<snip>

OK that's a good example. Point taken.

>  The NFS and
> lockd servers also sometime needs to send RPC callbacks. 

Yes, these won't have an NFS superblock handy and hence they use the
node name cached in the RPC client struct. That means that these patches
have only addressed NFS client-side namespace issues. Have you seen J.
Bruce Fields post on the nfsd side of things?

Cheers,
	-Matt Helsley

