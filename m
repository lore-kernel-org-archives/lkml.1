Return-Path: <linux-kernel-owner+w=401wt.eu-S1756624AbZA0SmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756624AbZA0SmV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 13:42:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753913AbZA0SmG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 13:42:06 -0500
Received: from outbound-mail-146.bluehost.com ([67.222.38.36]:52612 "HELO
	outbound-mail-146.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752152AbZA0SmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 13:42:05 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=sMGcEiu1ti7pCNv3NLpoI1YDrkH83tXY8TT26dLU/8uv1EtoLDqGM9BzQu9iv/rbK745fDY8J6god3fa98QERhhIyZCvArqiWCKlEzdBlGqRLZBWklKoDwJ6Ns+IGm99;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Subject: Re: [PATCH] pci: fix no_pci_devices() #2
Date: Tue, 27 Jan 2009 10:41:52 -0800
User-Agent: KMail/1.9.10
Cc: "Greg KH" <gregkh@suse.de>, "Pekka Enberg" <penberg@cs.helsinki.fi>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
References: <20081220111419.GA5367@localhost.localdomain> <200901161041.10071.jbarnes@virtuousgeek.org> <19f34abd0901161121j2f5a21b5g2a73036dc20766ad@mail.gmail.com>
In-Reply-To: <19f34abd0901161121j2f5a21b5g2a73036dc20766ad@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901271041.53046.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, January 16, 2009 11:21 am Vegard Nossum wrote:
> On Fri, Jan 16, 2009 at 7:41 PM, Jesse Barnes <jbarnes@virtuousgeek.org> 
wrote:
> >> > Assuming Greg already took the generic part, can you resend the PCI
> >> > part to the linux-pci@vger.kernel.org list for review just in case
> >> > anyone has a better idea of how to do it?
> >>
> >> Did I take the generic part?  I can't remember...
> >
> > Doesn't look like it.  Vergard can you send out an updated patch set?
>
> Actually, my patch is still just a hack, since pci_bus_type.p is still
> set before the pci_bus_type is really usable. So if the kernel crashes
> (or, in general, no_pci_devices() is called) at some point between the
> pci_bus_type.p = <something> and pci_bus_type.p = NULL (which I
> inserted), we will still see the same type of fault.
>
> So I would prefer to solve this in a different way, like a dedicated
> flag which is only set after we know that pci_bus_type initialisation
> succeeded. I think that was the approach of my first patch? I don't
> remember. In any case, such a patch could not be split in generic/pci
> parts, I think. Also, should we anticipate concurrent access to
> pci_bus_type.p or such a dedicated "no_pci_devices" flag?
>
> Here is the first patch, but I wonder if it should be turned into
> atomic_t instead: http://lkml.org/lkml/2008/12/20/33

It seems like you could do this with a driver core call?  Isn't there a way to 
check whether a given bus type is registered?  If so, we could just use that 
from no_pci_devices instead of a new flag.

-- 
Jesse Barnes, Intel Open Source Technology Center
