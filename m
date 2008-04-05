Return-Path: <linux-kernel-owner+w=401wt.eu-S1755520AbYDEW7g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520AbYDEW7g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2008 18:59:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754158AbYDEW7S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Apr 2008 18:59:18 -0400
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:24262 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753766AbYDEW7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2008 18:59:17 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=TZzUsyOUu3mHWmfnuRB1rIUeF2V7uGaFLIeMoeGIhQZ5nFsE2cw7oHNrWXJl6SBriFlYKYFxy2hVFMigrz+9aqrIXTnS9BADDuCiCTE2Dw5cSd23Hd2v/jjHlB7zq9ZkWI5xXCoe2jDQBawD9oIXGAF4Q9wpNYjTmV6NdPGrEas=  ;
X-YMail-OSG: CP_9QhwVM1kwoNAVjnjVq3Oc0hmcs7oHauD68ToxMoJcR.7sqDNvu.Lt1izCzV.lCdHkFdB8UQ--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Ben Nizette <bn@niasdigital.com>, Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: [PATCH 1/1] [GPIO]: new arch-independent simple-gpio driver
Date: Sat, 5 Apr 2008 15:58:09 -0700
User-Agent: KMail/1.9.6
Cc: Bryan Wu <cooloney@kernel.org>, lkml <linux-kernel@vger.kernel.org>
References: <> <1206579921-22221-1-git-send-email-cooloney@kernel.org> <1206597150.3315.48.camel@moss.renham>
In-Reply-To: <1206597150.3315.48.camel@moss.renham>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200804051558.09785.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 26 March 2008, Ben Nizette wrote:
> >  drivers/char/simple-gpio.c |  308 ++++++++++++++++++++++++++++++++++++++++++++
>
> Considered putting this in drivers/gpio?  Not a real problem, up to you
> (or David).

I'd expect to see a generic GPIO mechanism like this
in drivers/gpio, yes.  But it should be a bit more
generic than this one is.


> > +/**
> > + *   simple_gpio_probe - setup the range of GPIOs
> > + *
> > + *   Create a character device for the range of GPIOs and have the minor be
> > + *   used to specify the GPIO.
> > + */
> > +static int __devinit simple_gpio_probe(struct platform_device *pdev)
> > +{
> > +     int ret;
> > +     struct group_data *group_data;
> > +     struct resource *gpio_range = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
> > +     int gpio, gpio_max = gpio_range->end - gpio_range->start + 1;
> > +
> 
> Was it a conscious thing to only allow 1 range of gpios per device?  I
> can imagine that it's quite likely that people are going to want to
> expose all unused gpios on a SoC to userspace.  This is going to mean
> lots of small ranges split either side of pre-reserved pins and one
> device per little range is gonna get cumbersome.

As I said in the other thread, this is what I most dislike about
this particular driver:  the need for board-specific setup.  The
need for a character device inode per GPIO could probably be lived
with, if that bigger issue were resolved.

The userspace GPIO access scenarios which seem most compelling to
me involve filling in gaps in board support.  Expecting the folk
who created those gaps (by overlooking them, or not knowing enough
about the system's eventual usage mode) to have enabled resolving
them in this way ... seems unwise.    :)

Building on Ben's comment, it's not just unused SOC GPIOs, it's
all the GPIOs on a board, some of which will be from a SOC and
others of which will be from external chips.

- Dave


