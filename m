Return-Path: <linux-kernel-owner+w=401wt.eu-S1752393AbXDIRW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752393AbXDIRW1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 13:22:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752395AbXDIRW0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 13:22:26 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:46970 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752361AbXDIRW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 13:22:26 -0400
Date: Mon, 9 Apr 2007 10:22:24 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Hugh Dickins <hugh@veritas.com>, Nick Piggin <npiggin@suse.de>,
       dgc@sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Optimize compound_head() by avoiding a shared page
 flag
In-Reply-To: <20070407184801.b6f3f549.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0704091020310.4878@schroedinger.engr.sgi.com>
References: <20070405223651.21698.77505.sendpatchset@schroedinger.engr.sgi.com>
 <20070405223657.21698.32754.sendpatchset@schroedinger.engr.sgi.com>
 <20070406222336.4dcdd663.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0704071509550.31503@schroedinger.engr.sgi.com>
 <20070407155148.94da92e8.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0704071718530.31790@schroedinger.engr.sgi.com>
 <20070407182506.4386dc13.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0704071825510.32544@schroedinger.engr.sgi.com>
 <20070407184801.b6f3f549.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 7 Apr 2007, Andrew Morton wrote:

>         andl    $48, %eax       #, tmp399
>         cmpl    $48, %eax       #, tmp399
>         je      .L265   #,
> 
> what's "yuck" about that?


> 
> With the single page flag:
> 
> 	movl	(%ebx), %eax	#* page.521, D.21940
> 	testb	$32, %al	#, D.21940
> 	jne	.L265	#,
> 
> So you're talking about saving one sole single silly solitary instruction.

We are also using another register. The bit instructions can just go in an 
test. Ok. Will submit this patch. .... Maybe I can special case 64 bit.

