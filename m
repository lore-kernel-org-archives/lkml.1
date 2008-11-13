Return-Path: <linux-kernel-owner+w=401wt.eu-S1752467AbYKMDEC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752467AbYKMDEC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 22:04:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751017AbYKMDDv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 22:03:51 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:34965 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006AbYKMDDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 22:03:50 -0500
Date: Wed, 12 Nov 2008 20:03:34 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Anil kumar <anils_r@yahoo.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: dma_pool_alloc restrict < 4GB address
Message-ID: <20081113030334.GW15439@parisc-linux.org>
References: <231988.14599.qm@web32401.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <231988.14599.qm@web32401.mail.mud.yahoo.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2008 at 02:14:24PM -0800, Anil kumar wrote:
> Is there anyway to restrict the returned bus address(dma address) from dma_poll_alloc to < 4GB ?
> The function returns a dma address(of type dma_addr_t). Is there anyway I can ensure to restrict it to < 4B address.
> I guess we can do that in pci_alloc_consistent as by default it returns 32bit address. 

dma_pool_alloc (as described in the documentation ...) allocates memory
using dma_alloc_coherent().  As long as you've set the coherent mask
to 32-bit (or left it alone, since it's 32-bit by default ...), you'll
get 32-bit dma addresses back.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
