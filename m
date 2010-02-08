Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676Ab0BHXJq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 18:09:46 -0500
Received: from outbound-mail-313.bluehost.com ([67.222.54.6]:50078 "HELO
	outbound-mail-313.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751764Ab0BHXJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 18:09:42 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=GcWmI3QVafOGCrG2nkoWgyZDOtVXZqdJ2W0HsjJs+k64lQmzCl1Vd6FIZ9NKBme5c5nDbjoc3EqUoL00OgfMYPuBqX1j+zYtbrbzO40Pw4vIzOAo/snU8/sxGsO1bldY;
Date: Mon, 8 Feb 2010 15:08:34 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Tony Luck <tony.luck@intel.com>,
       linux-pci@vger.kernel.org, Peter Haight <peterh@sapros.com>,
       Gary Hade <garyhade@us.ibm.com>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH v2 0/7] PCI: try "pci=use_crs" again
Message-ID: <20100208150834.17756314@jbarnes-piketon>
In-Reply-To: <20100208224236.27954.4358.stgit@bob.kio>
References: <20100208224236.27954.4358.stgit@bob.kio>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 08 Feb 2010 15:44:18 -0700
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
> We use ACPI to enumerate all the PCI host bridges in the system, and
> part of the host bridge description is the "_CRS" (current resource
> settings" property, which lists the address space used by the
> bridge.  On x86, we currently ignore most of the _CRS information.
> This patch series changes this, so we will use _CRS to learn about
> the host bridge windows.
> 
> Since most x86 machines with multiple host bridges are relatively
> new, this series only turns this on for machines with BIOS dates of
> 2010 or newer and for a few machines we know to require it.
> 
> These apply on be6e9f7853e.  I added an initial patch to clean up the
> formatting of the disabled window printk.
> 
> Changes since v1:
>     - rebase to be6e9f7853e
>     - add patch to clean up "disabled window" printk
>     - add bugzilla reference comment in use_crs DMI quirk

A 2010 default is probably too conservative, but we can always add a
whitelist or change the default later.  Applied the series to my
linux-next branch, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
