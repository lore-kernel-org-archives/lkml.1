Return-Path: <linux-kernel-owner+w=401wt.eu-S1759280AbYAQXt1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759280AbYAQXt1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 18:49:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756647AbYAQXtU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 18:49:20 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57727 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756597AbYAQXtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 18:49:19 -0500
Date: Thu, 17 Jan 2008 15:48:16 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Daniel Walker <dwalker@mvista.com>
cc: linux-kernel@vger.kernel.org, Maxim Levitsky <maximlevitsky@gmail.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] fix wrong sized spinlock flags argument
In-Reply-To: <20080117205205.878723737@mvista.com>
Message-ID: <alpine.LFD.1.00.0801171542390.2957@woody.linux-foundation.org>
References: <20080117205205.878723737@mvista.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Applied.

However, the patch itself didn't apply cleanly, because in my souce tree, 
these two lines are in a different order:

On Thu, 17 Jan 2008, Daniel Walker wrote:
>  
>  	pci_set_power_state(pci_dev, PCI_D0);
>  	pci_restore_state(pci_dev);

but I actually think your order is the *correct* one (because I'm not at 
all sure that config space writes are even guaranteed to make a difference 
when in D3cold).

So I wonder, did you have some other fix applied to your "original" tree 
(it sure isn't original 2.6.23, since that whole suspend/resume code was 
added later.

Maxim? Mauro? Pretty much all other drivers do

	pci_set_power_state(pdev, PCI_D0);
	pci_restore_state(pdev);

in that order, and I really do think that D3cold is allowed to not 
actually react fully to all config space accesses (ie we have to re-write 
them after bringing it out of D3)

			Linus
