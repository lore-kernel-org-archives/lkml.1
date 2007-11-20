Return-Path: <linux-kernel-owner+w=401wt.eu-S1756786AbXKTDuR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756786AbXKTDuR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 22:50:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754644AbXKTDuD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 22:50:03 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:43816 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754508AbXKTDuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 22:50:02 -0500
Date: Mon, 19 Nov 2007 19:50:01 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andi Kleen <ak@suse.de>
cc: akpm@linux-foundation.org, travis@sgi.com,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org
Subject: Re: [rfc 08/45] cpu alloc: x86 support
In-Reply-To: <200711200416.32954.ak@suse.de>
Message-ID: <Pine.LNX.4.64.0711191945260.21813@schroedinger.engr.sgi.com>
References: <20071120011132.143632442@sgi.com> <20071120011333.619991903@sgi.com>
 <200711200416.32954.ak@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Nov 2007, Andi Kleen wrote:

> I might be pointing out the obvious, but on x86-64 there is definitely not 
> 256TB of VM available for this.

Well maybe in the future.

One of the issues that I ran into is that I had to place the cpu area
in between to make the offsets link right.

However, it would be best if the cpuarea came *after* the modules area. We 
only need linking that covers the per cpu area of processor 0.

So I think we have a 2GB area right?

1GB kernel
1GB - 1x per cpu area (128M?) modules?
cpu aree 0
---- 2GB limit
cpu area 1 
cpu area 2
....

For that we would need to move the kernel down a bit. Can we do that?

