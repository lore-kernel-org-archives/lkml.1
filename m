Return-Path: <linux-kernel-owner+w=401wt.eu-S1753180AbXLXVyG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180AbXLXVyG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2007 16:54:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751783AbXLXVxy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Dec 2007 16:53:54 -0500
Received: from slackadelic.com ([65.196.224.53]:60297 "EHLO
	mail.slackadelic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667AbXLXVxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2007 16:53:53 -0500
From: Carlos Corbacho <carlos@strangeworlds.co.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: x86: Increase PCIBIOS_MIN_IO to 0x1500 to fix nForce 4 suspend-to-RAM
Date: Mon, 24 Dec 2007 21:53:47 +0000
User-Agent: KMail/1.9.7
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, "H. Peter Anvin" <hpa@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Len Brown <lenb@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <200712231419.40207.carlos@strangeworlds.co.uk> <200712241444.24031.rjw@sisk.pl> <alpine.LFD.0.9999.0712241008150.21557@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.9999.0712241008150.21557@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200712242153.48906.carlos@strangeworlds.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 24 December 2007 18:34:21 Linus Torvalds wrote:
> On Mon, 24 Dec 2007, Rafael J. Wysocki wrote:
> > Well, having considered that for a longer while, I think the AML code is
> > referring to a device that we have suspended already, and since it's in a
> > low power state, it just can't handle the reference.
> >
> > If that is the case, we'll have to find the device (that should be
> > possible using some code instrumentation) and move the suspending of it
> > into the late stage.
>
> Yes.

My own experimentation (in device_suspend(), calling _PTS() in the AML after 
each suspend_device() runs, until one device causes it to hang) points to 
ohci_hcd being the culprit here (with or without any devices attached). With 
the ohci_hcd module unloaded, the machine suspends just fine[1].

Of course, I'm at a complete loss as to why suspending OHCI would cause a 
problem for an IO port write.

> NOTE! This following patch is just for discussion, and while I think it's
> conceptually a good thing to try, I don't think it will help Carlos'
> problem. But removing the "pci_set_power_state()" in agp_nvidia_suspend()
> might.

nvidia-agp cannot be built on x86-64, so it's not the culprit in this case.

-Carlos

[1] And yes, I double checked the custom DSDT is not loaded this time.
-- 
E-Mail: carlos@strangeworlds.co.uk
Web: strangeworlds.co.uk
GPG Key ID: 0x23EE722D
