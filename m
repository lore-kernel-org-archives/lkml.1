Return-Path: <linux-kernel-owner+w=401wt.eu-S1757475AbZBZQyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757475AbZBZQyS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 11:54:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755532AbZBZQyA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 11:54:00 -0500
Received: from vervifontaine.sonytel.be ([80.88.33.193]:57092 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755212AbZBZQx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 11:53:59 -0500
Date: Thu, 26 Feb 2009 17:53:56 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Arnd Bergmann <arnd@arndb.de>
cc: Ira Snyder <iws@ovro.caltech.edu>, linuxppc-dev@ozlabs.org,
       netdev@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       linux-kernel@vger.kernel.org, Jan-Bernd Themann <THEMANN@de.ibm.com>
Subject: Re: [RFC v2] virtio: add virtio-over-PCI driver
In-Reply-To: <200902261715.28440.arnd@arndb.de>
Message-ID: <alpine.LRH.2.00.0902261752310.29190@vixen.sonytel.be>
References: <20090224000002.GA578@ovro.caltech.edu> <200902261715.28440.arnd@arndb.de>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Feb 2009, Arnd Bergmann wrote:
> On Tuesday 24 February 2009, Ira Snyder wrote:
> > +/* Virtio-over-PCI descriptors: 12 bytes. These can chain together via "next" */
> > +struct vop_desc {
> > +	/* Address (host physical) */
> > +	__le32 addr;
               ^^^^
Only 32-bit? Is this future-proof?

> > +	/* Length (bytes) */
> > +	__le32 len;
> > +	/* Flags */
> > +	__le16 flags;
> > +	/* Chaining for descriptors */
> > +	__le16 next;
> > +} __attribute__((packed));
> 
> I would drop the "packed" attribute in the structure definitions.
> It would imply that only byte accesses are allowed on these
> data structures, because the attribute invalidates any assumptions
> about alignment. None of your structures require padding, so
> the attribute does not have any positive effect either.
> 
> > +/* MPC8349EMDS specific get_immrbase() */
> > +#include <sysdev/fsl_soc.h>
> 
> Do you really need get_immrbase? I would expect that you can find
> all the registers you need in the device tree, or exported from
> other low-level drivers per subsystem.
> 
> immrbase is a concept from the time before our device trees.
> 
> > +/*
> > + * These are internal use only versions of the structures that
> > + * are exported over PCI by this driver
> > + *
> > + * They are used internally to keep track of the PowerPC queues so that
> > + * we don't have to keep flipping endianness all the time
> > + */
> > +struct vop_loc_desc {
> > +	u32 addr;
        ^^^
Same here.

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis · BIC GEBABEBB · IBAN BE41293037680010
