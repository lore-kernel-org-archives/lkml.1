Return-Path: <linux-kernel-owner+w=401wt.eu-S1759859AbYBMMU5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759859AbYBMMU5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 07:20:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756773AbYBMMUe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 07:20:34 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:39111 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755677AbYBMMUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 07:20:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=Qn44gRBbPSyL7m5tU1fj2l7i3Ef+NhGFXjcCbY48bgsxt1TASBLdOibuJWUwPklkDDYBgvpm+cH7UHyLef3myRbKd3feIDUUcqTc5YSY78NQ6h01yRQatT3LFkTDSO4QFHEPArLdBLDhs/B2Cs3rWlL/PNymTzdloDe9y5v58nQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Greg KH <greg@kroah.com>
Subject: Re: pci_get_device_reverse(), why does Calgary need this?
Date: Wed, 13 Feb 2008 13:34:12 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, muli@il.ibm.com, jdmason@kudzu.us,
       linux-ide@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       linux-kernel@vger.kernel.org, discuss@x86-64.org
References: <20080213001506.GA13933@kroah.com> <20080213021737.72b9815d@core> <20080213044536.GC10101@kroah.com>
In-Reply-To: <20080213044536.GC10101@kroah.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802131334.12351.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 13 February 2008, Greg KH wrote:
> On Wed, Feb 13, 2008 at 02:17:37AM +0000, Alan Cox wrote:
> > > Why does the calgary driver need this?  Can we just use pci_get_device()
> > > instead?  Why do you need to walk the device list backwards?  Do you get
> > > false positives going forward?
> > 
> > It doesn't look to be performance critical so the driver can
> > pci_get_device until the end and use the final hit anyway.
> 
> That would make more sense.
> 
> > IDE reverse is more problematic but nobody seems to use it.
> 
> I've seen two posters say they use it.  I'm wondering what it is really
> solving if they use it, and why if it's really needed, scsi never had to
> implement such a hack...

It is no longer solving anything, just adds more pain. ;)

[ The option comes from 2.2.x (so long before LABEL=/ and /dev/disk/by-id/
  became popular).  Some "off-board" controllers integrated on motherboards
  used to appear before "on-board" IDE on PCI bus so this option was meant
  to preserve the legacy ordering. ]

Since it is valid only when "Probe IDE PCI devices in the PCI bus order
(DEPRECATED)" config option is used it is already on its way out (though
marking it as obsoleted would make it more explicit).

I think that removing "ide=reverse" in 2.6.26 would be OK...

Thanks,
Bart
