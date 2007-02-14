Return-Path: <linux-kernel-owner+w=401wt.eu-S932410AbXBNSFN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932410AbXBNSFN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 13:05:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932417AbXBNSFM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 13:05:12 -0500
Received: from wr-out-0506.google.com ([64.233.184.228]:44705 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932410AbXBNSFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 13:05:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:reply-to:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ZRusqxMK4QAyNg7jT33YN9ENV53d+g/cI1bxYiHXe6H8S69/onD6n7zd6i3TN+bISj7AMByobXYUxm2N36BsNkYylu+vd5TJMAPzXrZ6arI4WpTtcUkp841AzMJou+zrCxLV9MDu/aVShpuxBA4aMmXnCB0aRw0HupTNumf2bO4=
Subject: Re: [NFS] [PATCH 001 of 9] knfsd: nfsd4: fix non-terminated string
From: Ming Zhang <blackmagic02881@gmail.com>
Reply-To: blackmagic02881@gmail.com
To: chuck.lever@oracle.com
Cc: NeilBrown <neilb@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <45D34D0D.3040606@oracle.com>
References: <20070213103941.28958.patches@notabene>
	 <1070212234402.29224@suse.de>
	 <1171458018.2638.1.camel@localhost.localdomain>
	 <45D34D0D.3040606@oracle.com>
Content-Type: text/plain
Date: Wed, 14 Feb 2007 13:04:46 -0500
Message-Id: <1171476286.3336.9.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-02-14 at 09:55 -0800, Chuck Lever wrote:
> Ming Zhang wrote:
> > On Tue, 2007-02-13 at 10:44 +1100, NeilBrown wrote:
> >> From: J. Bruce Fields <bfields@citi.umich.edu>
> >> The server name is expected to be a null-terminated string, so we can't
> >> pass in the raw client identifier.
> >>
> >> What's more, the client identifier is just a binary, not necessarily
> >> printable, blob.  Let's just use the ip address instead.  The server
> >> name appears to exist just to help debugging by making some printk's
> >> more informative.
> >>
> >> Note that the string is copies into the rpc client structure, so
> >> the pointer to the local variable does not outlive the function call.
> >>
> >> Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
> >> Signed-off-by: Neil Brown <neilb@suse.de>
> >>
> >> ### Diffstat output
> >>  ./fs/nfsd/nfs4callback.c |    7 ++++++-
> >>  1 file changed, 6 insertions(+), 1 deletion(-)
> >>
> >> diff .prev/fs/nfsd/nfs4callback.c ./fs/nfsd/nfs4callback.c
> >> --- .prev/fs/nfsd/nfs4callback.c	2007-02-13 09:50:26.000000000 +1100
> >> +++ ./fs/nfsd/nfs4callback.c	2007-02-13 10:00:59.000000000 +1100
> >> @@ -387,7 +387,6 @@ nfsd4_probe_callback(struct nfs4_client 
> >>  		.address	= (struct sockaddr *)&addr,
> >>  		.addrsize	= sizeof(addr),
> >>  		.timeout	= &timeparms,
> >> -		.servername	= clp->cl_name.data,
> >>  		.program	= program,
> >>  		.version	= nfs_cb_version[1]->number,
> >>  		.authflavor	= RPC_AUTH_UNIX,	/* XXX: need AUTH_GSS... */
> >> @@ -397,6 +396,7 @@ nfsd4_probe_callback(struct nfs4_client 
> >>  		.rpc_proc       = &nfs4_cb_procedures[NFSPROC4_CLNT_CB_NULL],
> >>  		.rpc_argp       = clp,
> >>  	};
> >> +	char clientname[16];
> >>  	int status;
> >>  
> >>  	if (atomic_read(&cb->cb_set))
> >> @@ -419,6 +419,11 @@ nfsd4_probe_callback(struct nfs4_client 
> >>  	memset(program->stats, 0, sizeof(cb->cb_stat));
> >>  	program->stats->program = program;
> >>  
> >> +	/* Just here to make some printk's more useful: */
> >> +	snprintf(clientname, sizeof(clientname),
> >> +		"%u.%u.%u.%u", NIPQUAD(addr.sin_addr));
> > 
> > can use NIPQUAD_FMT here instead of "%u.%u.%u.%u".
> > 
> > btw, will the ip address here possibly be an ipv6 address?
> 
> Some patches are in the works to build in IPv6 support.  See the patch 
> series at http://oss.oracle.com/~cel/linux-2.6/2.6.19/patches/

thanks for the info.

-- 
http://blackmagic02881.wordpress.com/

