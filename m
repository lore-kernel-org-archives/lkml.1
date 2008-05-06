Return-Path: <linux-kernel-owner+w=401wt.eu-S1765175AbYEFTI0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765175AbYEFTI0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 15:08:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755023AbYEFTIR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 15:08:17 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:26623 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074AbYEFTIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 15:08:15 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Rene Herman <rene.herman@keyaccess.nl>
Subject: Re: [PATCH 3/3] PNP: add AD1815 and AD1816 quirks
Date: Tue, 6 May 2008 13:08:14 -0600
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Uwe Bugla <uwe.bugla@gmx.de>, Takashi Iwai <tiwai@suse.de>,
       Len Brown <len.brown@intel.com>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
References: <481FAC37.6090703@keyaccess.nl> <481FAD12.3030409@keyaccess.nl> <481FAF83.5090305@keyaccess.nl>
In-Reply-To: <481FAF83.5090305@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805061308.14673.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 May 2008 07:08:19 pm Rene Herman wrote:
> The AD181x chip doesn't support an IRQ-less MPU401 option but works
> fine without one. This adds (priority: functional) IRQ-less options
> for each port option to help systems with few available IRQs.
> 
> The AD1815 quirk can't use pnp_register_irq_resource() due to doubly
> penalizing the IRQ. Also, while not a practical issue due to no IRQ
> option being present for the dependents, this needs to add in front,
> not back.
> 
> Doesn't use pnp_register_port_resource() for symetry with above.
> 
> This does not delete the AD1815 independent option even though it
> should be empty after the IRQ transfer due to AD1816 coming with an
> empty but still present independent option by default.
> 
> Was tested on AD1815 and AD1816. The ALSA driver also support the
> AZT2002 ID for MPU401 but this doesn't as I was unable to test it.
> 
> Signed-off-by: Rene Herman <rene.herman@gmail.com>

I'm not opposed to this in principle, but I don't understand
it well enough to really have an informed opinion.

IIRC, we give up some seldom-used functionality when running
the MPU401 without an IRQ.  Does the driver mention the fact
that there's something it can't do because we don't have an IRQ?
The user might like to know in case he needs that functionality
and wants to fiddle with other devices to free up IRQs.

I'm vaguely uncomfortable because this quirk isn't really working
around a hardware/firmware issue; it's stepping around the fact
that Linux doesn't know how to allocate IRQs between ISA and PCI.
Does anybody know how Windows handles this?  If Windows can do it
without user intervention, maybe we can too.

If we continue down the quirk path, would you mind using dev_info()
instead of plain printk()?

Bjorn
