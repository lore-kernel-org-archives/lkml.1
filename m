Return-Path: <linux-kernel-owner+w=401wt.eu-S1753318AbYLFReR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318AbYLFReR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 12:34:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751705AbYLFReD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 12:34:03 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37803 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751301AbYLFReC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 12:34:02 -0500
Date: Sat, 6 Dec 2008 09:33:37 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Greg KH <greg@kroah.com>, Ingo Molnar <mingo@elte.hu>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Takashi Iwai <tiwai@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH 1/3] PCI: Rework default handling of suspend and resume
In-Reply-To: <200812061822.35763.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.0812060930490.3425@nehalem.linux-foundation.org>
References: <200812020320.31876.rjw@sisk.pl> <200812061507.06474.rjw@sisk.pl> <alpine.LFD.2.00.0812060855580.3425@nehalem.linux-foundation.org> <200812061822.35763.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 6 Dec 2008, Rafael J. Wysocki wrote:
> 
> USB doesn't use that for PCI suspend-resume, it uses it for suspend-resume of
> USB devices behind the controller.

Oh, in that case there are no PCI users of this at all, and what the PCI 
driver does is immaterial ;)

> But then we will save the device's registers in the "sleeping" state. 

No no. The rule would be that a PCI driver - if it uses the new 
infrastructure, which apparently nobody does _as_ a PCI driver - simply 
would never do the whole "pci_set_power_state(PCI_D3hot)" etc crud AT ALL.

So a PCI driver would only do higher-level stuff in its suspend/resume 
code. For example, a USB host controller would initiate the USB bus level 
stuff, and likely just stop the controller (not suspend it - just stop 
it).

			Linus
