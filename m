Return-Path: <linux-kernel-owner+w=401wt.eu-S1756430AbZAFXbQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756430AbZAFXbQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 18:31:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752351AbZAFXal
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 18:30:41 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:38900 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751630AbZAFXaj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 18:30:39 -0500
Subject: Re: [RFC][PATCH 4/4] Represent RPC Callers
From: Matt Helsley <matthltc@us.ibm.com>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
       "J. Bruce Fields" <bfields@fieldses.org>,
       Cedric Le Goater <clg@fr.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-nfs@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Containers <containers@lists.osdl.org>
In-Reply-To: <1231247062.7127.36.camel@heimdal.trondhjem.org>
References: <20090106011314.534653345@us.ibm.com>
	 <20090106011315.229045829@us.ibm.com>
	 <1231247062.7127.36.camel@heimdal.trondhjem.org>
Content-Type: text/plain
Date: Tue, 06 Jan 2009 15:05:19 -0800
Message-Id: <1231283119.14345.130.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-01-06 at 08:04 -0500, Trond Myklebust wrote:
> On Mon, 2009-01-05 at 17:13 -0800, Matt Helsley wrote:
> > plain text document attachment (move-rpc-client-nodename-cache.patch)
> > Currently RPC needs to know the nodename (often the same as the hostname) which
> > should be used for UNIX-style authentication and file-lock tracking. Because
> > hostname can change between RPC calls and some sequences of RPC calls may
> > require consistent names between calls RPC currently saves the nodename with
> > the RPC client structure.
> > 
> > This is doesn't always work because RPC clients may be discarded over the
> > lifetime of a higher level service -- like those that compose NFS. Specifically
> > this is known to happen during shutdown.
> > 
> > Hence RPC should expect the nodename to be saved by the caller when sequences
> > of RPC calls requiring consistent nodenames may be needed (e.g. NFS). To enable
> > this we introduce an RPC caller structure that allows RPC to query the caller
> > for this information.
> > 
> > This patch is not complete but is meant to indicate the direction I'm planning
> > on going. I'd like to know if there are any objections or if anyone sees a
> > better way to handle this.
> 
> You're planning on slowing down every RPC call in order to fix a problem
> on client shutdown? Why?

	I figured that the network latencies would be much larger than the
amount of time it takes to make a function call which, in the cases I
know of, would reduce to a strcpy().

Cheers,
	-Matt Helsley

