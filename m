Return-Path: <linux-kernel-owner+w=401wt.eu-S1753556AbZHXVIk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556AbZHXVIk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 17:08:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753455AbZHXVIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 17:08:40 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:28292 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247AbZHXVIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 17:08:39 -0400
Date: Mon, 24 Aug 2009 13:25:52 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
       stern@owland.harvard.edu, akpm@linux-foundation.org, apw@canonical.com,
       mingo@elte.hu, linux-kernel@vger.kernel.org, peterz@infradead.org
Subject: Re: [PATCH] Add kerneldoc for flush_scheduled_work()
Message-Id: <20090824132552.00d30f4e.randy.dunlap@oracle.com>
In-Reply-To: <20090824200950.GA3435@cmpxchg.org>
References: <20090813145106.GA25333@cmpxchg.org>
	<1250175853.3901.34.camel@mulgrave.site>
	<4A843D66.1060407@xenotime.net>
	<20090813180856.GB26020@cmpxchg.org>
	<4A85ABBB.5060806@oracle.com>
	<20090818090419.GA3730@cmpxchg.org>
	<20090819222357.GA12821@cmpxchg.org>
	<4A8C88F3.1000609@oracle.com>
	<20090824190653.GA2197@cmpxchg.org>
	<20090824122711.33b0691e.randy.dunlap@oracle.com>
	<20090824200950.GA3435@cmpxchg.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt001.oracle.com [141.146.116.10]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4A930136.0178:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Aug 2009 22:09:50 +0200 Johannes Weiner wrote:

> Hello Randy,
> 
> On Mon, Aug 24, 2009 at 12:27:11PM -0700, Randy Dunlap wrote:
> > On Mon, 24 Aug 2009 12:06:54 -0700 (PDT) Johannes Weiner wrote:
> > 
> > I'll add this to my kernel-doc quilt patch series.
> 
> Thanks!
> 
> > Oh, one question below...
> 
> > > @@ -2119,11 +2122,19 @@ sub process_file($) {
> > >  	    } elsif (/$doc_content/) {
> > >  		# miguel-style comment kludge, look for blank lines after
> > >  		# @parameter line to signify start of description
> > > -		if ($1 eq "" &&
> > > -			($section =~ m/^@/ || $section eq $section_context)) {
> > > -		    dump_section($file, $section, xml_escape($contents));
> > > -		    $section = $section_default;
> > > -		    $contents = "";
> > > +		if ($1 eq "") {
> > > +		    if ($section =~ m/^@/ || $section eq $section_context) {
> > > +			dump_section($file, $section, xml_escape($contents));
> > > +			$section = $section_default;
> > > +			$contents = "";
> > > +		    } else {
> > > +			$contents .= "\n";
> > > +		    }
> > > +		    $in_purpose = 0;
> > > +		} elsif ($in_purpose == 1) {
> > > +		    # Continued declaration purpose
> > > +		    chomp($declaration_purpose);
> > > +		    $declaration_purpose .= " " . $1;
> > 
> > Why shouldn't this be:
> > 		    $declaration_purpose .= " " . xml_escape($1);
> > ?
> 
> Sorry, this should be escaped of course!  Could you edit the patch on
> your side?

Sure, will do.


---
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
