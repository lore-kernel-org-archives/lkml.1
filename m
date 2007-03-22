Return-Path: <linux-kernel-owner+w=401wt.eu-S934147AbXCVXcN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934147AbXCVXcN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 19:32:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934164AbXCVXcN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 19:32:13 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:56424 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934147AbXCVXcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 19:32:12 -0400
Date: Fri, 23 Mar 2007 00:32:10 +0100
From: Andreas Mohr <andi@rhlx01.fht-esslingen.de>
To: Timur Tabi <timur@freescale.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Confused about audio drivers - where do I start?
Message-ID: <20070322233210.GA31582@rhlx01.hs-esslingen.de>
References: <46030AAD.4030509@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46030AAD.4030509@freescale.com>
User-Agent: Mutt/1.4.2.2i
X-Priority: none
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Mar 22, 2007 at 06:01:01PM -0500, Timur Tabi wrote:
> If I were to write a non-USB audio device driver from scratch (for new 
> hardware), what interface would I use?  Has ALSA become the official Linux 
> kernel audio subsystem?  Is there a specific device driver I should use as 
> a sample?

Yes, a driver should definitely be written against ALSA.

It's probably a good idea to use the most wide-spread card/driver close to the
hardware/functionality area of your new card as a sample driver,
the reasoning being that due to that card's wide use it's most likely that
all features are implemented as expected there.

And make sure to examine your new hardware about which sound card standards
it supports (AC-97, ...) which already have good generic support in ALSA.

When designing the mixer interface, definitely read ControlNames.txt and
name all mixer controls properly, since mixer apps have strongly differing
behaviour and may not work correctly without very strict and verbose control
naming. This implies wide testing with different mixer apps, too (gamix,
alsamixer, alsamixergui, gnome-alsamixer, kmix, aumix, ...).
Why I'm saying this? Because the first user report about my azt3328 driver
let me realize that some controls' naming was still broken despite having fixed
most of those a while ago...

Andreas Mohr
