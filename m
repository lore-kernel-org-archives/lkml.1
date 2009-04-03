Return-Path: <linux-kernel-owner+w=401wt.eu-S1755423AbZDCEyh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423AbZDCEyh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 00:54:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751980AbZDCEy0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 00:54:26 -0400
Received: from thunk.org ([69.25.196.29]:48568 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751846AbZDCEy0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 00:54:26 -0400
Date: Fri, 3 Apr 2009 00:54:14 -0400
From: Theodore Tso <tytso@mit.edu>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: david@lang.hm, Sitsofe Wheeler <sitsofe@yahoo.com>,
       "Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>,
       Alberto Gonzalez <info@gnebu.es>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Ext4 and the "30 second window of death"
Message-ID: <20090403045414.GL9870@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Matthew Garrett <mjg59@srcf.ucam.org>, david@lang.hm,
	Sitsofe Wheeler <sitsofe@yahoo.com>,
	"Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>,
	Alberto Gonzalez <info@gnebu.es>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.DEB.1.10.0904021116500.28893@asgard.lang.hm> <20090402182925.GA4502@srcf.ucam.org> <alpine.DEB.1.10.0904021134560.28893@asgard.lang.hm> <20090402234617.GB9538@srcf.ucam.org> <alpine.DEB.1.10.0904021753410.28893@asgard.lang.hm> <20090403010600.GA10545@srcf.ucam.org> <alpine.DEB.1.10.0904021810180.28893@asgard.lang.hm> <20090403011953.GA10777@srcf.ucam.org> <alpine.DEB.1.10.0904021821120.28893@asgard.lang.hm> <20090403013603.GA10886@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090403013603.GA10886@srcf.ucam.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 03, 2009 at 02:36:03AM +0100, Matthew Garrett wrote:
> > if spinning down a drive saves so little power that it wouldn't make a 
> > significant difference to battery lift to leave it on, why does anyone 
> > bother to spin the drive down?
> 
> There's various circumstances in which it's beneficial. The difference 
> between an optimal algorithm for typical use and an optimal algorithm 
> for typical use where there's an fsync() every 5 minutes isn't actually 
> that great.

More to the point, if an application is insane enough to push 2.5
megabytes to disk every single time you click on a web page (this is
excluding the cache; I had my firefox cache pointed at /tmp when I did
this measurement), *and* you are running the WiFi for the browser,
*and* the browser is running flash applications, etc., whether you
defer the writes or not, you're going to be burning a lot of power.
Fundamentally, if an application needs to be writing hundreds of files
or hundreds of kilibytes or more of data all the time, there's
something wrong with the application.

If some KDE applications needs to rewrite hundreds of files at desktop
startup, when the user hasn't even changed any configuration options
yet (this is that desktop **startup**, mind you, where this was
reported), then you're going to burning a lot of power.  Anything we
do at the filesystem level is really going to be at the margins.

The annoying thing is the applications programmers aren't willing to
fix their d*mn applications, and instead heap all of the blame on the
filesystem.  I will be the first to admit that filesystem designers
have to do their part, and once I realized how bad and sloppy people
had gotten with fsync(), and needlessly rewriting files, I implemented
the ext4 workaround patches *first*.  I only started talking about how
application programmers might make changes to obey the established
standards and work with other filesystems after I had put my own house
in order.  These are system-wide problems we are talking about, that
will require system-wide solutions.  I can provide workarounds for
existing application behaviours, but claiming that applications can
never change, and we must always accomodate the way applications are
currently working and are designed is going to be a losing strategy
for us all.

    	       	  	      	   - Ted
