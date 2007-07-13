Return-Path: <linux-kernel-owner+w=401wt.eu-S937868AbXGMWvr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937868AbXGMWvr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 18:51:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937613AbXGMWuh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 18:50:37 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:33716 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S935046AbXGMWue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 18:50:34 -0400
Date: Fri, 13 Jul 2007 15:50:33 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: David Miller <davem@davemloft.net>
cc: ak@suse.de, linux-kernel@vger.kernel.org, travis@sgi.com, jeremy@goop.org
Subject: Re: x86: Convert cpu_core_map to be a per cpu variable
In-Reply-To: <20070713.154119.15263594.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0707131546140.26352@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0707122354340.17278@schroedinger.engr.sgi.com>
 <20070713.000814.102125147.davem@davemloft.net>
 <Pine.LNX.4.64.0707130933140.21777@schroedinger.engr.sgi.com>
 <20070713.154119.15263594.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 13 Jul 2007, David Miller wrote:

> I see, the acessor is abstracted via a function.

Yes. The accessor for the scheduler is defined for each arch in topology.c

> That seems pointless, and allows you to do things like this, improving
> the implementation on one set of platforms yet leave others using
> SMT/multi-core scheduling behind.
> 
> It makes a lot more sense to make the implementation consistent
> and therefore the improvements are seen on every platform.

Slight differences exist on each platform. I already have enough trouble 
here right now to deal with the x86_64 overlap into i386. There are 
numerous other x86 specific maps that will have to be treated the same way 
and they are all handled in arch specific files.

Core cpu and node maps exist in the page allocator and are defined in 
nodemask.h and cpumask.h. I have recently introduced a framework that 
allows the definition of new masks that could be used in the future to 
abstract these out of the arches (See the memoryless node patchees). But 
that work has not been merged yet and is likely going to be a separate 
project.


