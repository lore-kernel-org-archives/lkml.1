Return-Path: <linux-kernel-owner+w=401wt.eu-S1765760AbZDCTr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765760AbZDCTr4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 15:47:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753322AbZDCTrp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 15:47:45 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:11379 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753002AbZDCTrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 15:47:45 -0400
Subject: Re: [PATCH] Add support for turning PCIe ECRC on or off
From: Andrew Patterson <andrew.patterson@hp.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org
In-Reply-To: <87ljqikz0w.fsf@basil.nowhere.org>
References: <20090402221751.11757.36392.stgit@bob.kio>
	 <87ljqikz0w.fsf@basil.nowhere.org>
Content-Type: text/plain
Date: Fri, 03 Apr 2009 19:47:37 +0000
Message-Id: <1238788057.19984.126.camel@grinch>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-04-03 at 08:54 +0200, Andi Kleen wrote:
> Andrew Patterson <andrew.patterson@hp.com> writes:
> 
> > Add support for turning PCIe ECRC on or off
> >
> > Adds support for PCI Express transaction layer end-to-end CRC checking
> > (ECRC).  This patch will enable/disable ECRC checking by setting/clearing
> > the ECRC Check Enable and/or ECRC Generation Enable bits for devices that
> > support ECRC.
> >
> > The ECRC setting is controlled by the "pcie_ecrc=" command-line option. If
> > this option is not set or is set to 'default", the enable and generation
> > bits are left in whatever state that firmware/BIOS sets them to.  The
> > "off" setting turns them off, and the "on" option turns them on (if the
> > device supports it).
> 
> Can you please expand a little bit on your motvation? Why does the kernel
> need to set that over the firmware?

My main motivation is to turn this on for systems that support ECRC but
don't currently have it turned on.  I think that turning this on or off
provides a possible tradeoff of increased data integrity over some sort
of performance penalty (hardware no longer has to calculate ECRC data,
and packet length is smaller due to lack of ECRC fields).

>  And why does it need to be a boot
> parameter vs some sysfs file?

It could be either.  I thought about doing both actually, but decided it
probably wasn't worth it. One possible advantage of doing sysfs is that
you could turn it on or off selectively for each root bridge. The
advantage of doing it at boot is that we could turn it off/on very early
for balky hardware.

> 
> -Andi
> 
-- 
Andrew Patterson
Hewlett-Packard

