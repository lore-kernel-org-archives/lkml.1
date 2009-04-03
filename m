Return-Path: <linux-kernel-owner+w=401wt.eu-S1765255AbZDCNp7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765255AbZDCNp7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 09:45:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754549AbZDCNpu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 09:45:50 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:49831 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753434AbZDCNpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 09:45:49 -0400
Date: Fri, 3 Apr 2009 14:45:35 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Theodore Tso <tytso@mit.edu>, david@lang.hm,
       Sitsofe Wheeler <sitsofe@yahoo.com>,
       "Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>,
       Alberto Gonzalez <info@gnebu.es>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Ext4 and the "30 second window of death"
Message-ID: <20090403134535.GC19774@srcf.ucam.org>
References: <20090402182925.GA4502@srcf.ucam.org> <alpine.DEB.1.10.0904021134560.28893@asgard.lang.hm> <20090402234617.GB9538@srcf.ucam.org> <alpine.DEB.1.10.0904021753410.28893@asgard.lang.hm> <20090403010600.GA10545@srcf.ucam.org> <alpine.DEB.1.10.0904021810180.28893@asgard.lang.hm> <20090403011953.GA10777@srcf.ucam.org> <alpine.DEB.1.10.0904021821120.28893@asgard.lang.hm> <20090403013603.GA10886@srcf.ucam.org> <20090403045414.GL9870@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090403045414.GL9870@mit.edu>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 03, 2009 at 12:54:14AM -0400, Theodore Tso wrote:

> More to the point, if an application is insane enough to push 2.5
> megabytes to disk every single time you click on a web page (this is
> excluding the cache; I had my firefox cache pointed at /tmp when I did
> this measurement), *and* you are running the WiFi for the browser,
> *and* the browser is running flash applications, etc., whether you
> defer the writes or not, you're going to be burning a lot of power.
> Fundamentally, if an application needs to be writing hundreds of files
> or hundreds of kilibytes or more of data all the time, there's
> something wrong with the application.

Yes. If applications are fsync()ing too often then the obvious fix is to 
deal with those applications, and that's something we've been successful 
with in other fields of power management.

> If some KDE applications needs to rewrite hundreds of files at desktop
> startup, when the user hasn't even changed any configuration options
> yet (this is that desktop **startup**, mind you, where this was
> reported), then you're going to burning a lot of power.  Anything we
> do at the filesystem level is really going to be at the margins.

Not really. Desktop startup is a one-off cost and has no significant 
impact on your overall power budget. There's little worthwhile 
optimisation there from a power management point of view.

> The annoying thing is the applications programmers aren't willing to
> fix their d*mn applications, and instead heap all of the blame on the
> filesystem.  I will be the first to admit that filesystem designers
> have to do their part, and once I realized how bad and sloppy people
> had gotten with fsync(), and needlessly rewriting files, I implemented
> the ext4 workaround patches *first*.  I only started talking about how
> application programmers might make changes to obey the established
> standards and work with other filesystems after I had put my own house
> in order.  These are system-wide problems we are talking about, that
> will require system-wide solutions.  I can provide workarounds for
> existing application behaviours, but claiming that applications can
> never change, and we must always accomodate the way applications are
> currently working and are designed is going to be a losing strategy
> for us all.

>From a power management perspective, anything that requires applications 
to call fsync() more frequently is a bad thing. So filesystems that 
reorder metadata operations are a bad thing. The fix isn't to add 
fsync() to applications, the fix is to ensure that filesystems don't 
force applications to do so.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
