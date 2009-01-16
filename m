Return-Path: <linux-kernel-owner+w=401wt.eu-S936545AbZAPShW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936545AbZAPShW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 13:37:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757781AbZAPSg7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 13:36:59 -0500
Received: from outbound-mail-308.bluehost.com ([67.222.53.254]:58813 "HELO
	outbound-mail-308.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751546AbZAPSg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 13:36:58 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=oDu8lyPkDFF8dMIAJ/9WzS0t/umNAhkqR4tiG2sPSYlH4/SVDiWy6itY+0E6roXjrCPRCK7s0i6lhXGpeJtmS13l04zsorPPimdkVuYX5KzKBfRqAyC7ollEP56nXldI;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: [PATCH] PCI/MSI: bugfix/utilize for msi_capability_init()
Date: Fri, 16 Jan 2009 10:32:56 -0800
User-Agent: KMail/1.9.10
Cc: Jike Song <albcamus@gmail.com>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <4951F258.6040601@jp.fujitsu.com> <df9815e70812240101q23f6d59fj4121b19563a77d47@mail.gmail.com> <49532592.9050202@jp.fujitsu.com>
In-Reply-To: <49532592.9050202@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901161032.56466.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, December 24, 2008 10:17 pm Hidetoshi Seto wrote:
> Jike Song wrote:
> > On Wed, Dec 24, 2008 at 4:27 PM, Hidetoshi Seto
> >
> > <seto.hidetoshi@jp.fujitsu.com> wrote:
> >> This patch fix a following bug and does a cleanup.
> >>
> >> bug:
> >>        commit 5993760f7fc75b77e4701f1e56dc84c0d6cf18d5
> >>        had a wrong change (since is_64 is boolean[0|1]):
> >>
> >> -               pci_write_config_dword(dev,
> >> -                       msi_mask_bits_reg(pos,
> >> is_64bit_address(control)), -                       maskbits);
> >> +               pci_write_config_dword(dev, entry->msi_attrib.is_64,
> >> maskbits);
> >
> > Yes, really a nasty bug. I'm feeling guilty...
> > Should this fix hit 2.6.28 release?  I CCed Jesse for his point.
>
> Unfortunately we failed to take this fix into Santa's bag...
>
> Note that this bug affects mask condition after calling pci_enable_msi()
> for devices with MSI capability with (optional) per-vector masking support.
> Devices with MSI-X or MSI without masking support are safe.
> Once unmask/mask_msi_irq() is called, the condition should be fixed.
>
> And the wrong pci_write_config_dword() will have no effects because
> target registers (fields in header, such as Vendor ID) are read-only.

Sorry, finally picked this one up.  I've added a "cc: stable" on it as well, 
so when I push it to Linus it can go into 2.6.28.x.

In the future, please cc me on patches that are ready for upstream too, makes 
it easier for me to track things.

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
