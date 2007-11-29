Return-Path: <linux-kernel-owner+w=401wt.eu-S1762590AbXK2Bsk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762590AbXK2Bsk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 20:48:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759702AbXK2Bsc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 20:48:32 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:33879 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757316AbXK2Bsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 20:48:31 -0500
Date: Wed, 28 Nov 2007 17:48:31 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Rusty Russell <rusty@rustcorp.com.au>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>
Subject: Re: [patch 05/14] percpu: Use a Kconfig variable to configure arch
 specific percpu setup
In-Reply-To: <474E1900.1010209@goop.org>
Message-ID: <Pine.LNX.4.64.0711281745470.20042@schroedinger.engr.sgi.com>
References: <20071127001407.859743255@sgi.com> <200711281236.02014.rusty@rustcorp.com.au>
 <Pine.LNX.4.64.0711281050470.11968@schroedinger.engr.sgi.com>
 <200711291017.52727.rusty@rustcorp.com.au> <474DFD7E.907@goop.org>
 <Pine.LNX.4.64.0711281604560.17738@schroedinger.engr.sgi.com>
 <474E163E.2070702@goop.org> <Pine.LNX.4.64.0711281731410.19914@schroedinger.engr.sgi.com>
 <474E1900.1010209@goop.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Nov 2007, Jeremy Fitzhardinge wrote:

> Don't think it matters either way.  Before percpu is allocated, NUMA
> issues don't matter.  Once they are - by whatever mechanism - you can
> set the segment bases up appropriately.  The fact that you chose to put
> percpu data at address X doesn't affect the percpu mechanism one way or
> the other.

The percpu areas need to be allocated in a NUMA aware fashion. Otherwise 
you use distant memory for the most performance sensitive areas. The NUMA 
subsystem must be so far up that these allocations can be performed in the 
right way. And this means at least you need to know on which node each 
processor is located. That is what the PDA is currently used for and i386 
has no other way of doing that. I think we could use an array [NR_CPUS] 
for this one but we want to avoid these arrays because NR_CPUS may get 
very big.

