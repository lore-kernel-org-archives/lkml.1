Return-Path: <linux-kernel-owner+w=401wt.eu-S1753148AbZFXXWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753148AbZFXXWs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 19:22:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751768AbZFXXWl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 19:22:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45435 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751392AbZFXXWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 19:22:40 -0400
Date: Wed, 24 Jun 2009 16:21:09 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Yinghai Lu <yinghai@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Gary Hade <garyhade@us.ibm.com>, Matthew Wilcox <matthew@wil.cx>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-pci@vger.kernel.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>
Subject: Re: [PATCH] x86/pci: don't use crs for root if we only have one root
 bus
In-Reply-To: <alpine.LFD.2.01.0906241607100.18460@localhost.localdomain>
Message-ID: <alpine.LFD.2.01.0906241615160.18460@localhost.localdomain>
References: <20090624122433.GA24781@elte.hu> <20090624145119.GA12664@elte.hu> <4A429EBB.5010209@kernel.org> <4A42AFAC.6000300@kernel.org> <alpine.LFD.2.01.0906241607100.18460@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 24 Jun 2009, Linus Torvalds wrote:
>
> I'm happy to apply various patches to fix it up, but regardless, I thinkwe 
> should revert that commit as bogus. We can try making it the default again 
> next round, when maybe it will be true that it doesn't cause issues.

Btw, I really think our _CRS handling sucks.

There's two things that you can do with _CRS:

 - use the _existence_ of it as an indicator of a root bus

 - try to use it to populate the resource tree.

And quite frankly, I think #2 is broken. There's no way in hell that ACPI 
tables are ever going to be better than just asking the hardware. We've 
gone through this before. Trusting ACPI over the hardware is just 
FUNDAMENTALLY WRONG.

So I'm just going to do that revert. I'm not sure if it ever makes sense 
to make that insane _CRS code the default. It seems like a fundamentally 
flawed idea.

			Linus
