Return-Path: <linux-kernel-owner+w=401wt.eu-S934034AbYBMXt0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934034AbYBMXt0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 18:49:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763185AbYBMXtK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 18:49:10 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:27938 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759871AbYBMXtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 18:49:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=B2Ypmq7TA2AkF6xNm2OWA6pXGLcz5RRcPxQlhTXGEvnoekKYjofpBi/Y1mgfPQDt1ypTrSYA+spBUgOpJDh/EjdZ0CYdK6OgF/zCQhzFSvOoJWsDKv43VKQV67zPtv5WlVYF8AwlNIq9vetia3zIagf+lSxCy3BjKlVdUML/Mjs=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Greg KH <greg@kroah.com>
Subject: Re: pci_get_device_reverse(), why does Calgary need this?
Date: Thu, 14 Feb 2008 01:02:55 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, muli@il.ibm.com, jdmason@kudzu.us,
       linux-ide@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       linux-kernel@vger.kernel.org, discuss@x86-64.org
References: <20080213001506.GA13933@kroah.com> <200802132320.37172.bzolnier@gmail.com> <20080213234140.GA5169@kroah.com>
In-Reply-To: <20080213234140.GA5169@kroah.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802140102.55805.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 14 February 2008, Greg KH wrote:
> On Wed, Feb 13, 2008 at 11:20:36PM +0100, Bartlomiej Zolnierkiewicz wrote:
> > On Wednesday 13 February 2008, Greg KH wrote:
> > > On Wed, Feb 13, 2008 at 09:28:24AM -0800, Greg KH wrote:
> > > > On Wed, Feb 13, 2008 at 01:34:12PM +0100, Bartlomiej Zolnierkiewicz wrote:
> > > > > On Wednesday 13 February 2008, Greg KH wrote:
> > > > > > On Wed, Feb 13, 2008 at 02:17:37AM +0000, Alan Cox wrote:
> > > > > > > > Why does the calgary driver need this?  Can we just use pci_get_device()
> > > > > > > > instead?  Why do you need to walk the device list backwards?  Do you get
> > > > > > > > false positives going forward?
> > > > > > > 
> > > > > > > It doesn't look to be performance critical so the driver can
> > > > > > > pci_get_device until the end and use the final hit anyway.
> > > > > > 
> > > > > > That would make more sense.
> > > > > > 
> > > > > > > IDE reverse is more problematic but nobody seems to use it.
> > > > > > 
> > > > > > I've seen two posters say they use it.  I'm wondering what it is really
> > > > > > solving if they use it, and why if it's really needed, scsi never had to
> > > > > > implement such a hack...
> > > > > 
> > > > > It is no longer solving anything, just adds more pain. ;)
> > > > > 
> > > > > [ The option comes from 2.2.x (so long before LABEL=/ and /dev/disk/by-id/
> > > > >   became popular).  Some "off-board" controllers integrated on motherboards
> > > > >   used to appear before "on-board" IDE on PCI bus so this option was meant
> > > > >   to preserve the legacy ordering. ]
> > > > > 
> > > > > Since it is valid only when "Probe IDE PCI devices in the PCI bus order
> > > > > (DEPRECATED)" config option is used it is already on its way out (though
> > > > > marking it as obsoleted would make it more explicit).
> > > > > 
> > > > > I think that removing "ide=reverse" in 2.6.26 would be OK...
> > > > 
> > > > Great, thanks for your blessing.  I'll make up a patch and send it to
> > > > you for approval.
> > > 
> > > How does the patch below look?  I didn't want to remove the whole config
> > > option, as there is more to the logic than just the "reverse order"
> > > stuff there.
> > 
> > looks fine,
> > 
> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> 
> Thanks.
> 
> > > If you don't mind, can I take this through the PCI tree so as to allow
> > > the removal of this pci function afterwards?
> > 
> > [...]
> > 
> > great, could you also:
> > - rebase it on top of the patch below
> > - forward the patch below to Linus for 2.6.25
> 
> Sure, you want this to go in for .25, but not the one I just posted
> removing this option, correct?  That should wait for .26?

Yes, lets give people the final call before actually removing this option
(unless of course there is some urgent reason for removing it in .25).

Thanks,
Bart
