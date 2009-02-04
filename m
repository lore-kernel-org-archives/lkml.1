Return-Path: <linux-kernel-owner+w=401wt.eu-S1756652AbZBDPom@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756652AbZBDPom (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 10:44:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752105AbZBDPoc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 10:44:32 -0500
Received: from vervifontaine.sonytel.be ([80.88.33.193]:58051 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752006AbZBDPoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 10:44:32 -0500
Date: Wed, 4 Feb 2009 16:44:30 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Frans Pop <elendil@planet.nl>
cc: Frank Seidel <fseidel@suse.de>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, linux-acpi@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, len.brown@intel.com,
       shaohuhua.li@intel.com, kristen.c.accardi@intel.com, frank@f-seidel.de
Subject: Re: [PATCH] ACPI: add missing KERN_* constants to printks
In-Reply-To: <200902041628.03675.elendil@planet.nl>
Message-ID: <alpine.LRH.2.00.0902041642450.7690@vixen.sonytel.be>
References: <4989A784.3030604@suse.de> <200902041628.03675.elendil@planet.nl>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Feb 2009, Frans Pop wrote:
> Frank Seidel wrote:
> > +++ b/drivers/acpi/pci_link.c
> > @@ -593,7 +593,7 @@ static int acpi_pci_link_allocate(struct
> >                 return -ENODEV;
> >         } else {
> >                 acpi_irq_penalty[link->irq.active] += PIRQ_PENALTY_PCI_USING;
> > -               printk(PREFIX "%s [%s] enabled at IRQ %d\n",
> > +               printk(KERN_WARNING PREFIX "%s [%s] enabled at IRQ %d\n",
> >                 acpi_device_name(link->device),
> >                 acpi_device_bid(link->device), link->irq.active);
> >         }
> > @@ -751,21 +751,21 @@ static int acpi_pci_link_add(struct acpi
> >         acpi_device_bid(device));
> >         for (i = 0; i < link->irq.possible_count; i++) {
> >                 if (link->irq.active == link->irq.possible[i]) {
> > -                       printk(" *%d", link->irq.possible[i]);
> > +                       printk(KERN_INFO " *%d", link->irq.possible[i]);
> >                         found = 1;
> >                 } else
> > -                       printk(" %d", link->irq.possible[i]);
> > +                       printk(KERN_INFO " %d", link->irq.possible[i]);
> >         }
> > 
> > -       printk(")");
> > +       printk(KERN_INFO ")");
> > 
> >         if (!found)
> > -               printk(" *%d", link->irq.active);
> > +               printk(KERN_INFO " *%d", link->irq.active);
> > 
> 
> This patch looks broken to me, at least for some of your changes.
> For example, in the bit quoted above all printks together make up
> *one single* message, which means that only the _first_ of the
> printks should have the KERN_* prefix. printks that are continuations
> should not have the prefix.

Actually they should, but the right prefix :-)

Quoting include/linux/kernel.h:

| /*
|  * Annotation for a "continued" line of log printout (only done after a
|  * line that had no enclosing \n). Only to be used by core/arch code
|  * during early bootup (a continued line is not SMP-safe otherwise).
|  */
| #define KERN_CONT       ""

Please also consider the note about SMP-safeness.

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
