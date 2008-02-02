Return-Path: <linux-kernel-owner+w=401wt.eu-S935217AbYBBVa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935217AbYBBVa1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 16:30:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764388AbYBBVaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 16:30:13 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:50864 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761658AbYBBVaM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 16:30:12 -0500
Date: Sat, 2 Feb 2008 22:30:15 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Frans Pop <elendil@planet.nl>, Bryan Wu <bryan.wu@analog.com>
Cc: akpm@linux-foundation.org, linux-kbuild@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [REVIEW for merge] kbuild updates including silence of section mismatch check
Message-ID: <20080202213015.GA27015@uranus.ravnborg.org>
References: <20080202203503.GA26415@uranus.ravnborg.org> <E1JLPrz-00059X-Sc@faramir.fjphome.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1JLPrz-00059X-Sc@faramir.fjphome.nl>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bryan this was from you - please comment/fix.

	Sam

On Sat, Feb 02, 2008 at 10:25:51PM +0100, Frans Pop wrote:
> Sam Ravnborg wrote:
> > --- a/scripts/setlocalversion
> > +++ b/scripts/setlocalversion
> > @@ -45,3 +45,18 @@ if hgid=`hg id 2>/dev/null`; then
> > # All done with mercurial
> > exit
> > fi
> > +
> > +# Check for svn and a svn repo.
> > +if rev=`svn info 2>/dev/null | grep '^Revision' | awk '{print $NF}'` ; then
> > +       changes=`svn status 2>/dev/null | grep '^[AMD]' | wc -l` 
> > +
> > +       # Are there uncommitted changes?
> > +       if [ $changes != 0 ]; then
> > +               printf -- '-svn%s%s%s' "$rev" -dirty "$changes"
> > +       else
> > +               printf -- '-svn%s' "$rev"
> > +       fi
> > +
> > +       # All done with svn
> > +       exit
> > +fi
> 
> This looks broken. Unless I'm very much mistaken the 'if' statement is
> always going to be true because the awk statement will always execute
> without error. Try: echo "" | awk '{print $NF}' || echo Error
> 
> So, the code should probably be changed to:
> +if rev=`svn info 2>/dev/null | grep '^Revision' ; then
> +	rev=`echo $rev | awk '{print $NF}'`
> +       changes=`svn status 2>/dev/null | grep '^[AMD]' | wc -l` 
> 
> or alternatively:
> +if rev=`svn info 2>/dev/null | grep '^Revision' | awk '{print $NF}'` && \
> +   [ -n "$rev" ] ; then 
> +       changes=`svn status 2>/dev/null | grep '^[AMD]' | wc -l` 
> 
> Cheers,
> FJP
> 
> P.S. Looks like the mercurial section is missing some indentation.
