Return-Path: <linux-kernel-owner+w=401wt.eu-S1764789AbXFAUrc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764789AbXFAUrc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 16:47:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763131AbXFAUrZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 16:47:25 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:35385 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762859AbXFAUrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 16:47:25 -0400
Date: Fri, 1 Jun 2007 13:47:23 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Srinivasa Ds <srinivasa@in.ibm.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Dinakar Guniguntala <dino@in.ibm.com>, pj@sgi.com, simon.derr@bull.net,
       clameter@cthulhu.engr.sgi.com, rientjes@google.com
Subject: Re: [RFC] [PATCH] cpuset operations causes Badness at mm/slab.c:777
 warning
In-Reply-To: <466081DE.70205@goop.org>
Message-ID: <Pine.LNX.4.64.0706011345220.4323@schroedinger.engr.sgi.com>
References: <465FCA79.70207@in.ibm.com> <200706011620.05756.srinivasa@in.ibm.com>
 <466081DE.70205@goop.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Jun 2007, Jeremy Fitzhardinge wrote:

> I think this is a good example of why having to special-case kmalloc(0)
> is a bad idea.  The original code was straightforward and, barring
> silliness, should be completely correct with npids==0.  This new code
> does nothing other than make things more complex.

Hehe we got you. The code is indexing the pidarray allocated with 
kmalloc(0). So it uncovered a latent bug. It only worked because SLAB gave 
him 32 bytes and it now only works because SLUB give him 8. That is enough 
to illegally index the first array element.


