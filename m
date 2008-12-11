Return-Path: <linux-kernel-owner+w=401wt.eu-S1758606AbYLKTtp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758606AbYLKTtp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 14:49:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758501AbYLKT11
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 14:27:27 -0500
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:12491 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758884AbYLKT10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 14:27:26 -0500
Date: Thu, 11 Dec 2008 12:27:25 -0700
From: Alex Chiang <achiang@hp.com>
To: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <syrjala@sci.fi>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, justin.chen@hp.com,
       linux-pci <linux-pci@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] PCI Hotplug: acpiphp wants a 64-bit _SUN
Message-ID: <20081211192725.GH18309@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <syrjala@sci.fi>,
	Jesse Barnes <jbarnes@virtuousgeek.org>, justin.chen@hp.com,
	linux-pci <linux-pci@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <20081211181242.GD18309@ldl.fc.hp.com> <20081211181644.GE18309@ldl.fc.hp.com> <20081211192356.GS31176@sci.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081211192356.GS31176@sci.fi>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ville Syrjälä <syrjala@sci.fi>:
> On Thu, Dec 11, 2008 at 11:16:44AM -0700, Alex Chiang wrote:
> > From: Justin Chen <justin.chen@hp.com>
> > 
> > Certain HP machines require the full 64 bits of _SUN as allowed
> > by the ACPI spec. Without this change, we get name collisions in
> > the lower 32 bits of the _SUN returned by firmware.
> > 
> > Signed-off-by: Justin Chen <justin.chen@hp.com>
> > Signed-off-by: Alex Chiang <achiang@hp.com>
> > ---
> > diff --git a/drivers/pci/hotplug/acpiphp.h b/drivers/pci/hotplug/acpiphp.h
> > index f9e244d..9bcb6cb 100644
> > --- a/drivers/pci/hotplug/acpiphp.h
> > +++ b/drivers/pci/hotplug/acpiphp.h
> > @@ -113,7 +113,7 @@ struct acpiphp_slot {
> >  
> >  	u8		device;		/* pci device# */
> >  
> > -	u32		sun;		/* ACPI _SUN (slot unique number) */
> > +	unsigned long long sun;		/* ACPI _SUN (slot unique number) */
> 
> Why not make it u64 if that's what ACPI says it should be?

Some 64-bit architectures typedef u64 to unsigned long, and some
to unsigned long long.

I'd prefer not to have to cast it to a (ULL) every time I want to
printk.

Thanks.

/ac

