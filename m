Return-Path: <linux-kernel-owner+w=401wt.eu-S935651AbYBCDbH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935651AbYBCDbH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 22:31:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932640AbYBCDay
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 22:30:54 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:60777 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753634AbYBCDaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 22:30:52 -0500
X-IronPort-AV: E=Sophos;i="4.25,297,1199682000"; 
   d="scan'208";a="47843125"
Subject: Re: [REVIEW for merge] kbuild updates including silence of section
	mismatch check
From: Bryan Wu <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Frans Pop <elendil@planet.nl>, Bryan Wu <bryan.wu@analog.com>,
       akpm@linux-foundation.org, linux-kbuild@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080202213015.GA27015@uranus.ravnborg.org>
References: <20080202203503.GA26415@uranus.ravnborg.org>
	 <E1JLPrz-00059X-Sc@faramir.fjphome.nl>
	 <20080202213015.GA27015@uranus.ravnborg.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Sun, 03 Feb 2008 11:30:29 +0800
Message-Id: <1202009429.6671.2.camel@roc-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
X-OriginalArrivalTime: 03 Feb 2008 03:30:51.0269 (UTC) FILETIME=[2CD6F350:01C86615]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2008-02-02 at 22:30 +0100, Sam Ravnborg wrote:
> Bryan this was from you - please comment/fix.
> 
> 	Sam
> 
> On Sat, Feb 02, 2008 at 10:25:51PM +0100, Frans Pop wrote:
> > Sam Ravnborg wrote:
> > > --- a/scripts/setlocalversion
> > > +++ b/scripts/setlocalversion
> > > @@ -45,3 +45,18 @@ if hgid=`hg id 2>/dev/null`; then
> > > # All done with mercurial
> > > exit
> > > fi
> > > +
> > > +# Check for svn and a svn repo.
> > > +if rev=`svn info 2>/dev/null | grep '^Revision' | awk '{print $NF}'` ; then
> > > +       changes=`svn status 2>/dev/null | grep '^[AMD]' | wc -l` 
> > > +
> > > +       # Are there uncommitted changes?
> > > +       if [ $changes != 0 ]; then
> > > +               printf -- '-svn%s%s%s' "$rev" -dirty "$changes"
> > > +       else
> > > +               printf -- '-svn%s' "$rev"
> > > +       fi
> > > +
> > > +       # All done with svn
> > > +       exit
> > > +fi
> > 
> > This looks broken. Unless I'm very much mistaken the 'if' statement is
> > always going to be true because the awk statement will always execute
> > without error. Try: echo "" | awk '{print $NF}' || echo Error
> > 

You are right, it will always plus a '-svn' string at the end of kernel
version string even if it is not a svn repo.

> > So, the code should probably be changed to:
> > +if rev=`svn info 2>/dev/null | grep '^Revision' ; then
> > +	rev=`echo $rev | awk '{print $NF}'`
> > +       changes=`svn status 2>/dev/null | grep '^[AMD]' | wc -l` 
> > 

I prefer to this one. A updated version will be sent out soon.

> > or alternatively:
> > +if rev=`svn info 2>/dev/null | grep '^Revision' | awk '{print $NF}'` && \
> > +   [ -n "$rev" ] ; then 
> > +       changes=`svn status 2>/dev/null | grep '^[AMD]' | wc -l` 
> > 
> > Cheers,
> > FJP
> > 
> > P.S. Looks like the mercurial section is missing some indentation.
I will fix this, too.

Regards,
-Bryan Wu
