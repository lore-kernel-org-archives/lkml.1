Return-Path: <linux-kernel-owner+w=401wt.eu-S933795AbYB2T51@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933795AbYB2T51 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 14:57:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760060AbYB2T5S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 14:57:18 -0500
Received: from relay1.sgi.com ([192.48.171.29]:54321 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758517AbYB2T5R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 14:57:17 -0500
Date: Fri, 29 Feb 2008 11:57:16 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Eric Dumazet <dada1@cosmosbay.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Torsten Kaiser <just.for.lkml@googlemail.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Implement slub fastpath in terms of freebase and freeoffset
In-Reply-To: <20080229130348.GA9714@Krystal>
Message-ID: <Pine.LNX.4.64.0802291155480.11292@schroedinger.engr.sgi.com>
References: <20080219200358.GB11197@Krystal>
 <Pine.LNX.4.64.0802271532580.14380@schroedinger.engr.sgi.com>
 <20080228055510.GA9026@Krystal> <Pine.LNX.4.64.0802281054230.29191@schroedinger.engr.sgi.com>
 <20080228232507.GB20319@Krystal> <Pine.LNX.4.64.0802281648510.1954@schroedinger.engr.sgi.com>
 <20080229015621.GB32200@Krystal> <Pine.LNX.4.64.0802281812290.3159@schroedinger.engr.sgi.com>
 <20080229033255.GA2200@Krystal> <Pine.LNX.4.64.0802282107090.5947@schroedinger.engr.sgi.com>
 <20080229130348.GA9714@Krystal>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Feb 2008, Mathieu Desnoyers wrote:

> > Then we do not need the page->end field anymore right? I will try 
> > to rediff your patch against current slab-mm and see how we can proceed 
> > from there.
> 
> I guess you could replace page->end with the (expensive)
> page_address(page) + 1 in new_slab.
> 
> You would also have to change slab_address() to use
> page_address(page). Since this is used by check_valid_pointer, I am not
> sure it's a good idea to use this slow operation there.
> 
> Or maybe you have a different alternative in mind ?

page->end was introduced to have a unique pointer for each slab. The 
counter that you introduces can take over that role. So we could use a 
NULL pointer again as the end of the objects? Or some constant?

I am going to revert the change that introduced page->end for 2.6.25 since 
it seems that the new fastpath does not need this. It was specific to the 
old fastpath.

