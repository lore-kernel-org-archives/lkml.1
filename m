Return-Path: <linux-kernel-owner+w=401wt.eu-S1945917AbXBBOxg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945917AbXBBOxg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 09:53:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945914AbXBBOxg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 09:53:36 -0500
Received: from accolon.hansenpartnership.com ([64.109.89.108]:39686 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161150AbXBBOxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 09:53:34 -0500
Subject: Re: [PATCH] scsi_lib.c: continue after MEDIUM_ERROR
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Alan <alan@lxorguk.ukuu.org.uk>
Cc: Ric Wheeler <ric@emc.com>, Mark Lord <liml@rtr.ca>,
       linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
In-Reply-To: <20070202144211.5a2d2365@localhost.localdomain>
References: <200701301947.08478.liml@rtr.ca>
	 <1170206199.10890.13.camel@mulgrave.il.steeleye.com>
	 <45C2474E.9030306@rtr.ca>
	 <1170366920.3388.62.camel@mulgrave.il.steeleye.com>
	 <45C32C7F.9050706@emc.com>  <20070202144211.5a2d2365@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 02 Feb 2007 08:53:27 -0600
Message-Id: <1170428007.3380.4.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-02-02 at 14:42 +0000, Alan wrote:
> > The interesting point of this question is about the typically pattern of 
> > IO errors. On a read, it is safe to assume that you will have issues 
> > with some bounded numbers of adjacent sectors.
> 
> Which in theory you can get by asking the drive for the real sector size
> from the ATA7 info. (We ought to dig this out more as its relevant for
> partition layout too).
> 
> > I really like the idea of being able to set this kind of policy on a per 
> > drive instance since what you want here will change depending on what 
> > your system requirements are, what the system is trying to do (i.e., 
> > when trying to recover a failing but not dead yet disk, IO errors should 
> > be as quick as possible and we should choose an IO scheduler that does 
> > not combine IO's).
> 
> That seems to be arguing for a bounded "live" time including retry run
> time for a command. That's also more intuitive for real time work and for
> end user setup. "Either work or fail within n seconds"

Actually, then I think perhaps we use the allowed retries for this ...

So you would fail a single sector and count it against the retries.
When you've done this allowed retries times, you fail the rest of the
request.

James


