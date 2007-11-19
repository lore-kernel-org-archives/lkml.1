Return-Path: <linux-kernel-owner+w=401wt.eu-S1753561AbXKSVoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561AbXKSVoU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 16:44:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751750AbXKSVoK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 16:44:10 -0500
Received: from sj-iport-3-in.cisco.com ([171.71.176.72]:60708 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652AbXKSVoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 16:44:08 -0500
To: benh@kernel.crashing.org
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       Russell King <rmk@arm.linux.org.uk>
Subject: Re: SCSI breakage on non-cache coherent architectures
X-Message-Flag: Warning: May contain useful information
References: <1195450523.7022.37.camel@pasglop>
From: Roland Dreier <rdreier@cisco.com>
Date: Mon, 19 Nov 2007 13:43:59 -0800
In-Reply-To: <1195450523.7022.37.camel@pasglop> (Benjamin Herrenschmidt's message of "Mon, 19 Nov 2007 16:35:23 +1100")
Message-ID: <adapry5ykps.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 19 Nov 2007 21:43:59.0780 (UTC) FILETIME=[4B3E7E40:01C82AF5]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > I've been debugging various issues on the PowerPC 44x embedded
 > architecture which happens to have non-coherent PCI DMA.
 > 
 > One of the problem I'm hitting is that one really need to enforce
 > kmalloc alignement to cache lines or bad things will happen (among
 > others with USB), for some reasons, powerpc failed to do so, I fixed it.

Heh... I hit the same problem literally 5 years ago:
    http://lwn.net/Articles/1783/

I implemented the __dma_buffer annotation:
    http://lwn.net/Articles/2269/

But DaveM said we should just use the PCI pool code instead:
    http://lwn.net/Articles/2270/

 - R.
