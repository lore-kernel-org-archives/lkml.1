Return-Path: <linux-kernel-owner+w=401wt.eu-S1756927AbXK0OM5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756927AbXK0OM5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 09:12:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754562AbXK0OMs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 09:12:48 -0500
Received: from one.firstfloor.org ([213.235.205.2]:56894 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754295AbXK0OMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 09:12:47 -0500
Date: Tue, 27 Nov 2007 15:12:42 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Andi Kleen <andi@firstfloor.org>, rusty@rustcorp.com.au, rdreier@cisco.com,
       ak@suse.de, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       sam@ravnborg.org
Subject: Re: [PATCH RFC] [1/9] Core module symbol namespaces code and intro.
Message-ID: <20071127141242.GA26794@one.firstfloor.org>
References: <20071127105016.GC24223@one.firstfloor.org> <E1Ix0ws-0001Vh-00@gondolin.me.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1Ix0ws-0001Vh-00@gondolin.me.apana.org.au>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> OK, short of making IPv4 a module (which would be a worthy task :)

At some point there were patches, it is probably not very difficult.
But DaveM resisted at some point because he didn't want people
to replace the network stack (although I personally don't have a problem
with that)

> do you have an example where a symbol is used by more than one module
> but needs to be put into a namespace?

For SCSI: SD,SR,SG etc.
For Networking: e.g. symbols i put into inet, which are only
used by protocols (sctp, dccp, udplite, ipv6)
I already caught someone doing something wrong with that BTW -- 
wanrouter clearly does some things it shouldn't be doing. 
Or the fib namespace, where all the fib functions should be only
used by the two fib_* modules and ipv6/decnet.
For KVM: the exports used by kvm_amd/intel
For arch/x86: e.g. e820_*, IO_APIC_get_PCI_irq_vector, swiotlb, 
a lot of stuff only used by acpi processor.c, pcibios*, etc.etc.
Roland gave another example for Infiniband.

Also in general it allows flexibility later if modules get split.

-Andi
