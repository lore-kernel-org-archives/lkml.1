Return-Path: <linux-kernel-owner+w=401wt.eu-S1760344AbZDCBgZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760344AbZDCBgZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 21:36:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751345AbZDCBgR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 21:36:17 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:34510 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825AbZDCBgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 21:36:16 -0400
Date: Fri, 3 Apr 2009 02:36:03 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: david@lang.hm
Cc: Theodore Tso <tytso@mit.edu>, Sitsofe Wheeler <sitsofe@yahoo.com>,
       "Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>,
       Alberto Gonzalez <info@gnebu.es>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Ext4 and the "30 second window of death"
Message-ID: <20090403013603.GA10886@srcf.ucam.org>
References: <20090401174336.GA14726@srcf.ucam.org> <alpine.DEB.1.10.0904021116500.28893@asgard.lang.hm> <20090402182925.GA4502@srcf.ucam.org> <alpine.DEB.1.10.0904021134560.28893@asgard.lang.hm> <20090402234617.GB9538@srcf.ucam.org> <alpine.DEB.1.10.0904021753410.28893@asgard.lang.hm> <20090403010600.GA10545@srcf.ucam.org> <alpine.DEB.1.10.0904021810180.28893@asgard.lang.hm> <20090403011953.GA10777@srcf.ucam.org> <alpine.DEB.1.10.0904021821120.28893@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0904021821120.28893@asgard.lang.hm>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 02, 2009 at 06:24:28PM -0700, david@lang.hm wrote:
> On Fri, 3 Apr 2009, Matthew Garrett wrote:
> >No it wouldn't. The kernel would be implementing an adminstrator's
> >choice about whether fsync() is important or not. That's something that
> >would affect the mail client, but it's hardly a decision based on the
> >mail client. Sucks to be that user if they do anything involving mysql.
> 
> in the case of laptops, in 99+% of the cases the user and the 
> administrator are the same person. in the other cases that's something the 
> user should take up with the administrator, because the administrator can 
> do a lot of things to the system that will affect the safety of their data 
> (including loading a kernel that turns fsync into a noop, but more likely 
> involving enabling or disabling write caches on disks)

Well, yes, the administrator could hate the user. They could achieve the 
same affect by just LD_PRELOADING something that stubbed out fsync() and 
inserted random data into every other write(). We generally trust that 
admins won't do that.

> >Benchmarks please.
> 
> if spinning down a drive saves so little power that it wouldn't make a 
> significant difference to battery lift to leave it on, why does anyone 
> bother to spin the drive down?

There's various circumstances in which it's beneficial. The difference 
between an optimal algorithm for typical use and an optimal algorithm 
for typical use where there's an fsync() every 5 minutes isn't actually 
that great.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
