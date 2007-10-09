Return-Path: <linux-kernel-owner+w=401wt.eu-S1755475AbXJITQN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475AbXJITQN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 15:16:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753445AbXJITP7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 15:15:59 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:41167 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753406AbXJITP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 15:15:59 -0400
Date: Tue, 9 Oct 2007 12:15:58 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Akinobu Mita <akinobu.mita@gmail.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, travis@sgi.com
Subject: Re: [PATCH -mm] slub: fix cpu hotplug offline/online path
In-Reply-To: <84144f020710091202u6b617b0ep81759d6a2696614b@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0710091212350.1812@schroedinger.engr.sgi.com>
References: <20071009161328.GA6470@APFDCB5C> 
 <Pine.LNX.4.64.0710091144020.32162@schroedinger.engr.sgi.com> 
 <84144f020710091148s6267a69aud18348af77f941b0@mail.gmail.com> 
 <Pine.LNX.4.64.0710091149221.32730@schroedinger.engr.sgi.com>
 <84144f020710091202u6b617b0ep81759d6a2696614b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Oct 2007, Pekka Enberg wrote:

> Hi Christoph,
> 
> On 10/9/07, Christoph Lameter <clameter@sgi.com> wrote:
> > Our system come by default with the possibility of 1k cpus. However, a
> > small system may only have 8 cpus.
> 
> Maybe I am reading the code wrong, but I don't why that matters as
> it's all statically allocated anyway (the per-cpu kmem_cache_cpu
> array). In any case, I certainly don't object to your proposal, just
> can't figure out why it matters.

The kmem_cache_cpu structures are allocated using DEFINE_PER_CPU. 

The per cpu areas should be dynamically allocated as necessary. There is 
work in progress by Mike Travis to do that. You are right in that (on 
x86_64 at least) we define a static array for all processors.
