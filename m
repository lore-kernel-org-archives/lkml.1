Return-Path: <linux-kernel-owner+w=401wt.eu-S1752729AbZHMDdJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729AbZHMDdJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 23:33:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752657AbZHMDdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 23:33:09 -0400
Received: from gate.crashing.org ([63.228.1.57]:42580 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752663AbZHMDdI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 23:33:08 -0400
Subject: Re: linux-next: pci tree build warning
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Tiago Vignatti <tiago.vignatti@nokia.com>,
       Dave Airlie <airlied@redhat.com>
In-Reply-To: <20090813124732.f29fd5c3.sfr@canb.auug.org.au>
References: <20090813124732.f29fd5c3.sfr@canb.auug.org.au>
Content-Type: text/plain
Date: Thu, 13 Aug 2009 13:32:40 +1000
Message-Id: <1250134360.3587.77.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-13 at 12:47 +1000, Stephen Rothwell wrote:
> Hi Jesse,
> 
> Today's linux-next build (x86_64 allmodconfig) produced these warnings:
> 
> drivers/gpu/vga/vgaarb.c: In function 'vga_arb_write':
> drivers/gpu/vga/vgaarb.c:834: warning: cast from pointer to integer of different size
> drivers/gpu/vga/vgaarb.c:870: warning: cast from pointer to integer of different size
> drivers/gpu/vga/vgaarb.c:920: warning: cast from pointer to integer of different size
> drivers/gpu/vga/vgaarb.c:963: warning: cast from pointer to integer of different size
> drivers/gpu/vga/vgaarb.c:1017: warning: cast from pointer to integer of different size
> 
> Introduced by commit a49c9c1b728fa8f50816d96a0f135e15a359e448 ("PCI/GPU:
> implement VGA arbitration on Linux").

Right, somebody weirdly decided to cast pointers to int just to printk
them with %X :-) I hope it wasn't me ... 

Just remove the casts and use %p instead.

Cheers,
Ben.


