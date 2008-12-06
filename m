Return-Path: <linux-kernel-owner+w=401wt.eu-S1753296AbYLFRpF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296AbYLFRpF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 12:45:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751376AbYLFRoy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 12:44:54 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60246 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751301AbYLFRoy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 12:44:54 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 1/3] PCI: Rework default handling of suspend and resume
Date: Sat, 6 Dec 2008 18:43:58 +0100
User-Agent: KMail/1.9.9
Cc: Greg KH <greg@kroah.com>, Ingo Molnar <mingo@elte.hu>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Takashi Iwai <tiwai@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <200812020320.31876.rjw@sisk.pl> <200812061822.35763.rjw@sisk.pl> <alpine.LFD.2.00.0812060930490.3425@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0812060930490.3425@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812061843.59495.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 6 of December 2008, Linus Torvalds wrote:
> 
> On Sat, 6 Dec 2008, Rafael J. Wysocki wrote:
> > 
> > USB doesn't use that for PCI suspend-resume, it uses it for suspend-resume of
> > USB devices behind the controller.
> 
> Oh, in that case there are no PCI users of this at all, and what the PCI 
> driver does is immaterial ;)
> 
> > But then we will save the device's registers in the "sleeping" state. 
> 
> No no. The rule would be that a PCI driver - if it uses the new 
> infrastructure, which apparently nobody does _as_ a PCI driver - simply 
> would never do the whole "pci_set_power_state(PCI_D3hot)" etc crud AT ALL.

Now _that_ sounds good. :-)

> So a PCI driver would only do higher-level stuff in its suspend/resume 
> code. For example, a USB host controller would initiate the USB bus level 
> stuff, and likely just stop the controller (not suspend it - just stop 
> it).

I like this idea very much.

So, to fix the issue at hand, I'd like the $subject patch to go first.  Then,
there is a major update of the new framework waiting for .29 in the Greg's
tree (that's the main reason why nobody uses it so far, BTW) and I'd really
prefer it to go next.  After it's been merged, I'm going to add the mandatory
suspend-resume things (save state and go to a low power state on suspend,
restore state on resume) to the new framework in a separete patch.

Is this plan acceptable?

Rafael
