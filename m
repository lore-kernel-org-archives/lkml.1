Return-Path: <linux-kernel-owner+w=401wt.eu-S1761808AbZC1AJx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761808AbZC1AJx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 20:09:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753248AbZC1AJn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 20:09:43 -0400
Received: from n18.bullet.mail.mud.yahoo.com ([68.142.206.145]:25519 "HELO
	n18.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754744AbZC1AJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 20:09:42 -0400
X-Yahoo-Newman-Id: 644892.5157.bm@omp421.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=fieuZuSwVcdKaXk7WZft/Glzf8P/SAcDIl77j1aChRmvxWXnxqUgm+ELfv4zLzY6EZKeMhiueOJXzb/lWLCdCo5CuWOMcijohfYDWNH+n2ndAI4A+sjgHPnFAsopwFqWSNU1pFfYL6L+i+qeUjaK8ov/w16p+dirO/HyccshucU=  ;
X-YMail-OSG: IkbfEVIVM1lAkRHYSYp8RRj24hWsP4WdN_1F1rAooH33VWUpufNLq3fZ0mAa7vGr3h76JF5WYjEViuv979936QhBhOBd8PDOUwn9D2HLBtqG4U9._Ugh7h6uJMWNk7wobkTuTWbdHdWyyQTObCnhFC5y
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: "Uwe =?iso-8859-1?q?Kleine-K=F6nig?=" 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH 04/58] move at91_ether's probe function to .devinit.text
Date: Fri, 27 Mar 2009 17:09:37 -0700
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Jeff Garzik <jgarzik@redhat.com>,
       Paulius Zaleckas <paulius.zaleckas@teltonika.lt>,
       Marc Pignat <marc.pignat@hevs.ch>, Andrew Victor <linux@maxim.org.za>,
       Roel Kluin <12o3l@tiscali.nl>
References: <20090327232153.GA16348@pengutronix.de> <1238196439-16535-4-git-send-email-u.kleine-koenig@pengutronix.de>
In-Reply-To: <1238196439-16535-4-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200903271709.38383.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 27 March 2009, Uwe Kleine-König wrote:
> An alternative to this patch is using platform_driver_probe instead of
> platform_driver_register plus removing the pointer to the probe function
> from the struct platform_driver.

IMO that's preferable for this driver.  There's no
point in doing anything other than discarding the
probe() method after the driver has been set up;
it'd be doing nothing except wasting memory.

Same thing for ... pretty much all other drivers
for SoC platform devices.

In this series, you cc'd me on four OMAP drivers
(mmci-omap, mmci-omap-hs, omap-rng, omap_udc) which
I *know* that's a completely workable -- and far
preferable -- solution.  There might be others.



