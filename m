Return-Path: <linux-kernel-owner+w=401wt.eu-S1756694AbZCBWBY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756694AbZCBWBY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 17:01:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754653AbZCBWAz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 17:00:55 -0500
Received: from n13a.bullet.mail.mud.yahoo.com ([68.142.207.51]:42781 "HELO
	n13a.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754527AbZCBWAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 17:00:54 -0500
X-Yahoo-Newman-Id: 121891.54966.bm@omp410.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=JIqmI+Xe+wPJbZaujY6QaJVGmG6YJM30CWVJ0aGIePrLOe6kBrpEMiNAa8W+TASi4mtaAQRcnD/rYlrmOXu33zFxEZFD6+5p+VCVxNTCmK0ZgJLAJH6D+1OrEWDEkvtSc9XccJwfhRCZ2xlEsVV/MKmVJjhEhWtXYrOINwBBMto=  ;
X-YMail-OSG: paZNTDcVM1neto7AnmHgtaUcqcRUGxm6bJozYyb1FxEN5BP5QFR_m_gGdSnHfZabtZ3wZwlZPVU8kB.6B.VuL8p6.7v.lXTf_Q9DcopB2KUoj9D5gDuwZ7ZRKeukM5LYH9nMMbcOhU1cFFDJ_ynrv2A2CUFS1My393aPczu3.hMMLGlLx3O90NiiVcTd
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Subject: Re: [patch 2.6.29-rc6+misc] MMC: regulator utilities
Date: Mon, 2 Mar 2009 14:00:49 -0800
User-Agent: KMail/1.9.10
Cc: Mark Brown <broonie@sirena.org.uk>, Liam Girdwood <lrg@slimlogic.co.uk>,
       lkml <linux-kernel@vger.kernel.org>, OMAP <linux-omap@vger.kernel.org>
References: <200902081037.06645.david-b@pacbell.net> <200903021327.14285.david-b@pacbell.net> <20090302224040.5e7ab0b2@mjolnir.ossman.eu>
In-Reply-To: <20090302224040.5e7ab0b2@mjolnir.ossman.eu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903021400.50201.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 March 2009, Pierre Ossman wrote:
> > > > +int mmc_regulator_set_ocr(struct mmc_host *host, struct regulator *supply)
> > > > +{
> > > 
> > > Why not pass the vdd directly? Saves a few dereferences if nothing else.
> > 
> > This call syntax is simpler, which is usually a win.
> > Passing a third parameter would create fault paths
> > of the "pass *wrong* parameter" flavor.
> > 
> > In terms of object code, when I've looked at such things
> > the dereferences generally cost the same as a ref to a
> > parameter, but passing an extra parameter isn't free.
> > 
> 
> I couldn't see host being used in there, so I was thinking more of a
> replacement, not an addition.

Oh, I see.  That'd make sense.  Just pass host->ios.vdd.



