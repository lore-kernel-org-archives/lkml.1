Return-Path: <linux-kernel-owner+w=401wt.eu-S1756584AbYHVTpF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756584AbYHVTpF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 15:45:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751764AbYHVTox
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 15:44:53 -0400
Received: from 1wt.eu ([62.212.114.60]:1153 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751292AbYHVTox (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 15:44:53 -0400
Date: Fri, 22 Aug 2008 21:44:28 +0200
From: Willy Tarreau <w@1wt.eu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Constantin Baranov <const@const.mimas.ru>, linux-kernel@vger.kernel.org,
       Richard Purdie <rpurdie@rpsys.net>
Subject: Re: [PATCH 2.6.27-rc3] led: driver for LEDs on PCEngines ALIX.2 and ALIX.3 boards
Message-ID: <20080822194428.GB31789@1wt.eu>
References: <48AB019D.6080302@const.mimas.ru> <20080822115150.6b3907a4.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080822115150.6b3907a4.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Fri, Aug 22, 2008 at 11:51:50AM -0700, Andrew Morton wrote:
> On Tue, 19 Aug 2008 22:23:41 +0500
> Constantin Baranov <const@const.mimas.ru> wrote:
> > +static int __init alix_led_probe(struct platform_device *pdev)
> > +{
> > +	int i;
> > +	int ret = 0;
> > +	
> > +	for (i = 0; i < ARRAY_SIZE(alix_leds) && ret >= 0; i++)
> > +		ret = led_classdev_register(&pdev->dev, &alix_leds[i].cdev);
> > +
> > +	if (ret < 0) {
> > +		for (i = i - 2; i >= 0; i--)
> 
> this is off-by-one, surely.
> 
> If we get here with i==1, we'll loop 4 billion times.

No we will not because i is signed. We'll simply not enter the loop.
However, the code looks suspicious and the reasoning behind i-2 isn't
quite clear.

Willy

