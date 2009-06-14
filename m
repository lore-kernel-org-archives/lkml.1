Return-Path: <linux-kernel-owner+w=401wt.eu-S1763765AbZFNUYx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763765AbZFNUYx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 16:24:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754627AbZFNUYp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 16:24:45 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:32809 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754105AbZFNUYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 16:24:45 -0400
Date: Sun, 14 Jun 2009 22:27:04 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Nico Schottelius <nico-linuxsetlocalversion@schottelius.org>,
       Christian Kujau <lists@nerdbynature.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] scripts/setlocalversion on readonly source
Message-ID: <20090614202704.GA3050@uranus.ravnborg.org>
References: <20090611153332.d168e58e.akpm@linux-foundation.org> <20090612043922.GA13001@uranus.ravnborg.org> <alpine.DEB.2.01.0906091323520.6439@bogon> <20090612075952.GA22436@ikn.schottelius.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090612075952.GA22436@ikn.schottelius.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> 
> Do not update index on read only media.
> Idea published by Christian Kujau <lists@nerdbynature.de>.
> 
> diff --git a/scripts/setlocalversion b/scripts/setlocalversion
> index 0079047..46989b8 100755
> --- a/scripts/setlocalversion
> +++ b/scripts/setlocalversion
> @@ -39,8 +39,10 @@ if head=`git rev-parse --verify --short HEAD 2>/dev/null`; then
>  	        printf -- '-svn%s' "`git svn find-rev $head`"
>  	fi
>  
> -	# Are there uncommitted changes?
> -	git update-index --refresh --unmerged > /dev/null
> +	# Update index only on r/w media
> +	[ -w . ] && git update-index --refresh --unmerged > /dev/null
> +
> +	# Check for uncommitted changes
>  	if git diff-index --name-only HEAD | grep -v "^scripts/package" \
>  	    | read dummy; then
>  		printf '%s' -dirty

Please sign-off future patches.
I applied this with no signoff - but this is an exception.

	Sam
