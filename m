Return-Path: <linux-kernel-owner+w=401wt.eu-S1754056Ab0AGFvr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056Ab0AGFvr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 00:51:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751520Ab0AGFvp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 00:51:45 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:29882 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006Ab0AGFvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 00:51:44 -0500
Subject: Re: BAR 0: can't allocate resource
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Alex Brooks <a.brooks@marathon-robotics.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <201001071209.01975.a.brooks@marathon-robotics.com>
References: <201001061305.31635.a.brooks@marathon-robotics.com>
	 <201001061316.21744.a.brooks@marathon-robotics.com>
	 <201001061319.54436.bjorn.helgaas@hp.com>
	 <201001071209.01975.a.brooks@marathon-robotics.com>
Content-Type: text/plain
Date: Wed, 06 Jan 2010 22:46:16 -0700
Message-Id: <1262843176.27608.2.camel@dc7800.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-07 at 12:09 +1100, Alex Brooks wrote:
> > You mentioned two messages.  Here's the first:
> >   PCI: BIOS Bug: MCFG area at e0000000 is not reserved in ACPI motherboard
> > resources PCI: Not using MMCONFIG.
> >
> > and the second:
> >   PCI: Cannot allocate resource region 0 of device 0000:01:04.0
> >   PCI: Error while updating region 0000:01:04.0/0 (feb00002 != 00000000)
> >
> > The "Error while updating region" message is because we wrote something
> > to a BAR, read it back, and they didn't match.  I suppose this could be
> > some kind of config space problem related to the fact that we're not
> > using MMCONFIG.
> >
> > Can you try removing the MCFG reservation check, so we do try to use
> > MMCONFIG?  If you do this on a current kernel, we'll also get a little
> > more debug output about the subsequent resource allocation failure.
> 
> I did this on my 2.6.26 kernel (is this current enough or would a later kernel 
> be better?) and attached the dmesg output.

Looks like you got the same errors when accessing config space as
before.

I was hoping for a kernel directly from Linus' git repo, e.g.,
2.6.33-rc3; I don't think the debug output I'm thinking about went in
until after 2.6.32 was released.

Bjorn


