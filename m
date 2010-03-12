Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932481Ab0CLOzW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 09:55:22 -0500
Received: from indigo.declera.com ([212.116.131.21]:55344 "HELO
	indigo.declera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932114Ab0CLOzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 09:55:19 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Mar 2010 09:55:19 EST
Subject: Re: [PATCH v1 0/3] [RFC] resource, PCI: work around pci=use_crs
 conflicts
From: Yanko Kaneti <yaneti@declera.com>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Renninger <trenn@suse.de>, maciej.rutecki@gmail.com
In-Reply-To: <20100311235954.4355.23100.stgit@bob.kio>
References: <20100311235954.4355.23100.stgit@bob.kio>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Fri, 12 Mar 2010 16:49:37 +0200
Message-ID: <1268405377.3493.4.camel@d2>
Mime-Version: 1.0
X-Mailer: Evolution 2.29.92 (2.29.92-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-03-11 at 17:01 -0700, Bjorn Helgaas wrote:
> These patches are to fix this pci=use_crs regression:
> 
>     http://bugzilla.kernel.org/show_bug.cgi?id=15480
> 
> The problem is that BIOS reported a PCI host bridge window that overlaps
> system RAM.  This workaround trims the window to avoid the overlap, which
> requires information about the conflicting resource.
> 
> Yanko, I reworked these a bit, so if you have a chance to retest them
> and collect another dmesg log, I'd appreciate it.
> 
> I'm still hoping for someone to find out how Windows deals with this, but
> haven't gotten any data yet.
> 
> ---
> 
> Bjorn Helgaas (3):
>       resources: add interfaces that return conflict information
>       x86/PCI: trim _CRS windows when they conflict with previous reservations
>       PCI: for address space collisions, show conflicting resource
> 
> 
>  arch/x86/pci/acpi.c     |   48 ++++++++++++++++++++++++++++++++++-------------
>  drivers/pci/setup-res.c |   14 ++++++++------
>  include/linux/ioport.h  |    2 ++
>  kernel/resource.c       |   44 ++++++++++++++++++++++++++++++++++++-------
>  4 files changed, 82 insertions(+), 26 deletions(-)

Applied on top of latest rawhide kernel. Boots without pci=  workarounds
and works fine so far.
Dmesg attached to the bug report.

Thanks

