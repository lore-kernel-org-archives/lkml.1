Return-Path: <linux-kernel-owner+w=401wt.eu-S1765885AbZDCNJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765885AbZDCNJS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 09:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765566AbZDCNIM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 09:08:12 -0400
Received: from france.micfo.com ([92.48.68.3]:54605 "EHLO france.micfo.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765543AbZDCNIJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 09:08:09 -0400
From: Alberto Gonzalez <info@gnebu.es>
To: Theodore Tso <tytso@mit.edu>
Subject: Re: Ext4 and the "30 second window of death"
Date: Fri, 3 Apr 2009 15:07:57 +0200
User-Agent: KMail/1.11.1 (Linux/2.6.28-ARCH; KDE/4.2.1; x86_64; ; )
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, david@lang.hm,
       Sitsofe Wheeler <sitsofe@yahoo.com>,
       "Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.DEB.1.10.0904021116500.28893@asgard.lang.hm> <20090403013603.GA10886@srcf.ucam.org> <20090403045414.GL9870@mit.edu>
In-Reply-To: <20090403045414.GL9870@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904031507.57977.info@gnebu.es>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - france.micfo.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - gnebu.es
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 April 2009 06:54:14 Theodore Tso wrote:
> On Fri, Apr 03, 2009 at 02:36:03AM +0100, Matthew Garrett wrote:
> > > if spinning down a drive saves so little power that it wouldn't make a
> > > significant difference to battery lift to leave it on, why does anyone
> > > bother to spin the drive down?
> >
> > There's various circumstances in which it's beneficial. The difference
> > between an optimal algorithm for typical use and an optimal algorithm
> > for typical use where there's an fsync() every 5 minutes isn't actually
> > that great.
>
> More to the point, if an application is insane enough to push 2.5
> megabytes to disk every single time you click on a web page (this is
> excluding the cache; I had my firefox cache pointed at /tmp when I did
> this measurement), *and* you are running the WiFi for the browser,
> *and* the browser is running flash applications, etc., whether you
> defer the writes or not, you're going to be burning a lot of power.
> Fundamentally, if an application needs to be writing hundreds of files
> or hundreds of kilibytes or more of data all the time, there's
> something wrong with the application.

I really have to agree. Looking at this thread (that unfortunately I started) 
it seems that if Linux is going to improve its power consumption at all it 
depends on the filesystem.

Firefox has some unrealistic settings that stress the hard drive and the 
network, then some people open a couple hundred tabs at the same time, and 
then even the most simple flash animation proved to increase power by 0.9 watts 
on my atom processor that has a 2.5 watt TDP, and there are many other 
problems to solve first. Linux is still trying to catch up with Windows when it 
comes to battery life. It's still clearly behind in "normal" setups (I know, 
you can tweak Linux to use little power, but a default install of a mainstream 
distro will use clearly more power than Windows while providing similar 
functionality). And then Windows can use up to twice more power than OS X [1]. 
So clearly there is a lot of room for improvement when it comes to power usage 
in Linux. But honestly, if we all start blaming the filesystem for it, I don't 
think we're going to find the real problems.

Besides, with SSDs getting better and cheaper, I'm sure that from 2010 on, 
most (if not all) laptops are going to be shipping with an SSD by default. And 
all the spin-up/spin-down problem will go away by itself. And yes, SSDs have 
proven to save some battery, but in the most real world tests I've seen it's 
by about 5%, so I guess that even with the most powersaving filesystem for a 
mechanical HD we could just save about 3% - 4% battery. Not too bad, but still 
far from the 40% needed.

So for all having performance problems with ext3 + fsync, let's see if ext4 
works for them. For those worried about battery life, let's at least start 
looking elsewhere before we want to optimize the filesystem to the last 
milliwatt. And as I feel guilty myself for contributing to this, I'd beg for 
us all to leave a bit of Slack (as Ted said) to filesystem developers. It's 
been a hard week for them already.

Regards,
Alberto.

1 - http://www.anandtech.com/mac/showdoc.aspx?i=3435&p=13
- http://www.anandtech.com/mobile/showdoc.aspx?i=3540&p=10
