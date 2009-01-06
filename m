Return-Path: <linux-kernel-owner+w=401wt.eu-S1756069AbZAFXfg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756069AbZAFXfg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 18:35:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751844AbZAFXf1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 18:35:27 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:35469 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751631AbZAFXf0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 18:35:26 -0500
Subject: Re: [RFC][PATCH 2/4] sunrpc: Use utsnamespaces
From: Matt Helsley <matthltc@us.ibm.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>,
       Linux Containers <containers@lists.linux-foundation.org>,
       linux-nfs@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Chuck Lever <chuck.lever@oracle.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Containers <containers@lists.osdl.org>,
       Cedric Le Goater <clg@fr.ibm.com>
In-Reply-To: <20090106215324.GD18147@us.ibm.com>
References: <20090106011314.534653345@us.ibm.com>
	 <20090106011314.961946803@us.ibm.com> <20090106200229.GA17031@us.ibm.com>
	 <20090106202046.GF5901@fieldses.org>  <20090106215324.GD18147@us.ibm.com>
Content-Type: text/plain
Date: Tue, 06 Jan 2009 15:35:23 -0800
Message-Id: <1231284923.14345.158.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-01-06 at 15:53 -0600, Serge E. Hallyn wrote:
> Quoting J. Bruce Fields (bfields@fieldses.org):
> > On Tue, Jan 06, 2009 at 02:02:29PM -0600, Serge E. Hallyn wrote:
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
> > This is just the machine name in the auth_unix credential?  The linux
> > server ignores that completely (for the purpose of auth_unix
> > authenication, it identifies clients only by source ip address).  I
> > suspect other servers also ignore it, but I don't know.
> 
> Thanks, that's what i was hoping...
> 
> Matt, have you audited the other rpc-based services?  Do any
> of them care?

Frankly, I did not audit any of the RPC-based services to see if any
truly cared about the node name. That's actually a rather large scope
when you consider it -- I'd have to look at much more than just "Linux"
RPC clients. It seemed unsafe to assume _nobody_ would care after they
bothered to put it into the spec.

Hopefully I'm wrong though :).

Cheers,
	-Matt

