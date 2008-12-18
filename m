Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752892AbYLRSQq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892AbYLRSQq (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 13:16:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751796AbYLRSQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 13:16:36 -0500
Received: from smtp116.sbc.mail.sp1.yahoo.com ([69.147.64.89]:25048 "HELO
	smtp116.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751577AbYLRSQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 13:16:35 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=1vDvicmaabe6FeZTub77fhLg9O4YneA42LRBbZ1Qu0DR31EvXLRGucxKQuqVnnTnaPQDI5n1Qa1RJMoJSGgva6vOUbA+q6jJc4ClvQfQl2NH2BcGqCGpvtb7NRwXwtkLbhOw62vwZdEBsSLI/klGdkhIOl9/5w3sAX0uD58s8wA=  ;
X-YMail-OSG: w0ln1mMVM1nQ4jjOQb4pqI7cWNc9rVqBTKaSn2fkAd4ETaTYXCChNbDl74TCywy7f3le5oadj62dCzyY1JFecrqcoe0xbERDC9upIaHKSsTcaJ7OW3GS9YQPcTnI_vxpuhAxUr8ssE5ioBnHSVZQOuYfxbc6Chl.X9GsIdCL8Ixl2vg23blhOOCvVBuE
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>
Subject: Re: GPIO: Fix probe() error return in gpio driver probes
Date: Thu, 18 Dec 2008 10:16:27 -0800
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
References: <20081212152426.745254309@fluff.org.uk> <20081215101616.GB12431@fluff.org.uk> <20081215112226.18f7fb29@hyperion.delvare>
In-Reply-To: <20081215112226.18f7fb29@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812181016.28184.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 15 December 2008, Jean Delvare wrote:
> 
> > > > I was thinking that -EINVAL is almost the least informative
> > > > diagnostic code possible, since so many places return it
> > > > that it's usually hard to find out *which* invalid parameter
> > > > triggered ...
> > > > 
> > > > Is there a less-overloaded code you could return?
> > > 
> > > -EINVAL sounds right to me, all that's really missing is dev_dbg()
> > > messages in the drivers to log what the exact problem was. 

Fair enough, though it just papers over how ambiguous -EINVAL is.


> > It might be more acceptable to be dev_err(), that way it will get
> > printed no matter what debug options have been selected. If so, a
> > seperate patch is probably in order to make the change.
> 
> As far as I can see, such errors would be caused by development-time
> mistakes, so dev_dbg() seems appropriate. dev_err() would make the
> binaries larger for all end-users.

Right, dev_dbg() is the way to go.  I'd ack a version of this patch
which pairs these -EINVAL changes with dev_dbg() messages to make
these problems less painful to track down.  dev_err() is much abused.

- Dave

