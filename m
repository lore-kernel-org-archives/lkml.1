Return-Path: <linux-kernel-owner+w=401wt.eu-S1751781AbZIHRvu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751781AbZIHRvu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 13:51:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751954AbZIHRvu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 13:51:50 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53508 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751750AbZIHRvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 13:51:49 -0400
Date: Tue, 8 Sep 2009 18:53:06 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-ide@vger.kernel.org,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Limiting DMA speeds for individual IDE drives
Message-ID: <20090908185306.0f30c07b@lxorguk.ukuu.org.uk>
In-Reply-To: <Pine.LNX.4.44L0.0909081157520.2653-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.0909081157520.2653-100000@iolanthe.rowland.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I've got a situation where a drive claims to be capable of supporting
> UDMA/100, but it's in a noisy environment and gets lots of errors at
> that speed.  I'd like to limit it to UDMA/66 or even UDMA/33.

That should never occur with a proper cable and I would be concerned the
fault might be something more problematic such as speed misconfiguration
or an incompatibility. Which driver is in use ?

> The hdparm command should be able to do this but I can't run it until 
> the system has booted, by which time a bunch of CRC and possibly other 
> errors have already occurred.  Ideally it should be possible to limit 

Only the data transfers are CRC protected and at high speed, but noise at
low speed would be a real concern as the commands are sent low speed but
without protection on PATA devices - so a bit flip can send a DMA to the
wrong sector.

> the speed starting as early as device detection, but I can't find any 
> way to do it.  Is there support for such a thing or will I have to hack 
> it in?

You can disallow DMA but not clip DMA to UDMA33 with the old driver. You
could disallow DMA at boot and reallow it with a speed set by hdparm in
your boot scripts...
