Return-Path: <linux-kernel-owner+w=401wt.eu-S934807AbZLPW7L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934807AbZLPW7L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 17:59:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763125AbZLPW7E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 17:59:04 -0500
Received: from www.tglx.de ([62.245.132.106]:38759 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761610AbZLPW67 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 17:58:59 -0500
Date: Wed, 16 Dec 2009 23:58:37 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Trond Myklebust <trond.myklebust@fys.uio.no>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-nfs@vger.kernel.org
Subject: Re: [PATCH -next] nfs: fix ISO C90 warning
In-Reply-To: <20091216144700.34b80b4b.randy.dunlap@oracle.com>
Message-ID: <alpine.LFD.2.00.0912162355350.2755@localhost.localdomain>
References: <20091215165309.58e98eea.sfr@canb.auug.org.au> <20091216142334.6a0ba115.randy.dunlap@oracle.com> <1261003219.13878.6.camel@localhost> <20091216144700.34b80b4b.randy.dunlap@oracle.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Dec 2009, Randy Dunlap wrote:
> On Wed, 16 Dec 2009 17:40:19 -0500 Trond Myklebust wrote:
> 
> > On Wed, 2009-12-16 at 14:23 -0800, Randy Dunlap wrote: 
> > > From: Randy Dunlap <randy.dunlap@oracle.com>
> > > 
> > > Fix gcc ISO C90 warning:
> > > 
> > > fs/nfs/callback.c:356: warning: ISO C90 forbids mixed declarations and code
> > > 
> > > Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> > > ---
> > >  fs/nfs/callback.c |    2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > --- linux-next-20091215.orig/fs/nfs/callback.c
> > > +++ linux-next-20091215/fs/nfs/callback.c
> > > @@ -352,8 +352,8 @@ static int check_gss_callback_principal(
> > >  static int nfs_callback_authenticate(struct svc_rqst *rqstp)
> > >  {
> > >  	struct nfs_client *clp;
> > > -	RPC_IFDEBUG(char buf[RPC_MAX_ADDRBUFLEN]);
> > >  	int ret = SVC_OK;
> > > +	RPC_IFDEBUG(char buf[RPC_MAX_ADDRBUFLEN]);
> > >  
> > 
> > What version of gcc is giving rise to this warning?
> 
> > gcc --version
> gcc (GCC) 4.2.1 (SUSE Linux)
> 
> > RPC_IFDEBUG is a macro that either evaluates to its argument, or to
> > nothing, depending on whether or not RPC_DEBUG is defined or not. In
> > neither case should it evaluate to anything illegal under C90 rules
> > afaics.
> 
> Yep.  Odd warning.

Not really. If the debug macro evaluates to nothing then you have:

    struct nfs_client *clp;
    ;
    int ret = SVC_OK;

So you have a stray semicolon, which is interpreted as an empty code
line. That qualifies for the mixed declaration and code case :)

I know it's nitpicking, but ...

Thanks,

	tglx
