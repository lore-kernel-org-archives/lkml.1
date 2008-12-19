Return-Path: <linux-kernel-owner+w=401wt.eu-S1754160AbYLSIRH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160AbYLSIRH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 03:17:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753250AbYLSIQ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 03:16:56 -0500
Received: from aeryn.fluff.org.uk ([87.194.8.8]:50533 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753063AbYLSIQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 03:16:55 -0500
Date: Fri, 19 Dec 2008 08:16:36 +0000
From: Ben Dooks <ben-linux@fluff.org>
To: Greg KH <greg@kroah.com>
Cc: Ben Dooks <ben-linux@fluff.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: device driver probe return codes
Message-ID: <20081219081636.GK12431@fluff.org.uk>
References: <20081216215331.GH12431@fluff.org.uk> <20081216234128.05a343bb.akpm@linux-foundation.org> <20081219051436.GA29543@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081219051436.GA29543@kroah.com>
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 18, 2008 at 09:14:36PM -0800, Greg KH wrote:
> On Tue, Dec 16, 2008 at 11:41:28PM -0800, Andrew Morton wrote:
> > On Tue, 16 Dec 2008 21:53:31 +0000 Ben Dooks <ben-linux@fluff.org> wrote:
> > 
> > > I would like some feedback on the following regarding some
> > > form of standardising return codes from a device driver probe
> > > to try and stop some basic mistakes.
> > > 
> > > This document is not complete, any additions would be welcone.
> 
> Hm, shouldn't you have at least copied me on this?

Sorry, assumed you'd be reading linux-kernel.

> What is this for?  Each of the different busses treat return codes for
> their probe functions a bit differently, are you wanting to unify them?
> And if so, why?

I was trying to make a guide for people to try and avoid the general
mistakes such as returning -ENODEV when it clearly isn't the right
thing to do. There are a number of drivers which return this causing
confusion as to why devices are not being bound as they neither print
an error nor cause the driver core to print anything [1].

The idea is to provide a guide to what error numbers are acceptable
to return and what the best return code for the common situations
that drivers tend to do and what to avoid.

As a note, having looked at the base driver, pci, platform and i2c
they all pass the error straight back to the core driver probe.

[1] There is a case to be put that drivers such as the i2c bus where
    the machine specific support has declared a device to be present
    to report an error if the probe then returns an -ENODEV or -ENXIO
    to say the device is not there.

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
