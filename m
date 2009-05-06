Return-Path: <linux-kernel-owner+w=401wt.eu-S1758873AbZEFHWr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758873AbZEFHWr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 03:22:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753413AbZEFHWe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 03:22:34 -0400
Received: from sous-sol.org ([216.99.217.87]:33103 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752381AbZEFHWd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 03:22:33 -0400
Date: Wed, 6 May 2009 00:22:12 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Gregory Haskins <ghaskins@novell.com>
Cc: Chris Wright <chrisw@sous-sol.org>,
       Gregory Haskins <gregory.haskins@gmail.com>,
       Avi Kivity <avi@redhat.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org
Subject: Re: [RFC PATCH 0/3] generic hypercall support
Message-ID: <20090506072212.GV3036@sequoia.sous-sol.org>
References: <20090505132005.19891.78436.stgit@dev.haskins.net> <4A0040C0.1080102@redhat.com> <4A0041BA.6060106@novell.com> <4A004676.4050604@redhat.com> <4A0049CD.3080003@gmail.com> <20090505231718.GT3036@sequoia.sous-sol.org> <4A010927.6020207@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A010927.6020207@novell.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Gregory Haskins (ghaskins@novell.com) wrote:
> Chris Wright wrote:
> > But a free-form hypercall(unsigned long nr, unsigned long *args, size_t count)
> > means hypercall number and arg list must be the same in order for code
> > to call hypercall() in a hypervisor agnostic way.
> 
> Yes, and that is exactly the intention.  I think its perhaps the point
> you are missing.

Yes, I was reading this as purely any hypercall, but it seems a bit
more like:
 pv_io_ops->iomap()
 pv_io_ops->ioread()
 pv_io_ops->iowrite()

<snip>
> Today, there is no equivelent of a platform agnostic "iowrite32()" for
> hypercalls so the driver would look like the pseudocode above except
> substitute with kvm_hypercall(), lguest_hypercall(), etc.  The proposal
> is to allow the hypervisor to assign a dynamic vector to resources in
> the backend and convey this vector to the guest (such as in PCI
> config-space as mentioned in my example use-case).  The provides the
> "address negotiation" function that would normally be done for something
> like a pio port-address.   The hypervisor agnostic driver can then use
> this globally recognized address-token coupled with other device-private
> ABI parameters to communicate with the device.  This can all occur
> without the core hypervisor needing to understand the details beyond the
> addressing.

VF drivers can also have this issue (and typically use mmio).
I at least have a better idea what your proposal is, thanks for
explanation.  Are you able to demonstrate concrete benefit with it yet
(improved latency numbers for example)?

thanks,
-chris
