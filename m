Return-Path: <linux-kernel-owner+w=401wt.eu-S1753506AbYKLNOl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506AbYKLNOl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 08:14:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752034AbYKLNOb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 08:14:31 -0500
Received: from mail.ukfsn.org ([77.75.108.10]:55074 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751984AbYKLNOa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 08:14:30 -0500
Date: Wed, 12 Nov 2008 13:14:27 +0000
From: Nick Warne <nick@ukfsn.org>
To: linux-kernel@vger.kernel.org, mjg@redhat.com
Subject: Re: [PATCH] Make Dell keyboard repeat quirk apply to a wider range
 of hardware
Message-ID: <20081112131427.1bbc2a7c@palantir.linicks.net>
In-Reply-To: <20081111074702.75e71055@sauron.linicks.net>
References: <20081111074702.75e71055@sauron.linicks.net>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Nov 2008 07:47:02 +0000
Nick Warne <nick@ukfsn.org> wrote:

> 
> > Dell laptops fail to send key up events for several of their
> > special keys. There's an existing quirk in the kernel to handle
> > this, but it's limited to the Latitude range. This patch extends it
> > to cover all portable Dells.
> > 
> > Signed-off-by: Matthew Garrett <mjg@redhat.com>
> > 
> > ---
> > diff --git a/drivers/input/keyboard/atkbd.c
> > b/drivers/input/keyboard/atkbd.c index b1ce10f..e32c24d 100644
> > --- a/drivers/input/keyboard/atkbd.c
> > +++ b/drivers/input/keyboard/atkbd.c
> > @@ -834,10 +834,10 @@ static void atkbd_disconnect(struct serio
> > *serio) }
> >  
> >  /*
> > - * Most special keys (Fn+F?) on Dell Latitudes do not generate
> > release
> > + * Most special keys (Fn+F?) on Dell laptops do not generate
> > release
> >   * events so we have to do it ourselves.
> >   */
> > -static void atkbd_latitude_keymap_fixup(struct atkbd *atkbd)
> > +static void atkbd_dell_laptop_keymap_fixup(struct atkbd *atkbd)
> >  {
> >  	const unsigned int forced_release_keys[] = {
> >  		0x85, 0x86, 0x87, 0x88, 0x89, 0x8a, 0x8b, 0x8f,
> > 0x93, @@ -1461,13 +1461,13 @@ static int __init
> > atkbd_setup_fixup(const struct dmi_system_id *id) 
> >  static struct dmi_system_id atkbd_dmi_quirk_table[] __initdata = {
> >  	{
> > -		.ident = "Dell Latitude series",
> > +		.ident = "Dell Laptop",
> >  		.matches = {
> >  			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
> > -			DMI_MATCH(DMI_PRODUCT_NAME, "Latitude"),
> > +			DMI_MATCH(DMI_CHASSIS_TYPE, "8"), /*
> > Portable */ },
> >  		.callback = atkbd_setup_fixup,
> > -		.driver_data = atkbd_latitude_keymap_fixup,
> > +		.driver_data = atkbd_dell_laptop_keymap_fixup,
> >  	},
> >  	{
> >  		.ident = "HP 2133",
> 
> This issue has hit a lot of Ubuntu Dell uses (like myself), and the
> patch indeed fixes it up - but it appears not all Dell machines are
> alike.  One user has reported it doesn't work, and his investigation
> reveals dmicode output shows:
> 
> Vendor: Dell Computer Corporation
> 
> So I guess this isn't totally fixed yet.  As to what the vendor output
> is al all these machines, I don't know, but I guess now it could be
> any permatation of Dell Inc., Dell Computer Corp. etc.
> 
> Ref. Ubuntu bug report thread:
> 
> https://bugs.launchpad.net/ubuntu/+source/acpid/+bug/285323/comments/88
> 
> Nick

OK, I asked for help on this - so far it seems either Dell Inc. or Dell
Computer Corporation, so I guess this patch needs a || somewhere.


1814-BIOS Information
1831: Vendor: Dell Inc.
1850- Version: A17
2774- Manufacturer: Dell Inc.
2799: Product Name: MM061
2847- Version: Not Specified
--
3064- Manufacturer: Dell Inc.
3089: Product Name: 0KD882
3111- Version: 



2675-BIOS Information
2692: Vendor: Dell Inc.
2711- Version: A02
3546- Manufacturer: Dell Inc.
3571: Product Name: Latitude D620
3619- Version: Not Specified
--
3836- Manufacturer: Dell Inc.
3861: Product Name: 0JK187
3883- Version:



2132-BIOS Information
2149: Vendor: Dell Inc.
2168- Version: A13
3093- Manufacturer: Dell Inc.
3118: Product Name: Inspiron 1525
3166- Version: Not Specified
--
3383- Manufacturer: Dell Inc.
3408: Product Name: 0U990C
3430- Version:


841-BIOS Information
858: Vendor: Dell Computer Corporation
893- Version: A11
1782- Manufacturer: Dell Computer Corporation
1823: Product Name: Inspiron 8200
1871- Version: Not Specified
--
2050- Manufacturer: Dell Computer Corporation
2091: Product Name: Inspiron 8200
2132- Version: Not Specified



617-BIOS Information
634: Vendor: Dell Inc.
653- Version: A00
1140- Manufacturer: Dell Inc.
1165: Product Name: Inspiron 910
1193- Version: A00
--
1412- Manufacturer: Dell Inc.
1437: Product Name: CN0J14
1459- Version: A00


1852-BIOS Information
1869: Vendor: Dell Inc.
1888- Version: A09
2812- Manufacturer: Dell Inc.
2837: Product Name: MP061
2885- Version: Not Specified
--
3102- Manufacturer: Dell Inc.
3127: Product Name: 0YD479
3149- Version:


372-BIOS Information
389: Vendor: Dell Computer Corporation
424- Version: A34
1278- Manufacturer: Dell Computer Corporation
1319: Product Name: Inspiron 5150
1367- Version: Not Specified
--
1546- Manufacturer: Dell Computer Corporation
1587: Product Name: 0W0940
1609- Version:


094-BIOS Information
2111: Vendor: Dell Inc.
2130- Version: A09
3055- Manufacturer: Dell Inc.
3080: Product Name: Inspiron 1720
3128- Version: Not Specified
--
3345- Manufacturer: Dell Inc.
3370: Product Name:
3392- Version:
-- 
Free Software Foundation Associate Member 5508
