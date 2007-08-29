Return-Path: <linux-kernel-owner+w=401wt.eu-S1756205AbXH2RtW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756205AbXH2RtW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 13:49:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754092AbXH2RtO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 13:49:14 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:42603 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754232AbXH2RtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 13:49:13 -0400
Date: Wed, 29 Aug 2007 10:49:12 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Peter Lund <firefly@vax64.dk>
cc: Christoph Hellwig <hch@infradead.org>, trivial@kernel.org,
       linux-kernel@vger.kernel.org, Momchil Velikov <velco@fadata.bg>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [PATCH] avoid negative (and full-width) shifts in radix-tree.c,
 take 3
In-Reply-To: <1188402291.7216.90.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0708291048250.21332@schroedinger.engr.sgi.com>
References: <1188402291.7216.90.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Aug 2007, Peter Lund wrote:

>  
> -	if (tmp >= RADIX_TREE_INDEX_BITS)
> -		index = ~0UL;
> -	return index;
> +	if (shift < 0)
> +		return ~0UL;
> +	if (shift >= 8 * sizeof(unsigned long))

8* sizeof(unsigned long) is the constant BITS_PER_LONG.
