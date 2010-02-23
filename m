Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753043Ab0BWSGd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 13:06:33 -0500
Received: from outbound-mail-313.bluehost.com ([67.222.54.6]:52079 "HELO
	outboundproxy6.bluehost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1752260Ab0BWSGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 13:06:31 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=dvyBSPyQxC5nv3ETcaKLkBYKXVcDs6PG+F0wZCgC/9w1AG78W76EIoRcf/T9LVgQiyqyrFGfqKzvJ2lSDFeGaXEqJNBG5ixWVfy3JzvYOonWbH7ymzgh6df+xqvGhqqA;
Date: Tue, 23 Feb 2010 10:06:26 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Tony Luck <tony.luck@intel.com>,
       linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org,
       Peter Haight <peterh@sapros.com>, Gary Hade <garyhade@us.ibm.com>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       linux-am33-list@redhat.com, Yinghai Lu <yinghai@kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH v5 0/5] PCI: try "pci=use_crs" again
Message-ID: <20100223100626.693b50b6@jbarnes-piketon>
In-Reply-To: <20100223172355.17242.55927.stgit@bob.kio>
References: <20100223172355.17242.55927.stgit@bob.kio>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Feb 2010 10:24:15 -0700
Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:

> Historically, Linux has assumed a single PCI host bridge, with that
> bridge claiming all the address space left after RAM and legacy
> devices are taken out.
> 
> If the system contains multiple host bridges, we can no longer
> operate under that assumption.  We have to know what parts of the
> address space are claimed by each bridge so that when we assign
> resources to a PCI device, we take them from a range claimed by the
> upstream host bridge.
> 
> On x86 and ia64, we use ACPI to enumerate all the PCI host bridges in
> the system, and part of the host bridge description is the
> "_CRS" (current resource settings" property, which lists the address
> space used by the bridge.  On x86, we currently ignore most of the
> _CRS information.  This patch series changes this, so we will use
> _CRS to learn about the host bridge windows.
> 
> Since most x86 machines with multiple host bridges are relatively
> new, this series only turns this on for machines with BIOS dates of
> 2008 or newer.
> 
> Changes from v4 to v5:
>     - Add EXPORT_SYMBOL_GPL(pci_bus_resource_n) for module builds.

Thanks, it built this time.  Pushed to my linux-next branch.

-- 
Jesse Barnes, Intel Open Source Technology Center
