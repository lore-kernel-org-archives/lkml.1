Return-Path: <linux-kernel-owner+w=401wt.eu-S932386AbXDEAnl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932386AbXDEAnl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 20:43:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932433AbXDEAnl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 20:43:41 -0400
Received: from gw.goop.org ([64.81.55.164]:36116 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932386AbXDEAnk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 20:43:40 -0400
Message-ID: <46144621.20407@goop.org>
Date: Wed, 04 Apr 2007 17:43:13 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       virtualization@lists.osdl.org, lkml <linux-kernel@vger.kernel.org>,
       William Lee Irwin III <wli@holomorphy.com>,
       Zachary Amsden <zach@vmware.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 07/20] Allow paravirt backend to choose kernel PMD sharing
References: <20070404191151.009821039@goop.org> <20070404191205.392155702@goop.org> <Pine.LNX.4.64.0704041729300.22161@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0704041729300.22161@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> Acked-by: Christoph Lameter <clameter@sgi.com>
>
> for all thats worth since I am not a i386 specialist.
>
> How much of the issues with page struct sharing between slab and arch code 
> does this address?
>   

I haven't been following that thread as closely as I should be, so I
don't have an answer.  I guess the interesting thing in this patch is
that it only uses the pmd cache for usermode pmds (which are
pre-zeroed), and normal page allocations for kernel pmds.  Also, if the
kernel pmds are unshared, the pgds are page-sized, so its not really
making good use of the pgd cache.

    J
