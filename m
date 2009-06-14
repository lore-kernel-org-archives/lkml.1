Return-Path: <linux-kernel-owner+w=401wt.eu-S1764344AbZFNUsH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764344AbZFNUsH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 16:48:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764233AbZFNUrq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 16:47:46 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:50478 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762323AbZFNUrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 16:47:45 -0400
Date: Sun, 14 Jun 2009 13:46:48 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: Sam Ravnborg <sam@ravnborg.org>
cc: Nico Schottelius <nico-linuxsetlocalversion@schottelius.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] scripts/setlocalversion on readonly source
In-Reply-To: <20090614202704.GA3050@uranus.ravnborg.org>
Message-ID: <alpine.DEB.2.01.0906141336150.6439@bogon>
References: <20090611153332.d168e58e.akpm@linux-foundation.org> <20090612043922.GA13001@uranus.ravnborg.org> <alpine.DEB.2.01.0906091323520.6439@bogon> <20090612075952.GA22436@ikn.schottelius.org> <20090614202704.GA3050@uranus.ravnborg.org>
User-Agent: Alpine 2.01 (DEB 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX1/GGv3U1aoRSv5UT8j+IrLWgBtnfcxqUzigtoo
 hqmjxJKQoekQBh+z+tjMOFLZjWIazhyHPdJ9UB7o1N+H+qf4p9
 ooN89Uzau8OnJGS41r4uQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Jun 2009, Sam Ravnborg wrote:
> > Do not update index on read only media.
> > Idea published by Christian Kujau <lists@nerdbynature.de>.
> > 
> > diff --git a/scripts/setlocalversion b/scripts/setlocalversion
> > index 0079047..46989b8 100755
> > --- a/scripts/setlocalversion
> > +++ b/scripts/setlocalversion
> > @@ -39,8 +39,10 @@ if head=`git rev-parse --verify --short HEAD 2>/dev/null`; then
> >  	        printf -- '-svn%s' "`git svn find-rev $head`"
> >  	fi
> >  
> > -	# Are there uncommitted changes?
> > -	git update-index --refresh --unmerged > /dev/null
> > +	# Update index only on r/w media
> > +	[ -w . ] && git update-index --refresh --unmerged > /dev/null
> > +
> > +	# Check for uncommitted changes
> >  	if git diff-index --name-only HEAD | grep -v "^scripts/package" \
> >  	    | read dummy; then
> >  		printf '%s' -dirty
> 
> Please sign-off future patches.
> I applied this with no signoff - but this is an exception.

I'm not sure if we want to have patches w/o a signoff in the tree; but I 
could only add a

   Tested-by: Christian Kujau <lists@nerdbynature.de>

since it's Nico's patch now.

Thanks,
Christian.
-- 
BOFH excuse #446:

Mailer-daemon is busy burning your message in hell.
