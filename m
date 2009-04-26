Return-Path: <linux-kernel-owner+w=401wt.eu-S1753940AbZDZMAv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940AbZDZMAv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 08:00:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752577AbZDZMAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 08:00:40 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59855 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752305AbZDZMAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 08:00:40 -0400
Date: Sun, 26 Apr 2009 13:00:37 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Mike Rapoport <mike@compulab.co.il>
Cc: lrg@slimlogic.co.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] regulator: add userspace-consumer driver
Message-ID: <20090426120036.GA10900@opensource.wolfsonmicro.com>
References: <cover.1240736991.git.mike@compulab.co.il> <f9c42ab0212ead9b7edac2d39f7848c46ad527d5.1240736991.git.mike@compulab.co.il> <20090426100211.GC9009@opensource.wolfsonmicro.com> <49F449B8.2010707@compulab.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49F449B8.2010707@compulab.co.il>
X-Cookie: You will wish you hadn't.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 26, 2009 at 02:47:04PM +0300, Mike Rapoport wrote:
> Mark Brown wrote:

> > Why are you using a regulator_consumer_supply here?  All that's being
> > used here is the name and I can't see why you'd want the device.

> For upwards compatibility :)
> Well, seriously, I think using 'struct regulator_consumer_supply *supplies'
> rather than 'char *supplies' makes the platform code that registers the
> userspace-consumer device clearer.

On the other hand it merges the consumer and machine APIs, which we
really want to keep separate, and I can't see having the struct device
in there doing anything except confuse people.  If you're going to pick
an existing structure to use I'd be more inclined to use the bulk
consumer structure (which the driver needs to allocate anyway).
