Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933066Ab0BPQip (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 11:38:45 -0500
Received: from outbound-mail-313.bluehost.com ([67.222.54.6]:57228 "HELO
	outboundproxy6.bluehost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S932458Ab0BPQin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 11:38:43 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=T1rfzvHJLZoK4JdXqtocKXm/XOb1Euhv9v97z7Dm9ujxt6EOZOLIq9AtegZ5SrebKG7nSO5v+AZn3bAc4MP/BaFBU6xRcuKZdSgUIDcZpGTLVqy2rGrsEF7hDb7a6dpG;
Date: Tue, 16 Feb 2010 08:36:51 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       David Miller <davem@davemloft.net>
Subject: Re: linux-next: build failure after merge final merge
Message-ID: <20100216083651.40ed48eb@jbarnes-piketon>
In-Reply-To: <20100216183650.e82c0f8e.sfr@canb.auug.org.au>
References: <20100216183650.e82c0f8e.sfr@canb.auug.org.au>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Feb 2010 18:36:50 +1100
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Jesse,
> 
> After merging, today's linux-next build (sparc64 defconfig) failed
> like this:
> 
> arch/sparc/kernel/pci.c: In function 'pci_cfg_fake_ranges':
> arch/sparc/kernel/pci.c:404: error: 'struct pci_bus' has no member
> named 'resource' arch/sparc/kernel/pci.c:419: error: 'struct pci_bus'
> has no member named 'resource' arch/sparc/kernel/pci.c:450: error:
> 'struct pci_bus' has no member named 'resource'
> arch/sparc/kernel/pci.c: In function 'apb_fake_ranges':
> arch/sparc/kernel/pci.c:473: error: 'struct pci_bus' has no member
> named 'resource' arch/sparc/kernel/pci.c:481: error: 'struct pci_bus'
> has no member named 'resource' arch/sparc/kernel/pci.c: In function
> 'of_scan_pci_bridge': arch/sparc/kernel/pci.c:539: error: 'struct
> pci_bus' has no member named 'resource' arch/sparc/kernel/pci.c:558:
> error: 'struct pci_bus' has no member named 'resource'
> arch/sparc/kernel/pci.c:571: error: 'struct pci_bus' has no member
> named 'resource' arch/sparc/kernel/pci.c: In function
> 'pci_scan_one_pbm': arch/sparc/kernel/pci.c:693: error: 'struct
> pci_bus' has no member named 'resource' arch/sparc/kernel/pci.c:694:
> error: 'struct pci_bus' has no member named 'resource'
> arch/sparc/kernel/pci.c: In function 'pcibios_fixup_bus':
> arch/sparc/kernel/pci.c:710: error: 'struct pci_bus' has no member
> named 'resource' arch/sparc/kernel/pci.c:711: error: 'struct pci_bus'
> has no member named 'resource'
> 
> Cause by commit 94a8887c501b22a2818ee58197864e9eab983510 ("PCI:
> replace bus resource table with a list") from the pci tree.  I don't
> know why I didn't notice this failure yesterday.
> 
> I have reverted that commit and the following 4 commits from the pci
> tree for today:
> 
> 6b673390ae99fbaeeafc40a6e42ba97e1beada0b "x86/PCI: use host bridge
> _CRS info by default on 2008 and newer machines"
> 6776104e550aa6600549e204865cb3d4ed29e04e "PCI: make disabled window
> 	printk style match the enabled ones"
> a0266ed60a7ac8ce5c97d860cd927ba542325cb4 "PCI: break out
> 	primary/secondary/subordinate for readability"
> 0c2a8aaaba0d1a16a468cf48ba2fec6139d20a66 "PCI: reference bridge window
> 	resources explicitly"
> 
> Jesse, can you please remove these commits from the pci tree until the
> above problem is fixed.
> 
> OK, I just checked the build results for last night
> (http://kisskb.ellerman.id.au/kisskb/head/2579/) and there are quite
> a few more (alpha, some arm, parisc and more ...) ... please fix them
> up as well.  Try something like:
> 
> git grep -l -w resource $(git grep -l -w 'struct pci_bus')
> 
> for a starting list of files to check.


Arg I thought we had fixed this one; maybe I applied an old patchset...
Bjorn?

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
