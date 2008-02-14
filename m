Return-Path: <linux-kernel-owner+w=401wt.eu-S932997AbYBNU10@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932997AbYBNU10 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 15:27:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757287AbYBNU1S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 15:27:18 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43549 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756846AbYBNU1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 15:27:17 -0500
Date: Thu, 14 Feb 2008 12:26:59 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
cc: Robert Hancock <hancockr@shaw.ca>,
       Andrew Morton <akpm@linux-foundation.org>, avuton@gmail.com,
       yakui.zhao@intel.com, shaohua.li@intel.com, trenn@suse.de,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       alsa-devel@alsa-project.org
Subject: Re: a7839e96 (PNP: increase max resources) breaks my ALSA intel8x0
 sound card
In-Reply-To: <200802141307.59120.bjorn.helgaas@hp.com>
Message-ID: <alpine.LFD.1.00.0802141226010.6110@woody.linux-foundation.org>
References: <fa.Kmpf0B4W44W1VefIME7+BnfUouY@ifi.uio.no> <200802141151.40396.bjorn.helgaas@hp.com> <alpine.LFD.1.00.0802141141470.6110@woody.linux-foundation.org> <200802141307.59120.bjorn.helgaas@hp.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 14 Feb 2008, Bjorn Helgaas wrote:

> On Thursday 14 February 2008 12:42:52 pm Linus Torvalds wrote:
> > 
> > It *shouldn't* fail.
> > 
> > Things should fail only when two different drivers have requested the same 
> > region. NOT when something tells the system that a region _exists_.
> 
> The sound driver doesn't fail because two different drivers have
> requested the same region; it fails because PNP told us a region
> exists, and the sound region crosses the edge of the PNP region.

Right, and that was a bug.

It *shouldn't* fail. The PnP resource should be inserted _after_ the 
PCI region has been inserted, and _that_ should fail, since the PnP region 
is crap and cannot be inserted "half-way".

		Linus
