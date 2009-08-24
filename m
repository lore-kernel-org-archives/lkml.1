Return-Path: <linux-kernel-owner+w=401wt.eu-S1752549AbZHXUKq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752549AbZHXUKq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 16:10:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752216AbZHXUKo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 16:10:44 -0400
Received: from cmpxchg.org ([85.214.51.133]:59089 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751689AbZHXUKo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 16:10:44 -0400
Date: Mon, 24 Aug 2009 22:09:50 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
       stern@owland.harvard.edu, akpm@linux-foundation.org, apw@canonical.com,
       mingo@elte.hu, linux-kernel@vger.kernel.org, peterz@infradead.org
Subject: Re: [PATCH] Add kerneldoc for flush_scheduled_work()
Message-ID: <20090824200950.GA3435@cmpxchg.org>
References: <20090813145106.GA25333@cmpxchg.org> <1250175853.3901.34.camel@mulgrave.site> <4A843D66.1060407@xenotime.net> <20090813180856.GB26020@cmpxchg.org> <4A85ABBB.5060806@oracle.com> <20090818090419.GA3730@cmpxchg.org> <20090819222357.GA12821@cmpxchg.org> <4A8C88F3.1000609@oracle.com> <20090824190653.GA2197@cmpxchg.org> <20090824122711.33b0691e.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090824122711.33b0691e.randy.dunlap@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Randy,

On Mon, Aug 24, 2009 at 12:27:11PM -0700, Randy Dunlap wrote:
> On Mon, 24 Aug 2009 12:06:54 -0700 (PDT) Johannes Weiner wrote:
> 
> I'll add this to my kernel-doc quilt patch series.

Thanks!

> Oh, one question below...

> > @@ -2119,11 +2122,19 @@ sub process_file($) {
> >  	    } elsif (/$doc_content/) {
> >  		# miguel-style comment kludge, look for blank lines after
> >  		# @parameter line to signify start of description
> > -		if ($1 eq "" &&
> > -			($section =~ m/^@/ || $section eq $section_context)) {
> > -		    dump_section($file, $section, xml_escape($contents));
> > -		    $section = $section_default;
> > -		    $contents = "";
> > +		if ($1 eq "") {
> > +		    if ($section =~ m/^@/ || $section eq $section_context) {
> > +			dump_section($file, $section, xml_escape($contents));
> > +			$section = $section_default;
> > +			$contents = "";
> > +		    } else {
> > +			$contents .= "\n";
> > +		    }
> > +		    $in_purpose = 0;
> > +		} elsif ($in_purpose == 1) {
> > +		    # Continued declaration purpose
> > +		    chomp($declaration_purpose);
> > +		    $declaration_purpose .= " " . $1;
> 
> Why shouldn't this be:
> 		    $declaration_purpose .= " " . xml_escape($1);
> ?

Sorry, this should be escaped of course!  Could you edit the patch on
your side?

Thanks,
	Hannes
