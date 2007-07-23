Return-Path: <linux-kernel-owner+w=401wt.eu-S934327AbXGWTUX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934327AbXGWTUX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 15:20:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764689AbXGWTUH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 15:20:07 -0400
Received: from nz-out-0506.google.com ([64.233.162.227]:20139 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764955AbXGWTUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 15:20:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=YPCH1mi47MIB4g/+cxEKvnNLjk0KmjuH7uOMcDhDgvdw+8/uEh9BcnARZZU8OR2RZVWXYdiU5nO5bfVQD2ET84JkPLOvGBOMGvGtAmM5560sn62Ip6tPj7eHk1HYxA8p9z4JvZ2xgfbtZig8HlpuGLE3wSZLtFoxV6JrDKib4r4=
Message-ID: <86802c440707231220y75ee8e91le76913409a109ada@mail.gmail.com>
Date: Mon, 23 Jul 2007 12:20:02 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andi Kleen" <ak@suse.de>
Subject: Re: [PATCH] x86_64: use apic core id bits for core nums
Cc: "Andrew Morton" <akpm@linux-foundation.org>, joachim.deguara@amd.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <200707211022.47859.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <86802c440707210056s745d44f1jc6437064741299eb@mail.gmail.com>
	 <200707211022.47859.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/21/07, Andi Kleen <ak@suse.de> wrote:
> On Saturday 21 July 2007 09:56:15 Yinghai Lu wrote:
> > please check my version, we should use core id bits instead.
> >
> > it should replace
> > [PATCH for review] [37/48] x86_64: make k8topology multi-core aware
>
> Yes, you're right the patch is not good. It should probably use
> information from the regular CPU setup code, not touch cpuid
> directly
>
> I'll drop it for now

too bad, just figure out you dropped wrong one.

following one 36/48 is right. please apply it again.

37/48 got into the mainline. that is wrong. please use
http://lkml.org/lkml/2007/7/22/7
[PATCH 2/3] x86_64: use core id bits for apicid_to_node initialization v2
that is rebased to 37/48.

YH


From: "Joachim Deguara" <joachim.deguara@amd.com>
This just adds the PCI IDs of AMD's family 10h and 11h CPU's northbridges to
k8topology discovery.

Signed-off-by: Joachim Deguara <joachim.deguara@amd.com>
Signed-off-by: Andi Kleen <ak@suse.de>

--
---
 arch/x86_64/mm/k8topology.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

Index: linux/arch/x86_64/mm/k8topology.c
===================================================================
--- linux.orig/arch/x86_64/mm/k8topology.c
+++ linux/arch/x86_64/mm/k8topology.c
@@ -28,11 +28,15 @@ static __init int find_northbridge(void)
               u32 header;

               header = read_pci_config(0, num, 0, 0x00);
-               if (header != (PCI_VENDOR_ID_AMD | (0x1100<<16)))
+               if (header != (PCI_VENDOR_ID_AMD | (0x1100<<16)) &&
+                       header != (PCI_VENDOR_ID_AMD | (0x1200<<16)) &&
+                       header != (PCI_VENDOR_ID_AMD | (0x1300<<16)) )
                       continue;

               header = read_pci_config(0, num, 1, 0x00);
-               if (header != (PCI_VENDOR_ID_AMD | (0x1101<<16)))
+               if (header != (PCI_VENDOR_ID_AMD | (0x1101<<16)) &&
+                       header != (PCI_VENDOR_ID_AMD | (0x1201<<16)) &&
+                       header != (PCI_VENDOR_ID_AMD | (0x1301<<16)) )
                       continue;
               return num;
       }
-
