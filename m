Return-Path: <linux-kernel-owner+w=401wt.eu-S1757128AbZFVOel@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757128AbZFVOel (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 10:34:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754341AbZFVOed
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 10:34:33 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:34156 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463AbZFVOec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 10:34:32 -0400
Date: Mon, 22 Jun 2009 08:34:31 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Alex Chiang <achiang@hp.com>
Cc: jbarnes@virtuousgeek.org, linux-arch@vger.kernel.org,
       Kyle McMartin <kyle@mcmartin.ca>, Tony Luck <tony.luck@intel.com>,
       Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
       Yoshinori Sato <ysato@users.sourceforge.jp>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeff Dike <jdike@addtoit.com>, linux-kernel@vger.kernel.org,
       Ralf Baechle <ralf@linux-mips.org>, David Howells <dhowells@redhat.com>,
       Paul Mundt <lethal@linux-sh.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Ingo Molnar <mingo@redhat.com>, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] PCI: remove pcibios_scan_all_fns()
Message-ID: <20090622143431.GT19977@parisc-linux.org>
References: <20090622140807.25509.54448.stgit@bob.kio>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090622140807.25509.54448.stgit@bob.kio>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 22, 2009 at 08:08:07AM -0600, Alex Chiang wrote:
> This was #define'd as 0 on all platforms, so let's get rid of it.
> 
> This change makes pci_scan_slot() slightly easier to read.

> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> index f1ae247..b613cad 100644
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -1056,8 +1056,7 @@ int pci_scan_slot(struct pci_bus *bus, int devfn)
>  	if (dev && !dev->is_added)	/* new device? */
>  		nr++;
>  
> -	if ((dev && dev->multifunction) ||
> -	    (!dev && pcibios_scan_all_fns(bus, devfn))) {
> +	if (dev && dev->multifunction) {
>  		for (fn = 1; fn < 8; fn++) {
>  			dev = pci_scan_single_device(bus, devfn + fn);
>  			if (dev) {

What a good idea.  I was just looking at making this more complicated
(due to the ARI capability).

I'd like to know what the KVM / Xen / ... people think about this.
I don't know if they rely on function 5 being able to show up out of
the blue.

Anyway,
Reviewed-by: Matthew Wilcox <willy@linux.intel.com>

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
