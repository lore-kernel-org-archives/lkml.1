Return-Path: <linux-kernel-owner+w=401wt.eu-S1752048AbXBVXfU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048AbXBVXfU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 18:35:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752049AbXBVXfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 18:35:20 -0500
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:43341 "EHLO
	netops-testserver-4.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752048AbXBVXfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 18:35:19 -0500
X-Greylist: delayed 2028 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Feb 2007 18:35:19 EST
Date: Thu, 22 Feb 2007 15:01:30 -0800 (PST)
From: Christoph Lameter <clameter@engr.sgi.com>
To: Pekka J Enberg <penberg@cs.helsinki.fi>,
       Pekka Enberg <penberg@cs.helsinki.fi>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, wli@holomorphy.com
Subject: Re: [RFC/PATCH] slab: free pages in a batch in drain_freelist
Message-ID: <Pine.LNX.4.64.0702221500420.22546@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Feb 2007, Pekka J Enberg wrote:

> As suggested by William, free the actual pages in a batch so that we
> don't keep pounding on l3->list_lock.

This means holding the l3->list_lock for a prolonged time period. The 
existing code was done this way in order to make sure that the interrupt 
holdoffs are minimal.

There is no pounding. The cacheline with the list_lock is typically held 
until the draining is complete. While we drain the freelist we need to be 
able to respond to interrupts.

