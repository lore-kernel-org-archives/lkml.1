Return-Path: <linux-kernel-owner+w=401wt.eu-S1760701AbXGCTwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760701AbXGCTwU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 15:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757299AbXGCTwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 15:52:14 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:52320 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757191AbXGCTwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 15:52:13 -0400
Date: Tue, 3 Jul 2007 12:52:07 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Ingo Molnar <mingo@elte.hu>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andre Noll <maan@systemlinux.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.22-rc7
In-Reply-To: <20070703194523.GC493@elte.hu>
Message-ID: <Pine.LNX.4.64.0707031251160.7491@schroedinger.engr.sgi.com>
References: <alpine.LFD.0.98.0707011427380.1172@woody.linux-foundation.org>
 <20070703155519.GY22589@skl-net.de> <alpine.LFD.0.98.0707030908390.9434@woody.linux-foundation.org>
 <Pine.LNX.4.64.0707030921400.4810@schroedinger.engr.sgi.com>
 <20070703194523.GC493@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Jul 2007, Ingo Molnar wrote:

> yeah. Your change looks good to me. You could add a 
> local_irq_enable_in_hardirq() to the original place, that will map to a 
> local_irq_enable() on non-lockdep kernels and will be a NOP on lockdep 
> kernels. (This is a bit hacky though.)

Then kernels with lockdep would spew out lots of messages later in boot 
because kmem_cache_init disabled interrupts for good.
