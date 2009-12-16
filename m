Return-Path: <linux-kernel-owner+w=401wt.eu-S1759501AbZLPWs6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759501AbZLPWs6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 17:48:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751224AbZLPWsx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 17:48:53 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:18448 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759355AbZLPWsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 17:48:52 -0500
Date: Wed, 16 Dec 2009 14:47:00 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-nfs@vger.kernel.org
Subject: Re: [PATCH -next] nfs: fix ISO C90 warning
Message-Id: <20091216144700.34b80b4b.randy.dunlap@oracle.com>
In-Reply-To: <1261003219.13878.6.camel@localhost>
References: <20091215165309.58e98eea.sfr@canb.auug.org.au>
	<20091216142334.6a0ba115.randy.dunlap@oracle.com>
	<1261003219.13878.6.camel@localhost>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4B2963C0.005C:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Dec 2009 17:40:19 -0500 Trond Myklebust wrote:

> On Wed, 2009-12-16 at 14:23 -0800, Randy Dunlap wrote: 
> > From: Randy Dunlap <randy.dunlap@oracle.com>
> > 
> > Fix gcc ISO C90 warning:
> > 
> > fs/nfs/callback.c:356: warning: ISO C90 forbids mixed declarations and code
> > 
> > Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> > ---
> >  fs/nfs/callback.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > --- linux-next-20091215.orig/fs/nfs/callback.c
> > +++ linux-next-20091215/fs/nfs/callback.c
> > @@ -352,8 +352,8 @@ static int check_gss_callback_principal(
> >  static int nfs_callback_authenticate(struct svc_rqst *rqstp)
> >  {
> >  	struct nfs_client *clp;
> > -	RPC_IFDEBUG(char buf[RPC_MAX_ADDRBUFLEN]);
> >  	int ret = SVC_OK;
> > +	RPC_IFDEBUG(char buf[RPC_MAX_ADDRBUFLEN]);
> >  
> 
> What version of gcc is giving rise to this warning?

> gcc --version
gcc (GCC) 4.2.1 (SUSE Linux)

> RPC_IFDEBUG is a macro that either evaluates to its argument, or to
> nothing, depending on whether or not RPC_DEBUG is defined or not. In
> neither case should it evaluate to anything illegal under C90 rules
> afaics.

Yep.  Odd warning.


---
~Randy
