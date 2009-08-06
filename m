Return-Path: <linux-kernel-owner+w=401wt.eu-S1755353AbZHFM0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353AbZHFM0A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 08:26:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753016AbZHFM0A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 08:26:00 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44122 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752931AbZHFMZ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 08:25:59 -0400
Date: Thu, 6 Aug 2009 15:24:49 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gregory Haskins <ghaskins@novell.com>
Cc: alacrityvm-devel@lists.sourceforge.net, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 0/7] AlacrityVM guest drivers Reply-To:
Message-ID: <20090806122449.GC11038@redhat.com>
References: <20090803171030.17268.26962.stgit@dev.haskins.net> <20090806081955.GA9752@redhat.com> <4A7A8F7B0200005A00051B84@sinclair.provo.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A7A8F7B0200005A00051B84@sinclair.provo.novell.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 06, 2009 at 06:08:27AM -0600, Gregory Haskins wrote:
> Hi Michael,
> 
> >>> On 8/6/2009 at  4:19 AM, in message <20090806081955.GA9752@redhat.com>,
> "Michael S. Tsirkin" <mst@redhat.com> wrote: 
> > On Mon, Aug 03, 2009 at 01:17:30PM -0400, Gregory Haskins wrote:
> >> (Applies to v2.6.31-rc5, proposed for linux-next after review is complete)
> > 
> > These are guest drivers, right?
> 
> Yep.
> 
> > Merging the guest first means relying on
> > kernel interface from an out of tree driver, which well might change
> > before it goes in.
> 
> ABI compatibility is already addressed/handled, so even if that is true its not a problem.

It is? With versioning? Presumably this:

+       params.devid   = vdev->id;
+       params.version = version;
+
+       ret = vbus_pci_hypercall(VBUS_PCI_HC_DEVOPEN,
+                                &params, sizeof(params));
+       if (ret < 0)
+               return ret;

Even assuming host even knows how to decode this structure (e.g.  some
other host module doesn't use VBUS_PCI_HC_DEVOPEN), checks the version
and denies older guests, this might help guest not to crash, but guest
still won't work.

> > Would it make more sense to start merging with the host side of the project?
> 
> Not necessarily, no.  These are drivers for a "device", so its no
> different than merging any other driver really.  This is especially
> true since the hypervisor is also already published and freely
> available today, so anyone can start using it.

The difference is clear to me: devices do not get to set kernel/userspace
interfaces. This "device" depends on a specific interface between
kernel and (guest) userspace.

-- 
MST
