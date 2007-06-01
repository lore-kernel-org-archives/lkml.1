Return-Path: <linux-kernel-owner+w=401wt.eu-S1763671AbXFAVpl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763671AbXFAVpl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 17:45:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761419AbXFAVpf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 17:45:35 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:37992 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761412AbXFAVpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 17:45:34 -0400
Date: Fri, 1 Jun 2007 14:45:27 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Jeremy Fitzhardinge <jeremy@goop.org>, Srinivasa Ds <srinivasa@in.ibm.com>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Dinakar Guniguntala <dino@in.ibm.com>, pj@sgi.com, simon.derr@bull.net,
       clameter@cthulhu.engr.sgi.com, rientjes@google.com
Subject: Re: [RFC] [PATCH] cpuset operations causes Badness at mm/slab.c:777
 warning
In-Reply-To: <20070601135900.ec44b1aa.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0706011444010.5009@schroedinger.engr.sgi.com>
References: <465FCA79.70207@in.ibm.com> <200706011620.05756.srinivasa@in.ibm.com>
 <466081DE.70205@goop.org> <Pine.LNX.4.64.0706011345220.4323@schroedinger.engr.sgi.com>
 <20070601135900.ec44b1aa.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Jun 2007, Andrew Morton wrote:

> Poisoning and redzoning could have caught that.

Redzoning would not have caught it. This was a kmalloc allocation and 
SLAB always gave them 32 bytes to play with. Only writes more than 32 
bytes behind would have been caught.

Poisoning is only applicable to unallocated objects and these were 
allocated.

