Return-Path: <linux-kernel-owner+w=401wt.eu-S1763342AbXGaROK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763342AbXGaROK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 13:14:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758810AbXGaRNn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 13:13:43 -0400
Received: from ra.tuxdriver.com ([70.61.120.52]:4051 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758474AbXGaRNm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 13:13:42 -0400
Date: Tue, 31 Jul 2007 13:12:55 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] argv_split: allow argv_split to handle NULL pointer in argcp parameter gracefully
Message-ID: <20070731171255.GD28333@hmsreliant.homelinux.net>
References: <20070731164608.GB28333@hmsreliant.homelinux.net> <46AF69C3.1040900@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46AF69C3.1040900@goop.org>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2007 at 09:56:35AM -0700, Jeremy Fitzhardinge wrote:
> Neil Horman wrote:
> > As Jeremy and I had discussed in a previous thread, it would be nice if the
> > argv_split library function could gracefully handle a NULL pointer in the argcp
> > parameter, so as to allow functions using it that did not care about the value
> > of argc to not have to declare a useless variable.  This patch accomplishes
> > that.  Tested by me, with successful results.
> >   
> 
> Oh, one other thing.  Could you do a patch to clean up the use in the
> usermodehelper code?
> 
I have a patch for it already, which is rolled into some other work I'm doing in
there.  Since I had a bit of a false start with the recent coredump work, now
that its in -mm I want to give that a chance to settle out and get some testing.
Once its gotten a few weeks of testing and no one else pops up with some other
requests/additions/etc, I'll post my cleanups, which will include your request
above.

Regards
Neil

>     J
> > Thanks & Regards
> > Neil
> >
> > Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> >
> >
> >  argv_split.c |    4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >
> >
> > diff --git a/lib/argv_split.c b/lib/argv_split.c
> > index 4096ed4..fad6ce4 100644
> > --- a/lib/argv_split.c
> > +++ b/lib/argv_split.c
> > @@ -75,7 +75,9 @@ char **argv_split(gfp_t gfp, const char *str, int *argcp)
> >  	if (argv == NULL)
> >  		goto out;
> >  
> > -	*argcp = argc;
> > +	if (argcp)
> > +		*argcp = argc;
> > +
> >  	argvp = argv;
> >  
> >  	while (*str) {
> >   

-- 
/***************************************************
 *Neil Horman
 *Software Engineer
 *Red Hat, Inc.
 *nhorman@tuxdriver.com
 *gpg keyid: 1024D / 0x92A74FA1
 *http://pgp.mit.edu
 ***************************************************/
