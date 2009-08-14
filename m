Return-Path: <linux-kernel-owner+w=401wt.eu-S1754174AbZHNBuE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174AbZHNBuE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 21:50:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753980AbZHNBuD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 21:50:03 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54847 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753257AbZHNBuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 21:50:02 -0400
Date: Thu, 13 Aug 2009 18:47:40 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Frans Pop <elendil@planet.nl>
cc: mano@roarinelk.homelinux.net, rjw@sisk.pl, willy@linux.intel.com,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       akpm@linux-foundation.org, andrew.patterson@hp.com
Subject: Re: PCI resources allocation problem on Toshiba Satellite A40
In-Reply-To: <200908140341.02210.elendil@planet.nl>
Message-ID: <alpine.LFD.2.01.0908131843200.3162@localhost.localdomain>
References: <200908021619.48285.rjw@sisk.pl> <alpine.LFD.2.01.0908020927410.3352@localhost.localdomain> <20090803165909.GA12824@roarinelk.homelinux.net> <alpine.LFD.2.01.0908041555120.3270@localhost.localdomain> <20090805155102.GA31646@roarinelk.homelinux.net>
 <alpine.LFD.2.01.0908050902300.3390@localhost.localdomain> <alpine.LFD.2.01.0908050931390.3390@localhost.localdomain> <20090805170934.GA32274@roarinelk.homelinux.net> <alpine.LFD.2.01.0908071051300.3390@localhost.localdomain> <alpine.LFD.2.01.0908071116520.3390@localhost.localdomain>
 <20090811184740.49f52b57@scarran.roarinelk.net> <20090811184740.49f52b57@scarran.roarinelk.net> <alpine.LFD.2.01.0908131113580.28882@localhost.localdomain> <alpine.LFD.2.01.0908131113580.28882@localhost.localdomain> <200908132128.31439.elendil@planet.nl>
 <200908140341.02210.elendil@planet.nl>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 14 Aug 2009, Frans Pop wrote:
> 
> The commit that resulted in the messages disappearing was:
> commit a76117dfd687ec4be0a9a05214f3009cc5f73a42
> Author: Matthew Wilcox <willy@linux.intel.com>
> Date:   Wed Jun 17 16:33:35 2009 -0400
>     x86: Use pci_claim_resource
> 
> The commit that caused the messages to return is:
> commit 79896cf42f6a96d7e14f2dc3473443d68d74031d
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Sun Aug 2 14:04:19 2009 -0700
>     Make pci_claim_resource() use request_resource() rather than insert_resource()
> 
> The affected devices are the two USB UHCI controllers.

Ok, it's the same behavior that mano had, but since the warning didn't go 
away with the trial patch, it's not exactly the same situation.

Can you send

 - output of /proc/ioports both with the current kernel (or the 2.6.30 
   kernel - they should be identical) and with one of the kernels in 
   between that didn't warn

 - send the full bootup dmesg with CONFIG_PCI_DEBUG enabled

and we can probably figure it out.

That said, since it's not a regression, I'm not going to _do_ anything 
about it until after 2.6.31, but I might have a test-patch for you to try 
ot something.

		Linus
