Return-Path: <linux-kernel-owner+w=401wt.eu-S1758114AbXFMSwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758114AbXFMSwU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 14:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751806AbXFMSwK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 14:52:10 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:50886 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688AbXFMSwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 14:52:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=iKTKUqMv0vb3b+Wyj3b9FSjGWgUrayjbyC6SSGHLyuZyQg8U8L7aPsxxlXNJ+bWm/slGQJRebkAIK2hrYjaRSema1ZFLe6Zusq4ovUFJK8VuIcLXyoxtslw6jGszttpkF/gqoP7ICvJRVZbdLMgoKllKXmtdG9ENNfB4hUBvRTI=
Message-ID: <9c21eeae0706131152y64b02e6fs4d120fcc3a5343fe@mail.gmail.com>
Date: Wed, 13 Jun 2007 11:52:08 -0700
From: "David Brown" <dmlb2000@gmail.com>
To: "Gregory Haskins" <ghaskins@novell.com>
Subject: Re: [kvm-devel] kvm + IOMMU
Cc: kvm-devel@lists.sourceforge.net,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <1181759552.16287.23.camel@ghaskins-t60p.haskins.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9c21eeae0706131027i21d97e16k7aedf54134c727b8@mail.gmail.com>
	 <1181759552.16287.23.camel@ghaskins-t60p.haskins.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi David,
>   I am not an expert here, but I don't believe it would work without
> changes to KVM.  My understanding is that you use an IOMMU in this
> fashion if you want to direct-map a device into a guest for devices that
> do not have a local IOMMU-like functionality built in already.  For
> instance, perhaps you want to assign an off-the-shelf ethernet NIC to a
> guest.  The IOMMU would serve to translate between GPA and system based
> DMA addresses.  However, the hypervisor would really need to be involved
> in the setup of this mapping on the IOMMU in the first place.

Okay its understandable that the initial setup of the mapping between
virtual and actual would be done by some OS (most-likely host).
However isn't the actual mapping when the guest starts and requests
devices supposed to be handled by hardware? I would think performance
wouldn't scale very well if the host OS had to maintain mappings and
translate addresses every time a guest requests access to a mapped
device.

> KVM (currently) virtualizes/emulates all components in the logical
> "system" presented to the guest.  It doesn't yet support the notion of
> direct-mapping a physical component.  I doubt you will have to wait too
> long for someone to add this feature, however :)  It's just not there
> today (to my knowledge, anyway)

That's good to hear. :)

> But to answer your question, when configured up like this the IO
> subsystem in question should perform pretty close to native (at least in
> theory).

Hopefully you mean that the hardware is handling the mapping so that
the host OS won't have to take the burden of mapping a bunch of
addresses all the time.

Thanks,
- David Brown
