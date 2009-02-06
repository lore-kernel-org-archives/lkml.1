Return-Path: <linux-kernel-owner+w=401wt.eu-S1759123AbZBFRVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759123AbZBFRVT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 12:21:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752245AbZBFRVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 12:21:09 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:37758 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751AbZBFRVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 12:21:08 -0500
Date: Fri, 6 Feb 2009 18:22:52 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Pete Wyckoff <pw@padd.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, akpm@osdl.org, albcamus@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tags: fix config symbols generation
Message-ID: <20090206172252.GA11299@uranus.ravnborg.org>
References: <20090129102618.GB4425@x200.localdomain> <20090206150858.GA15565@padd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090206150858.GA15565@padd.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 06, 2009 at 07:08:58AM -0800, Pete Wyckoff wrote:
> adobriyan@gmail.com wrote on Thu, 29 Jan 2009 13:26 +0300:
> > commit 4f628248a578585472e19e4cba2c604643af8c6c aka
> > "kbuild: reintroduce ALLSOURCE_ARCHS support for tags/cscope"
> > breaks tags generation for Kconfig symbols.
> > 
> > Steps to reproduce:
> > 
> > 	make tags
> > 	vi -t PROC_FS
> > 
> > It should jump to 'config PROC_FS' line.
> > 
> > Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> > ---
> > 
> >  scripts/tags.sh |    5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> > 
> > --- a/scripts/tags.sh
> > +++ b/scripts/tags.sh
> > @@ -76,7 +76,10 @@ all_sources()
> >  
> >  all_kconfigs()
> >  {
> > -	find_sources $ALLSOURCE_ARCHS 'Kconfig*'
> > +	for arch in $ALLSOURCE_ARCHS; do
> > +		find_sources $arch 'Kconfig*'
> > +	done
> > +	find_other_sources 'Kconfig*'
> >  }
> >  
> >  all_defconfigs()
> 
> Yes, this is necessary.  It fixes the problem introduced by
> 4f628248a578585472e19e4cba2c604643af8c6c (kbuild: reintroduce
> ALLSOURCE_ARCHS support for tags/cscope).
> 
> Tested-by: Pete Wyckoff <pw@padd.com>

Thanks for testing.
I'm heading for vacation in a few hours and has been busy at job due to this.
I will add this (and other pending stuff) to my kbuild-fixes.git tree
when I'm back.

	Sam
