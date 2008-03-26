Return-Path: <linux-kernel-owner+w=401wt.eu-S1760260AbYCZVhp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760260AbYCZVhp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 17:37:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757301AbYCZVhg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 17:37:36 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35793 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755346AbYCZVhf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 17:37:35 -0400
From: Jarod Wilson <jwilson@redhat.com>
Organization: Red Hat, Inc.
To: linux1394-devel@lists.sourceforge.net
Subject: Re: [PATCH] firewire: fw-ohci: plug dma memory leak in AR handler
Date: Wed, 26 Mar 2008 17:37:30 -0400
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <200803251647.16227.jwilson@redhat.com>
In-Reply-To: <200803251647.16227.jwilson@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803261737.30717.jwilson@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 25 March 2008 04:47:16 pm Jarod Wilson wrote:
> There's a nasty memory leak in firewire-ohci's ar_context_tasklet(), in
> that we're not freeing up some of the memory we use for each ar_buffer, due
> to a moving pointer. The problem has been there for a while, but didn't
> start to be noticed until we were doing a coherent allocation for the
> ar_buffer -- meaning we have a smaller pool of memory to work with now, so
> the problem crops up sooner. The manifestation of this comes after doing a
> bunch of I/O to a firewire disk, which eventually stalls, and this starts
> spewing to the console:
>
> PCI-DMA: Out of IOMMU space for 53248 bytes at device 0000:04:09.0
>
> The device there is one of my FireWire controllers trying to do I/O. The
> host is a fairly new rev. opteron.
>
> Just need to make sure we're freeing the correct memory range is pass
> through ar_context_tasklet to fix it. Probably something we ought to sneak
> into 2.6.25 if its still doable...

So as it turns out, while this is indeed a leak that needs to be plugged, it 
does NOT remedy the 'out of iommu space' issue, it just delays it a while 
longer. Still working on tracing the root cause of the memory exhaustion.


-- 
Jarod Wilson
jwilson@redhat.com
