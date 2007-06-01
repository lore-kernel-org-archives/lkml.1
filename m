Return-Path: <linux-kernel-owner+w=401wt.eu-S1765287AbXFAU75@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765287AbXFAU75 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 16:59:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764491AbXFAU7q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 16:59:46 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:50952 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765117AbXFAU7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 16:59:43 -0400
Date: Fri, 1 Jun 2007 13:59:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Srinivasa Ds <srinivasa@in.ibm.com>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Dinakar Guniguntala <dino@in.ibm.com>, pj@sgi.com, simon.derr@bull.net,
       clameter@cthulhu.engr.sgi.com, rientjes@google.com
Subject: Re: [RFC] [PATCH] cpuset operations causes Badness at mm/slab.c:777
 warning
Message-Id: <20070601135900.ec44b1aa.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0706011345220.4323@schroedinger.engr.sgi.com>
References: <465FCA79.70207@in.ibm.com>
	<200706011620.05756.srinivasa@in.ibm.com>
	<466081DE.70205@goop.org>
	<Pine.LNX.4.64.0706011345220.4323@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Jun 2007 13:47:23 -0700 (PDT)
Christoph Lameter <clameter@sgi.com> wrote:

> On Fri, 1 Jun 2007, Jeremy Fitzhardinge wrote:
> 
> > I think this is a good example of why having to special-case kmalloc(0)
> > is a bad idea.  The original code was straightforward and, barring
> > silliness, should be completely correct with npids==0.  This new code
> > does nothing other than make things more complex.
> 
> Hehe we got you. The code is indexing the pidarray allocated with 
> kmalloc(0). So it uncovered a latent bug. It only worked because SLAB gave 
> him 32 bytes and it now only works because SLUB give him 8. That is enough 
> to illegally index the first array element.
> 

Poisoning and redzoning could have caught that.

But I guess it doesn't matter now, as this shortcoming is specific to
the zero-length allocations, and we're weeding those out anyway.
