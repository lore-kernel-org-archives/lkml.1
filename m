Return-Path: <linux-kernel-owner+w=401wt.eu-S934010AbZDBSaK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934010AbZDBSaK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 14:30:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933481AbZDBS3p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 14:29:45 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:48750 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764548AbZDBS3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 14:29:44 -0400
Date: Thu, 2 Apr 2009 19:29:27 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: david@lang.hm
Cc: Theodore Tso <tytso@mit.edu>, Sitsofe Wheeler <sitsofe@yahoo.com>,
       "Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>,
       Alberto Gonzalez <info@gnebu.es>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Ext4 and the "30 second window of death"
Message-ID: <20090402182925.GA4502@srcf.ucam.org>
References: <200903311452.05210.info@gnebu.es> <20090331134547.GJ13356@mit.edu> <200904010002.47077.info@gnebu.es> <49D2A5AB.1090704@ursus.ath.cx> <20090401015010.GB4529@mit.edu> <20090401052050.GA20456@sucs.org> <20090401151219.GA12285@srcf.ucam.org> <20090401173521.GA15423@mit.edu> <20090401174336.GA14726@srcf.ucam.org> <alpine.DEB.1.10.0904021116500.28893@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0904021116500.28893@asgard.lang.hm>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 02, 2009 at 11:22:48AM -0700, david@lang.hm wrote:
> On Wed, 1 Apr 2009, Matthew Garrett wrote:
> >laptop-mode is something that makes sense as a default behaviour under a
> >lot of circumstances. Adding fsync() suppression means it's utterly
> >impossible to use it in that way. An additional mode would be perfectly
> >reasonable, as long as it's made clear that it's really a request for
> >data to be discarded at some point. The current mode isn't.
> 
> this issue seems pretty straightforward to me
> 
> the apps do fsync (and similar) to the degree that they think their data 
> is important (potentially with config options if they acknowlege that 
> their data isn't _always_ that important)
> 
> the system allows the admin to override the application and say "I'm 
> willing to loose up to X seconds of data for other benifits"
>
> if this can work cleanly (with the ordering issue that was identified, 
> which may involve having multiple versions of the metadata cached) it 
> seems like a very clean interface.

It does, but it's a different interface to the current one with a 
different aim and a different set of tradeoffs. The current behaviour of 
laptop-mode is that fsync() results in things hitting disk. The only 
configurability of laptop-mode is how long it then waits to flush out 
everything else as well.

The solution to "fsync() causes disk spinups" isn't "ignore fsync()". 
It's "ensure that applications only use fsync() when they really need 
it", which requires us to also be able to say "fsync() should not be 
required to ensure that events occur in order".

-- 
Matthew Garrett | mjg59@srcf.ucam.org
