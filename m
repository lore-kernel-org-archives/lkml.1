Return-Path: <linux-kernel-owner+w=401wt.eu-S1755337AbYJZSej@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337AbYJZSej (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 14:34:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752652AbYJZSea
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 14:34:30 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:36856 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614AbYJZSea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 14:34:30 -0400
Date: Sun, 26 Oct 2008 12:34:13 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Yu Zhao <yu.zhao@uniscape.net>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
       greg@kroah.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       stable@kernel.org, Rakib Mullick <rakib.mullick@gmail.com>
Subject: Re: [PATCH] pci: Fixing drivers/pci/search.c compilation warning.
Message-ID: <20081026183412.GX26094@parisc-linux.org>
References: <b9df5fa10809280816u23ef3021k7eee287a237b72ae@mail.gmail.com> <20080928163211.GR27204@parisc-linux.org> <20081021011308.GA3889@parisc-linux.org> <490467CD.3000402@uniscape.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <490467CD.3000402@uniscape.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 26, 2008 at 08:51:25PM +0800, Yu Zhao wrote:
> This reminds me of other problems of PCI search functions.
> 
> The 'dev_start' is passed to bus_find_device(), and its 'knode_bus' 
> reference count is decreased by klist_iter_init_node() in that function. 
> The problem is the reference count may be already decrease to 0 because 
> the PCI device 'from' is hot-plugged off (e.g., pci_remove_bus) when the 
> search goes. A warning is fired when klist_iter_init_node() detects the 
> reference count becomes 0.
> 
> Some code uses pci_find_device() in a way that is not safe with the 
> hotplug, because a device may be destroyed after bus_find_device() 
> returns it and before it's held by pci_dev_get() in the next round. 
> Following is an example from a random grep:

Yes, that's why pci_find_device() is deprecated.  But it doesn't also
need to be buggy ;-)

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
