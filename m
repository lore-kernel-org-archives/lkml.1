Return-Path: <linux-kernel-owner+w=401wt.eu-S1756653AbYLJUMv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756653AbYLJUMv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 15:12:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753785AbYLJUMn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 15:12:43 -0500
Received: from mx2.redhat.com ([66.187.237.31]:47515 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752378AbYLJUMm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 15:12:42 -0500
From: Jarod Wilson <jarod@redhat.com>
Organization: Red Hat, Inc.
To: linux1394-devel@lists.sourceforge.net
Subject: Re: [PATCH] firewire: fw-ohci: fix possible IOMMU resource exhaustion
Date: Wed, 10 Dec 2008 15:16:03 -0500
User-Agent: KMail/1.10.3 (Linux/2.6.27.7-135.fc10.x86_64; KDE/4.1.3; x86_64; ; )
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-kernel@vger.kernel.org
References: <tkrat.8d55c1b322c680dc@s5r6.in-berlin.de>
In-Reply-To: <tkrat.8d55c1b322c680dc@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812101516.03546.jarod@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 December 2008 18:20:38 Stefan Richter wrote:
> There is a DMA map/ unmap imbalance whenever a block write request
> packet is sent and then dequeued with ohci_cancel_packet.  The latter
> may happen frequently if the AR resp tasklet is executed before the AT
> req tasklet for the same transaction.
> 
> Add the missing dma_unmap_single.
> 
> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

Going to get this into the Fedora kernels ASAP, definitely looks like
it'll at least help w/the IOMMU issues.

Nb: from what I recall, I saw such problems on an 8-way opteron pretty
frequently with a debug-enabled kernel, haven't seen it on the same
box running a release kernel (but also haven't tried the bug reporters
reproducer).

Signed-off-by: Jarod Wilson <jarod@redhat.com>

-- 
Jarod Wilson
jarod@redhat.com
