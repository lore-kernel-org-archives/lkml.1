Return-Path: <linux-kernel-owner+w=401wt.eu-S1753325AbZF2MUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325AbZF2MUs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 08:20:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751489AbZF2MUi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 08:20:38 -0400
Received: from mx2.redhat.com ([66.187.237.31]:53683 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751226AbZF2MUh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 08:20:37 -0400
Date: Mon, 29 Jun 2009 15:20:04 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gregory Haskins <ghaskins@novell.com>, avi@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mtosatti@redhat.com,
       paulmck@linux.vnet.ibm.com, markmc@redhat.com
Subject: Re: [PATCHv3 4/4] kvm: remove in_range from io devices
Message-ID: <20090629122004.GA21640@redhat.com>
References: <cover.1246276816.git.mst@redhat.com> <20090629120919.GE21273@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090629120919.GE21273@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 29, 2009 at 03:09:19PM +0300, Michael S. Tsirkin wrote:
> This changes bus accesses to use high-level kvm_io_bus_read/kvm_io_bus_write
> functions. in_range now becomes unused so it is removed from device ops in
> favor of read/write callbacks performing range checks internally.
> 
> This allows aliasing (mostly for in-kernel virtio), as well as better error
> handling by making it possible to pass errors up to userspace.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

Ugh, forgot this trivial typo fix. Sorry.

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 790bd55..82e76da 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2276,7 +2276,7 @@ static int vcpu_mmio_read(struct kvm_vcpu *vcpu, gpa_t addr, int len, void *v)
 	    !kvm_iodevice_read(&vcpu->arch.apic->dev, addr, len, v))
 		return 0;
 
-	return kvm_io_bus_read(vcpu->kvm, &vcpu->kvm->mmio_bus, addr, len, v);
+	return kvm_io_bus_read(&vcpu->kvm->mmio_bus, addr, len, v);
 }
 
 static int kvm_read_guest_virt(gva_t addr, void *val, unsigned int bytes,
