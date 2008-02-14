Return-Path: <linux-kernel-owner+w=401wt.eu-S933234AbYBNU76@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933234AbYBNU76 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 15:59:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757145AbYBNU7r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 15:59:47 -0500
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:8273 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756405AbYBNU7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 15:59:46 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: a7839e96 (PNP: increase max resources) breaks my ALSA intel8x0 sound card
Date: Thu, 14 Feb 2008 14:01:24 -0700
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Robert Hancock <hancockr@shaw.ca>,
       Andrew Morton <akpm@linux-foundation.org>, avuton@gmail.com,
       yakui.zhao@intel.com, shaohua.li@intel.com, trenn@suse.de,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       alsa-devel@alsa-project.org
References: <fa.Kmpf0B4W44W1VefIME7+BnfUouY@ifi.uio.no> <200802141307.59120.bjorn.helgaas@hp.com> <alpine.LFD.1.00.0802141226010.6110@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0802141226010.6110@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802141401.24723.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 14 February 2008 01:26:59 pm Linus Torvalds wrote:
> 
> On Thu, 14 Feb 2008, Bjorn Helgaas wrote:
> 
> > On Thursday 14 February 2008 12:42:52 pm Linus Torvalds wrote:
> > > 
> > > It *shouldn't* fail.
> > > 
> > > Things should fail only when two different drivers have requested the same 
> > > region. NOT when something tells the system that a region _exists_.
> > 
> > The sound driver doesn't fail because two different drivers have
> > requested the same region; it fails because PNP told us a region
> > exists, and the sound region crosses the edge of the PNP region.
> 
> Right, and that was a bug.
> 
> It *shouldn't* fail. The PnP resource should be inserted _after_ the 
> PCI region has been inserted, and _that_ should fail, since the PnP region 
> is crap and cannot be inserted "half-way".

That means the PNP system driver has to be registered after the PCI
driver.  We can't guarantee that, especially if the sound driver is
a module.

Bjorn
