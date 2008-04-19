Return-Path: <linux-kernel-owner+w=401wt.eu-S1753947AbYDSAZy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947AbYDSAZy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 20:25:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752410AbYDSAZr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 20:25:47 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:56716 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751655AbYDSAZq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 20:25:46 -0400
Message-ID: <48093C01.1040505@garzik.org>
Date: Fri, 18 Apr 2008 20:25:37 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Lennert Buytenhek <buytenh@wantstofly.org>
CC: rmk@arm.linux.org.uk, linux-arm-kernel@lists.arm.linux.org.uk,
       kernel@wantstofly.org, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/15] ARM minor irq handler cleanups
References: <d7afbccda111e535bb14ad8082b208c7a2cd9833.1208559659.git.jgarzik@redhat.com> <20080418232922.GA31711@xi.wantstofly.org>
In-Reply-To: <20080418232922.GA31711@xi.wantstofly.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lennert Buytenhek wrote:
> On Fri, Apr 18, 2008 at 07:22:45PM -0400, Jeff Garzik wrote:
>> This change's main purpose is to prepare for the patchset in
>> jgarzik/misc-2.6.git#irq-remove, that explores removal of the
>> never-used 'irq' argument in each interrupt handler.
> 
> What do you mean?  I know at least one of two interrupt handlers
> in-tree that use their 'irq' arguments.

They can use new function get_irqfunc_irq(), similar to the existing 
method of getting pt_regs for the tiny number of users who need that 
sort of info, when pt_regs was removed.

But after having gone over, literally, every single interrupt handler in 
the kernel, I can safely say that 99.8% never reference that argument, 
and 0.1% that do already have the same information via another route.

That leaves only a few drivers that need it without modification, and 
even fewer drivers that need it after modification.

	Jeff


