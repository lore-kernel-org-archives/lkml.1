Return-Path: <linux-kernel-owner+w=401wt.eu-S1757923AbZJFRdH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757923AbZJFRdH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 13:33:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757600AbZJFRdG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 13:33:06 -0400
Received: from outbound-mail-313.bluehost.com ([67.222.54.6]:33092 "HELO
	outbound-mail-313.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757540AbZJFRdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 13:33:05 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=a627S1ySrnACPBWhQH81IVSvgniL2uHfY/qmVRY9y1TyK/v10+5XusWxRzC17CCACS8G+bimNh3RDFPE9ccU79cJ2sheOcguvLUeFcZGuUZEqoh7k+ZxrnAnsp20QPu9;
Date: Tue, 6 Oct 2009 10:32:13 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Linux PCI <linux-pci@vger.kernel.org>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Shaohua Li <shaohua.li@intel.com>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: [RFC][PATCH 3/4] PCI / ACPI PM: Platform support for PCI PME
 wake-up
Message-ID: <20091006103213.1803cb65@jbarnes-g45>
In-Reply-To: <200909210226.10671.rjw@sisk.pl>
References: <200909132320.05077.rjw@sisk.pl>
	<200909140053.05779.rjw@sisk.pl>
	<20090913225518.GA31787@srcf.ucam.org>
	<200909210226.10671.rjw@sisk.pl>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.17.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Sep 2009 02:26:10 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Monday 14 September 2009, Matthew Garrett wrote:
> > On Mon, Sep 14, 2009 at 12:53:05AM +0200, Rafael J. Wysocki wrote:
> > > On Monday 14 September 2009, Matthew Garrett wrote:
> > > > On Sun, Sep 13, 2009 at 11:24:03PM +0200, Rafael J. Wysocki
> > > > wrote:
> > > > > +	} else if (!dev->wakeup.flags.run_wake) {
> > > > > +		acpi_set_gpe_type(dev->wakeup.gpe_device,
> > > > > +
> > > > > dev->wakeup.gpe_number,
> > > > > +					ACPI_GPE_TYPE_WAKE);
> > > > 
> > > > Is this going to work for cases where we have multiple devices
> > > > attached to the same GPE? The common one is EHCI, where both
> > > > EHCI HCDs will be one a single GPE. If we wake one, that'll
> > > > then disable the GPE for the other. Further wakeup events will
> > > > then be lost.
> > > 
> > > You're right, I overlooked that.  Some kind of refcounting is
> > > needed here.
> > 
> > I've sent patches to implement this at the GPE level, which also
> > change the API for requesting them. I'm waiting on feedback from
> > Bob Moore.
> 
> In the meantime I realized there's one more thing we need to take
> care of. Namely, if a wake-up GPE is shared between multiple devices,
> it need not be necessary to install notify handlers for all of them.
> For example, if one of these devices is the root bridge, we will walk
> all of the hierarchy under it looking for devices that have PME set,
> so we need not install notify handlers for any devices that share the
> wake-up GPE with the root bridge.  Similarly, there's no need to
> install a notify handler for a device that shares the wake-up GPE
> with a bridge (non-root) it is under.
> 
> Taking that into account I have prepared another version of the
> @subject patch which is appended below.  It also takes the PM vs
> hotplug issue into account.  The idea is pretty straightforward,
> everything should be clear from the changelog and the comments within
> the patch.
> 

What's the latest on this set?  Is this the final version?  Anyone have
issues with this version?

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
