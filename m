Return-Path: <linux-kernel-owner+w=401wt.eu-S1763319AbZDCLJr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763319AbZDCLJr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 07:09:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758912AbZDCLJi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 07:09:38 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:35264 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758904AbZDCLJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 07:09:37 -0400
Date: Fri, 3 Apr 2009 12:09:21 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Theodore Tso <tytso@mit.edu>, Matthew Garrett <mjg59@srcf.ucam.org>,
       david@lang.hm,
       "Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>,
       Alberto Gonzalez <info@gnebu.es>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Ext4 and the "30 second window of death"
Message-ID: <20090403110921.GA12899@sucs.org>
References: <20090402182925.GA4502@srcf.ucam.org> <alpine.DEB.1.10.0904021134560.28893@asgard.lang.hm> <20090402234617.GB9538@srcf.ucam.org> <alpine.DEB.1.10.0904021753410.28893@asgard.lang.hm> <20090403010600.GA10545@srcf.ucam.org> <alpine.DEB.1.10.0904021810180.28893@asgard.lang.hm> <20090403011953.GA10777@srcf.ucam.org> <alpine.DEB.1.10.0904021821120.28893@asgard.lang.hm> <20090403013603.GA10886@srcf.ucam.org> <20090403045414.GL9870@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090403045414.GL9870@mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 03, 2009 at 12:54:14AM -0400, Theodore Tso wrote:
> On Fri, Apr 03, 2009 at 02:36:03AM +0100, Matthew Garrett wrote:
> > 
> > There's various circumstances in which it's beneficial. The difference 
> > between an optimal algorithm for typical use and an optimal algorithm 
> > for typical use where there's an fsync() every 5 minutes isn't actually 
> > that great.
> 
> More to the point, if an application is insane enough to push 2.5
> megabytes to disk every single time you click on a web page (this is
> excluding the cache; I had my firefox cache pointed at /tmp when I did

I no longer know what is being debated here. Is it one or more of the
following:

a) Laptop mode (as it stands today).
b) Laptop mode with fsync-nop.
c) Apps that should be using fsync.
d) Apps that should not using fsync.
e) Apps writing to the disk too frequently.
f) Apps writing to many files to the disk.
g) Userland constraining kernel changes.
h) Increasing battery life.
i) "Acceptable" chance of new data loss after a crash.
j) "Acceptable" chance of data corruption after a crash.
k) Support for a new filesystem barrier() syscall to indicate the order
that data has to be written.

Note some of the above points are in conflict with each other...

> The annoying thing is the applications programmers aren't willing to
> fix their d*mn applications, and instead heap all of the blame on the
> filesystem.  I will be the first to admit that filesystem designers

Isn't this the problem that other systems that place a high value on
backwards compatibly face that the Linux kernel was not supposed to? If
some piece of userland depends on every last bit of behaviour (whether
it was intended/promised or not) then the only way anything can be
changed is with massive effort expended on shims...

-- 
Sitsofe | http://sucs.org/~sits/
