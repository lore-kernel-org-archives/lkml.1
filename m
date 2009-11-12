Return-Path: <linux-kernel-owner+w=401wt.eu-S1753099AbZKLOxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753099AbZKLOxS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 09:53:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753073AbZKLOxR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 09:53:17 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:48078 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753031AbZKLOxP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 09:53:15 -0500
Date: Thu, 12 Nov 2009 08:53:14 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: James Morris <jmorris@namei.org>
Cc: Julia Lawall <julia@diku.dk>, Stephen Smalley <sds@tycho.nsa.gov>,
       Eric Paris <eparis@parisplace.org>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 3/4] security/selinux: decrement sizeof size in strncmp
Message-ID: <20091112145314.GA24682@us.ibm.com>
References: <Pine.LNX.4.64.0911120849050.16627@ask.diku.dk>
 <alpine.LRH.2.00.0911121857110.31071@tundra.namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.0911121857110.31071@tundra.namei.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting James Morris (jmorris@namei.org):
> On Thu, 12 Nov 2009, Julia Lawall wrote:
> 
> > From: Julia Lawall <julia@diku.dk>
> > 
> > As observed by Joe Perches, sizeof of a constant string includes the
> > trailing 0.  If what is wanted is to check the initial characters of
> > another string, this trailing 0 should not be taken into account.  If an
> > exact match is wanted, strcmp should be used instead.
> 
> > --- a/security/selinux/hooks.c
> > +++ b/security/selinux/hooks.c
> > @@ -448,7 +448,7 @@ static int sb_finish_set_opts(struct sup
> >  		sbsec->flags &= ~SE_SBLABELSUPP;
> >  
> >  	/* Special handling for sysfs. Is genfs but also has setxattr handler*/
> > -	if (strncmp(sb->s_type->name, "sysfs", sizeof("sysfs")) == 0)
> > +	if (strncmp(sb->s_type->name, "sysfs", sizeof("sysfs") - 1) == 0)
> >  		sbsec->flags |= SE_SBLABELSUPP;
> 
> Shouldn't this be a simple strcmp() ?

Yes I think so.

Julia seems to be arguing that if a module introduces a new fs with
name 'sysfs_foo' then this check should match that fs too (since
for sysfs, sb->s_type->name = "sysfs" which also has a trailing \0,
so for the regular sysfs her patch makes no practical difference).

-serge
