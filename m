Return-Path: <linux-kernel-owner+w=401wt.eu-S1756208AbZAFXbu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208AbZAFXbu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 18:31:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753675AbZAFXao
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 18:30:44 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:48794 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539AbZAFXan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 18:30:43 -0500
Subject: Re: [RFC][PATCH 2/4] sunrpc: Use utsnamespaces
From: Matt Helsley <matthltc@us.ibm.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>,
       Linux Containers <containers@lists.linux-foundation.org>,
       linux-nfs@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "J. Bruce Fields" <bfields@fieldses.org>,
       Chuck Lever <chuck.lever@oracle.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Containers <containers@lists.osdl.org>,
       Cedric Le Goater <clg@fr.ibm.com>
In-Reply-To: <20090106215831.GE18147@us.ibm.com>
References: <20090106011314.534653345@us.ibm.com>
	 <20090106011314.961946803@us.ibm.com> <20090106200229.GA17031@us.ibm.com>
	 <1231274682.20316.65.camel@heimdal.trondhjem.org>
	 <20090106215831.GE18147@us.ibm.com>
Content-Type: text/plain
Date: Tue, 06 Jan 2009 15:30:33 -0800
Message-Id: <1231284633.14345.152.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-01-06 at 15:58 -0600, Serge E. Hallyn wrote:
> Quoting Trond Myklebust (trond.myklebust@fys.uio.no):
> > On Tue, 2009-01-06 at 14:02 -0600, Serge E. Hallyn wrote:
> > > Quoting Matt Helsley (matthltc@us.ibm.com):
> > > > We can often specify the UTS namespace to use when starting an RPC client.
> > > > However sometimes no UTS namespace is available (specifically during system
> > > > shutdown as the last NFS mount in a container is unmounted) so fall
> > > > back to the initial UTS namespace.
> > > 
> > > So what happens if we take this patch and do nothing else?
> > > 
> > > The only potential problem situation will be rpc requests
> > > made on behalf of a container in which the last task has
> > > exited, right?  So let's say a container did an nfs mount
> > > and then exits, causing an nfs umount request.
> > > 
> > > That umount request will now be sent with the wrong nodename.
> > > Does that actually cause problems, will the server use the
> > > nodename to try and determine the client sending the request?
> > 
> > The NFSv2/v3 umount rpc call will be sent by the 'umount' program from
> > userspace, not the kernel. The problem here is that because lazy mounts
> > exist, the lifetime of the RPC client may be longer than that of the
> 
> Right that was what i was referring to.
> 
> > container. In addition, it may be shared among more than 1 container,
> > because superblocks can be shared.
> 
> Good point.  And in that case what do we care about (even though
> apparently we just might not care at all :) - who did the mount,
> or who is using it?
> 
> In fact one thing I noticed in Matt's patch 3 was that he copied
> in the nodename verbatim, so a future hostname() by the container
> wouldn't be reflected, again not sure if that would matter.

I thought of this. I found the patches that added the nodename in the
RPC client struct and the stale nodename was intentional. That's why I
preserved the copy rather than called utsname() each time.

Cheers,
	-Matt

