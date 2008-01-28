Return-Path: <linux-kernel-owner+w=401wt.eu-S1757054AbYA1BPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757054AbYA1BPq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 20:15:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753619AbYA1BPh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 20:15:37 -0500
Received: from mga11.intel.com ([192.55.52.93]:3412 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753047AbYA1BPg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 20:15:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,257,1199692800"; 
   d="scan'208";a="293564317"
Subject: Re: a7839e96 (PNP: increase max resources) breaks my ALSA intel8x0
	sound card
From: Shaohua Li <shaohua.li@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Avuton Olrich <avuton@gmail.com>, Zhao Yakui <yakui.zhao@intel.com>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, Thomas Renninger <trenn@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Linux-Kernel," <linux-kernel@vger.kernel.org>,
       Alsa-Devel <alsa-devel@alsa-project.org>
In-Reply-To: <alpine.LFD.1.00.0801280841440.4544@www.l.google.com>
References: <3aa654a40801270640s59cfdcc4lfa3fb487e0d9b799@mail.gmail.com>
	 <alpine.LFD.1.00.0801280841440.4544@www.l.google.com>
Content-Type: text/plain
Date: Mon, 28 Jan 2008 09:15:23 +0800
Message-Id: <1201482923.24645.1.camel@sli10-desk.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-01-28 at 08:50 +1100, Linus Torvalds wrote:
> 
> On Sun, 27 Jan 2008, Avuton Olrich wrote:
> >
> > With v2.6.24 my second ALSA sound device stopped working.
> 
> Hmm. Why is PnP ACPI called before PCI probing? That seems to be the 
> problem here - we should *never* have any firmware allocation block known 
> hardware BARs, they should only be blocking new dynamic allocations.
> 
> Hmm. I wonder if the problem is that ACPIPnP marks the regions busy. That 
> would be wrong. They shouldn't be busy, they should just "exist".
> 
> A busy region will stop a "request_region()" (incorrect for this case - 
> thats' not what the PnP resurce allocation should be all about), but an 
> *existing* resource will just stop a new resource being dynamically 
> assigned to that address (not not stop a known resource from using it).
> 
> So maybe the ACPIPnP allocation is doen at the right moment, just doing 
> the wrong thing..
This is because the region is declaimed in motherboard device. That is
BIOS thinks the region is reserved for motherboard. Maybe we should
blacklist the system too.

