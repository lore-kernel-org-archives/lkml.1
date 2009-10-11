Return-Path: <linux-kernel-owner+w=401wt.eu-S1754991AbZJKQAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754991AbZJKQAk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 12:00:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753083AbZJKQAj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 12:00:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41122 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752108AbZJKQAj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 12:00:39 -0400
Date: Sun, 11 Oct 2009 17:59:54 +0200 (CEST)
From: John Kacur <jkacur@redhat.com>
X-X-Sender: jkacur@localhost.localdomain
To: Christoph Hellwig <hch@lst.de>
cc: linux-kernel@vger.kernel.org, xfs-masters@oss.sgi.com,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [xfs-masters] INFO: possible circular locking dependency
 detected
In-Reply-To: <20091011124616.GA4081@lst.de>
Message-ID: <alpine.LFD.2.00.0910111759030.12574@localhost.localdomain>
References: <alpine.LFD.2.00.0910110108160.4921@localhost.localdomain> <20091011124616.GA4081@lst.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 11 Oct 2009, Christoph Hellwig wrote:

> This has been around for a long time, the VM calls into fput and thus
> ->release with the mmap_sem held, which makes it really hard for a
> filesystem to avoid a lock inversion if it uses a lock both in ->release
> and the I/O path.
> 
> I have a workaround for this to only acquire the XFS iolock with a
> trylock in the release path and leave cleaning up stale preallocations
> until the final iput.  It's not pretty, but given that we're unlikely
> to see the VM fixed I might aswell finally send it for inclusion.
> 

In seems very easy and reliable to reproduce on my machine - so I am happy 
to test the patch here when you're ready.

Thanks

John
