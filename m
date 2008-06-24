Return-Path: <linux-kernel-owner+w=401wt.eu-S1757136AbYFXKd4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757136AbYFXKd4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 06:33:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752435AbYFXKds
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 06:33:48 -0400
Received: from gate.crashing.org ([63.228.1.57]:33929 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752578AbYFXKdr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 06:33:47 -0400
Subject: Re: [PATCH 1/4] ide-pmac: media-bay support fixes
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <200806232345.07621.bzolnier@gmail.com>
References: <200806162124.43005.bzolnier@gmail.com>
	 <1214203312.8011.246.camel@pasglop> <1214218047.8011.268.camel@pasglop>
	 <200806232345.07621.bzolnier@gmail.com>
Content-Type: text/plain
Date: Tue, 24 Jun 2008 20:33:37 +1000
Message-Id: <1214303617.8011.342.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I (naively?) hope that you are using ide-pmac as a base (the driver looks
> like a normal host driver now) and going to make the final API switch after
> hardware specific changes are complete (so we will be able to use git-bisect
> instead of guesswork combined with voodoo dance when dealing with potential
> regressions :-).

I intend to yes :-) Along with my WIP pata_macio of course but I don't
like leaving a driver broken and/or non bisectable, believe me.

> You may want to look at ACPI hotplug dock handling for inspiration
> (if you haven't already).

Thanks, I will. I've been busy with all sorts of other things so no, I
haven't looked yet, and it's a bit less urgent, but thanks for the
pointer,

> There is no longer any hackery on IDE core code side in 2.6.26, there are
> just two nice methods: ide_port_unregister_devices() and ide_scan_port().

Sure but the fact that mediabay calls them directly makes it painful to
deal with 2 drivers, one using drivers/ide and one libata. So I want to
turn that into a notification into the low level driver so it does what
is appropriate.

> Therefore I would prefer to also update ide-pmac for new methods and just
> add what is needed (if any) to IDE core code.

Sure. I don't think I will need to change any of the core.

> [ Please keep me in loop on these mediabay changes. ]

I'll let you know when I get something done.

Cheers,
Ben.


