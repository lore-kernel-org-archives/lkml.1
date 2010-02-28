Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032092Ab0B1VTk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 16:19:40 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54162 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032025Ab0B1VTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 16:19:38 -0500
Date: Sun, 28 Feb 2010 13:19:35 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Yinghai <yinghai@kernel.org>
cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] PCI changes for 2.6.34
In-Reply-To: <33223F6C-10BD-4671-937D-6D5E4956DD3F@kernel.org>
Message-ID: <alpine.LFD.2.00.1002281314110.3637@localhost.localdomain>
References: <20100226093957.7b99d09c@jbarnes-piketon> <alpine.LFD.2.00.1002281227300.3851@localhost.localdomain> <alpine.LFD.2.00.1002281246120.3637@localhost.localdomain> <33223F6C-10BD-4671-937D-6D5E4956DD3F@kernel.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 28 Feb 2010, Yinghai wrote:
> 
> Maybe we need to put back pci=try=num back
> And set pci_try_num=1 by default

Well, why does your patch trigger any changes at all in the first place? 
The old situation was fine. All the resources were mapped.

Sure, there were ROM resources that aren't even enabled, but that is 
_normal_. Iirc, several graphics chips actually alias the ROM resources 
with the regular memory-mapped IO resource, ie you can't even map both of 
them at the same time at some separate address, because the hardware 
shares address decoding resources.

There's a reson PCI ROM resources are treated specially by the kernel.

And as far as I can see, all the other resources are already allocated 
even without your patch. So there is some fundamental _bug_ there. This is 
not about enabling/disabling your patch, this is about your patch 
apparently simply being wrong.

But maybe I'm missing something.

			Linus
