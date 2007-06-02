Return-Path: <linux-kernel-owner+w=401wt.eu-S1761426AbXFBA0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761426AbXFBA0R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 20:26:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757446AbXFBA0E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 20:26:04 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:44174 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753401AbXFBA0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 20:26:03 -0400
Date: Fri, 1 Jun 2007 17:26:00 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Srinivasa Ds <srinivasa@in.ibm.com>, linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Dinakar Guniguntala <dino@in.ibm.com>, pj@sgi.com, simon.derr@bull.net,
       clameter@cthulhu.engr.sgi.com, rientjes@google.com
Subject: Re: [RFC] [PATCH] cpuset operations causes Badness at mm/slab.c:777
 warning
In-Reply-To: <20070601171612.8194394a.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0706011721390.10254@schroedinger.engr.sgi.com>
References: <465FCA79.70207@in.ibm.com> <200706011620.05756.srinivasa@in.ibm.com>
 <466081DE.70205@goop.org> <Pine.LNX.4.64.0706011345220.4323@schroedinger.engr.sgi.com>
 <20070601135900.ec44b1aa.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0706011444010.5009@schroedinger.engr.sgi.com>
 <20070601151649.bb23c6f9.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0706011519030.7625@schroedinger.engr.sgi.com>
 <20070601153328.1118ccaf.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0706011534170.9497@schroedinger.engr.sgi.com>
 <alpine.LFD.0.98.0706011554300.3957@woody.linux-foundation.org>
 <Pine.LNX.4.64.0706011617330.9781@schroedinger.engr.sgi.com>
 <alpine.LFD.0.98.0706011638360.3957@woody.linux-foundation.org>
 <Pine.LNX.4.64.0706011642530.9992@schroedinger.engr.sgi.com>
 <alpine.LFD.0.98.0706011653290.3957@woody.linux-foundation.org>
 <20070601171612.8194394a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Jun 2007, Andrew Morton wrote:

> I think it'd be better if we kept the WARN_ON_ONCE(size == 0) in there,

The trouble with the WARN_ON is that it triggers even for code that is 
okay like noted by Jeremy. My initial intend with NULL was to allow the 
allocation of a zero sized pointer without extra checks. It should only
trigger a failure if something bad was done.

NULL had the problem of confusion with no memory available. I think BADPTR 
is good. If the coding warts are causing trouble then BADPTR will result 
in a failure. Otherwise if the code is doing a kmalloc(0) and not 
dereferencing the pointer (like Paul's fixed code) then we should be fine 
and not issue a warning.

The false positives may be upsetting some people.
