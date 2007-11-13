Return-Path: <linux-kernel-owner+w=401wt.eu-S1763897AbXKMWC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763897AbXKMWC2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 17:02:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761134AbXKMWCT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 17:02:19 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:46327 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760525AbXKMWCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 17:02:18 -0500
Date: Tue, 13 Nov 2007 14:02:17 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Eric Dumazet <dada1@cosmosbay.com>
cc: David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       linux-mm@vger.kernel.org, linux-kernel@vger.kernel.org,
       schwidefsky@de.ibm.com
Subject: Re: [patch 01/28] cpu alloc: The allocator
In-Reply-To: <473A1DEA.7000307@cosmosbay.com>
Message-ID: <Pine.LNX.4.64.0711131401030.4176@schroedinger.engr.sgi.com>
References: <20071106195144.983665861@sgi.com> <20071106195157.878563669@sgi.com>
 <20071113.031510.151440585.davem@davemloft.net>
 <Pine.LNX.4.64.0711131339240.3714@schroedinger.engr.sgi.com>
 <473A1DEA.7000307@cosmosbay.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Nov 2007, Eric Dumazet wrote:

> This is because NR_CPUS is defaulted to 32 on i386 (with a limit of 256), so
> reserving 256*256KB = 64 MB of virtual space might be too much. (this is half
> the typical vmalloc area)

It defaults to 8 except if you use a NUMA system.

config NR_CPUS
        int "Maximum number of CPUs (2-255)"
        range 2 255
        depends on SMP
        default "32" if X86_NUMAQ || X86_SUMMIT || X86_BIGSMP || X86_ES7000
        default "8"

