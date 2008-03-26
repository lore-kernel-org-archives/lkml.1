Return-Path: <linux-kernel-owner+w=401wt.eu-S1759308AbYCZPx2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759308AbYCZPx2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 11:53:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757953AbYCZPxA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 11:53:00 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:24143 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757725AbYCZPw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 11:52:58 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Len Brown <lenb@kernel.org>
Subject: Re: ISA -> ISA_ (Re: [GIT PATCH] ACPI patches for 2.6.25-rc6)
Date: Wed, 26 Mar 2008 09:56:53 -0600
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Ingo Molnar <mingo@elte.hu>, Corentin CHARY <corentincj@iksaif.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
References: <200803180510.47670.lenb@kernel.org> <20080326081653.GA8247@elte.hu> <200803261132.21448.lenb@kernel.org>
In-Reply-To: <200803261132.21448.lenb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803260956.55804.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 26 March 2008 09:32:20 am Len Brown wrote:
> >  /* Here we go */
> > -#define A1x_PREFIX "\\_SB.PCI0.ISA.EC0."
> > +#define A1x_PREFIX "\\_SB.PCI0.ISA_.EC0."
> 
> From an AML point of view, ISA is just as legal as "ISA_"
> The NameString paramter to Device() can be 1 to 4 characters.
> 
> So if this is correct or not depends on what the BIOS programmer
> for the Asus A1x choose to write.  Perhaps Corentin 'Iksaif' CHARY
> can confirm if the driver is working properly on that system.

I'm curious about how this works.  I disassembled the DSDT from
http://bugzilla.kernel.org/show_bug.cgi?id=4773 (I attached the disassembly
at http://bugzilla.kernel.org/attachment.cgi?id=15448&action=view), and
the _PRT contains "_SB" and "ISA" (no trailing underscores):

                Package (0x04)
                {
                    0x000DFFFF, 
                    0x00, 
                    \_SB.PCI0.ISA.LNKA, 
                    0x00
                }

But by the time we get to acpi_pci_irq_add_entry(), we've added the
underscores somewhere (see
http://bugzilla.kernel.org/attachment.cgi?id=15423&action=view):

  0000:00:0d[A] -> \_SB_.PCI0.ISA_.LNKA

I don't know where this happens, but it certainly confused me, and
it seems like it could lead to other bugs.

Bjorn
