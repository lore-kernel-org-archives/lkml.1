Return-Path: <linux-kernel-owner+w=401wt.eu-S1759706AbXFMSyN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759706AbXFMSyN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 14:54:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754388AbXFMSxz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 14:53:55 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:40885 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806AbXFMSxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 14:53:55 -0400
X-Greylist: delayed 1214 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Jun 2007 14:53:54 EDT
Subject: Re: [kvm-devel] kvm + IOMMU
From: Gregory Haskins <ghaskins@novell.com>
To: David Brown <dmlb2000@gmail.com>
Cc: kvm-devel@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <9c21eeae0706131027i21d97e16k7aedf54134c727b8@mail.gmail.com>
References: <9c21eeae0706131027i21d97e16k7aedf54134c727b8@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 13 Jun 2007 14:32:32 -0400
Message-Id: <1181759552.16287.23.camel@ghaskins-t60p.haskins.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-06-13 at 10:27 -0700, David Brown wrote:
> I was wondering if anyone has done any sort of virtualization testing
> with kvm using IOMMU to improve performance of I/O and what sort of
> results they've had... I currently don't have a box with IOMMU (at
> least I don't think so, since its an i386 box) but will be getting
> some amd64 boxes which, hopefully will have that capability.
> 
> I was also wondering if kvm can take advantage of IOMMU does it need
> to be run a different way? or is it supposed to 'just work' if the
> kernel is built with IOMMU?
> 
> I keep seeing IOMMU patches fly by on the lkml however those are from
> the intel guys and the new boxes we are getting are amd... have the
> amd IOMMU support gotten into the kernel yet?
> 
> Not sure if this is the best place to ask these questions, so any help
> to point me in the right direction on who to talk to would also be
> helpful.

Hi David,
  I am not an expert here, but I don't believe it would work without
changes to KVM.  My understanding is that you use an IOMMU in this
fashion if you want to direct-map a device into a guest for devices that
do not have a local IOMMU-like functionality built in already.  For
instance, perhaps you want to assign an off-the-shelf ethernet NIC to a
guest.  The IOMMU would serve to translate between GPA and system based
DMA addresses.  However, the hypervisor would really need to be involved
in the setup of this mapping on the IOMMU in the first place.

KVM (currently) virtualizes/emulates all components in the logical
"system" presented to the guest.  It doesn't yet support the notion of
direct-mapping a physical component.  I doubt you will have to wait too
long for someone to add this feature, however :)  It's just not there
today (to my knowledge, anyway)

But to answer your question, when configured up like this the IO
subsystem in question should perform pretty close to native (at least in
theory).

Regards,
-Greg

