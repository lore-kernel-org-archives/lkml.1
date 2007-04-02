Return-Path: <linux-kernel-owner+w=401wt.eu-S965419AbXDBN2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965419AbXDBN2Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 09:28:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965425AbXDBN2X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 09:28:23 -0400
Received: from one.firstfloor.org ([213.235.205.2]:51544 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965419AbXDBN2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 09:28:23 -0400
Date: Mon, 2 Apr 2007 15:28:20 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Tasos Parisinos <t.parisinos@sciensis.com>
Cc: Andi Kleen <andi@firstfloor.org>, herbert@gondor.apana.org.au,
       linux-kernel@vger.kernel.org, randy.dunlap@oracle.com, indan@nul.nu
Subject: Re: [PATCH resend][CRYPTO]: RSA algorithm patch
Message-ID: <20070402132820.GA28983@one.firstfloor.org>
References: <4610D25F.7080005@ceid.upatras.gr> <p73r6r3yn9f.fsf@bingen.suse.de> <4610EDF9.9000601@sciensis.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4610EDF9.9000601@sciensis.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> The main purpose behind the creation of this module was to create the
> cryptographic infrastructure to develop an in-kernel system of signed
> modules.

So how do you plan to close the various interfaces that allow access to kernel
memory? 

I would suggest to discuss the high level design first before submitting
code. 

> 
> The best environment to deploy such functionality is in updating by remote,
> executable code (programs, libs and modules) on embedded devices running
> Linux, that have some form of kernel physical security, so one can't 

How would that physical security look like? Would it include DMA
protection?

For example to do any useful form of graphics you need
user controllable DMA, which can normally touch everything.
There are various other similar "backdoors" for root.

I'm somewhat sceptical because all kernels will need access
to the direct mapping to operate and there are also various
interfaces that can be as root (ab)used to change it.

And when you can do that they can change function pointers
and jump to arbitary code or change the kernel page tables
and map arbitary code.

Disallowing all this would probably end up with a quite
useless kernel. 

> There are already some systems that implement and utilize such 
> functionality that
> use windows platforms, and other Linux distros that use userland 

Yes, at least the Vista variant was just broken. And its designers spent
a lot of effort on it, but it didn't help.

-Andi

