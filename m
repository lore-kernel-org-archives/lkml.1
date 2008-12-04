Return-Path: <linux-kernel-owner+w=401wt.eu-S1754696AbYLDErR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696AbYLDErR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 23:47:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752572AbYLDErA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 23:47:00 -0500
Received: from mx2.suse.de ([195.135.220.15]:57832 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751121AbYLDEq7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 23:46:59 -0500
Date: Wed, 3 Dec 2008 20:17:39 -0800
From: Greg KH <gregkh@suse.de>
To: Edward Estabrook <edward.estabrook.lkml@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, hjk@linutronix.de,
       edward.estabrook@gmail.com, edward_estabrook@agilent.com
Subject: Re: [PATCH 1/1] Userspace I/O (UIO): Add support for userspace DMA
	(corrected)
Message-ID: <20081204041739.GA16329@suse.de>
References: <208aa0f00812031751n27a75d21h8747054651639463@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <208aa0f00812031751n27a75d21h8747054651639463@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2008 at 05:51:30PM -0800, Edward Estabrook wrote:
> From: Edward Estabrook <Edward_Estabrook@agilent.com>
> 
> Here is a patch that adds the ability to dynamically allocate and use
> coherent DMA
> from userspace by extending the Userspace IO driver.  This patch applies against
> 2.6.28-rc6.
> 
> The gist of this implementation is to overload uio's mmap
> functionality to allocate
> and map a new DMA region on demand.  The bus-specific DMA address as returned by
> dma_alloc_coherent is made available to userspace in the 1st long word
> of the newly
> created region (as well as through the conventional 'addr' file in sysfs).
> 
> The kernel-api change is that passing an offset value of 0xFFFFF000UL
> to the a uio
> device's mmap operation will dynamically allocate a DMA region.  This
> cannot change/
> break existing behavior as the previous UIO code only allowed a maximum of 5
> mappings.

Odd formatting of your paragraphs :(

Anyway, what about 64bit processors?  What happens if they try to use a
valid address in this range?

Is this value always an "invalid" value for all arches that Linux runs
on?

thanks,

greg k-h
