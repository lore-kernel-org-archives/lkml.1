Return-Path: <linux-kernel-owner+w=401wt.eu-S1762810AbYFDXGl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762810AbYFDXGl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 19:06:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753883AbYFDXGc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 19:06:32 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:43967 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753280AbYFDXGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 19:06:31 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Rene Herman <rene.herman@keyaccess.nl>
Subject: Re: [patch 15/15] PNP: convert resource options to single linked list
Date: Wed, 4 Jun 2008 17:06:33 -0600
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Adam Belay <ambx1@neo.rr.com>,
       Adam M Belay <abelay@mit.edu>, Li Shaohua <shaohua.li@intel.com>,
       Matthieu Castet <castet.matthieu@free.fr>,
       Thomas Renninger <trenn@suse.de>, Jaroslav Kysela <perex@perex.cz>,
       Andrew Morton <akpm@linux-foundation.org>, Takashi Iwai <tiwai@suse.de>
References: <20080530224853.976744229@ldl.fc.hp.com> <200806041450.10576.bjorn.helgaas@hp.com> <484717A6.4060403@keyaccess.nl>
In-Reply-To: <484717A6.4060403@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806041706.35385.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 June 2008 04:31:02 pm Rene Herman wrote:
> On 04-06-08 22:50, Bjorn Helgaas wrote:
> 
> > On Wednesday 04 June 2008 05:48:27 am Rene Herman wrote:
> >> On 04-06-08 01:52, Rene Herman wrote:
> > 
> >> ADS7181 in fact might as well delete the IRQ from the dependents and add
> >> "irq 2/9,10,11 High-Edge Optinal" in front as an independent same as 
> >> ADS7151. That way, all the cloning can go.
> > 
> > We currently clone for AZT0002 as well as ADS7181.  Can we do the
> > same for both?  It would be nice to get rid of the cloning code
> > if we can.
> 
> Yes. AZT0002 (the MPU401 on an AZT2320 chip) is the exact same as 
> ADS7181 (the MPU401 on an AD1816 chip).
> 
> IORESOURCE_IRQ_OPTIONAL clears the path for doing things better. I see 
> its dependent 2 can then just go entirely in fact.
> 
> Hardware says:
> 
> Dependent: 00 - Priority preferred
>    irq 2/9 High-Edge
>    port 0x330-0x330, align 0xf, size 0x2, 16-bit address decoding
> Dependent: 01 - Priority acceptable
>    irq 2/9 High-Edge
>    port 0x300-0x330, align 0xf, size 0x2, 16-bit address decoding
> Dependent: 02 - Priority functional
>    irq 2/9,10,11 High-Edge
>    port 0x300-0x330, align 0xf, size 0x2, 16-bit address decoding
> 
> We want it to end up as:
> 
> irq 2/9,10,11 High-Edge (Optional)
> Dependent: 00 - Priority preferred
>    port 0x330-0x330, align 0xf, size 0x2, 16-bit address decoding
> Dependent: 01 - Priority acceptable
>    port 0x300-0x330, align 0xf, size 0x2, 16-bit address decoding
> 
> So walk dependents deleting IRQs, except last dependent IRQ which is 
> cloned into a new independent (inserted in front would be best for 
> ISAPnP since the spec does recommend this) while making it optional and 
> then just delete the last dependent completely (it would be same as the 
> previous dependent after all).

That would probably simplify things a bit.  Although in the general
case, I suppose we'd want to make sure the options we delete are
a subset of the independent one we add.  Will look at this more
tomorrow.

Bjorn
