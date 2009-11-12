Return-Path: <linux-kernel-owner+w=401wt.eu-S1753195AbZKLO5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195AbZKLO5R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 09:57:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753173AbZKLO5P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 09:57:15 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:59369 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753168AbZKLO5L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 09:57:11 -0500
Date: Thu, 12 Nov 2009 15:57:14 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: James Morris <jmorris@namei.org>, Stephen Smalley <sds@tycho.nsa.gov>,
       Eric Paris <eparis@parisplace.org>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 3/4] security/selinux: decrement sizeof size in strncmp
In-Reply-To: <20091112145314.GA24682@us.ibm.com>
Message-ID: <Pine.LNX.4.64.0911121556390.19779@ask.diku.dk>
References: <Pine.LNX.4.64.0911120849050.16627@ask.diku.dk>
 <alpine.LRH.2.00.0911121857110.31071@tundra.namei.org> <20091112145314.GA24682@us.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Nov 2009, Serge E. Hallyn wrote:

> Quoting James Morris (jmorris@namei.org):
> > On Thu, 12 Nov 2009, Julia Lawall wrote:
> > 
> > > From: Julia Lawall <julia@diku.dk>
> > > 
> > > As observed by Joe Perches, sizeof of a constant string includes the
> > > trailing 0.  If what is wanted is to check the initial characters of
> > > another string, this trailing 0 should not be taken into account.  If an
> > > exact match is wanted, strcmp should be used instead.
> > 
> > > --- a/security/selinux/hooks.c
> > > +++ b/security/selinux/hooks.c
> > > @@ -448,7 +448,7 @@ static int sb_finish_set_opts(struct sup
> > >  		sbsec->flags &= ~SE_SBLABELSUPP;
> > >  
> > >  	/* Special handling for sysfs. Is genfs but also has setxattr handler*/
> > > -	if (strncmp(sb->s_type->name, "sysfs", sizeof("sysfs")) == 0)
> > > +	if (strncmp(sb->s_type->name, "sysfs", sizeof("sysfs") - 1) == 0)
> > >  		sbsec->flags |= SE_SBLABELSUPP;
> > 
> > Shouldn't this be a simple strcmp() ?
> 
> Yes I think so.
> 
> Julia seems to be arguing that if a module introduces a new fs with
> name 'sysfs_foo' then this check should match that fs too (since
> for sysfs, sb->s_type->name = "sysfs" which also has a trailing \0,
> so for the regular sysfs her patch makes no practical difference).

If strcmp is what is wanted, I can make a patch for that.

julia
