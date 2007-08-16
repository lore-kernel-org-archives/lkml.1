Return-Path: <linux-kernel-owner+w=401wt.eu-S932398AbXHPSsm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932398AbXHPSsm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 14:48:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757832AbXHPSsa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 14:48:30 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:47726 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756984AbXHPSs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 14:48:28 -0400
Date: Thu, 16 Aug 2007 11:48:23 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Paul Mackerras <paulus@samba.org>
cc: Herbert Xu <herbert@gondor.apana.org.au>,
       Satyam Sharma <satyam@infradead.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Chris Snook <csnook@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>, netdev@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, ak@suse.de,
       heiko.carstens@de.ibm.com, davem@davemloft.net, schwidefsky@de.ibm.com,
       wensong@linux-vs.org, horms@verge.net.au, wjiang@resilience.com,
       cfriesen@nortel.com, zlynx@acm.org, rpjday@mindspring.com,
       jesper.juhl@gmail.com, segher@kernel.crashing.org
Subject: Re: [PATCH 0/24] make atomic_read() behave consistently across all
 architectures
In-Reply-To: <18115.49946.522011.832468@cargo.ozlabs.ibm.com>
Message-ID: <Pine.LNX.4.64.0708161147450.17049@schroedinger.engr.sgi.com>
References: <alpine.LFD.0.999.0708151713080.16414@enigma.security.iitk.ac.in>
 <18115.35524.56393.347841@cargo.ozlabs.ibm.com>
 <Pine.LNX.4.64.0708151725130.10497@schroedinger.engr.sgi.com>
 <20070816003948.GY9645@linux.vnet.ibm.com> <Pine.LNX.4.64.0708151740570.10497@schroedinger.engr.sgi.com>
 <20070816005348.GA9645@linux.vnet.ibm.com> <Pine.LNX.4.64.0708151757400.11196@schroedinger.engr.sgi.com>
 <20070816011414.GC9645@linux.vnet.ibm.com> <Pine.LNX.4.64.0708151839140.11520@schroedinger.engr.sgi.com>
 <alpine.LFD.0.999.0708160730590.24380@enigma.security.iitk.ac.in>
 <20070816020851.GA30809@gondor.apana.org.au>
 <Pine.LNX.4.64.0708151917210.11736@schroedinger.engr.sgi.com>
 <18115.49946.522011.832468@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Aug 2007, Paul Mackerras wrote:

> 
> It seems that there could be a lot of places where atomic_t is used in
> a non-atomic fashion, and that those uses are either buggy, or there
> is some lock held at the time which guarantees that other CPUs aren't
> changing the value.  In both cases there is no point in using
> atomic_t; we might as well just use an ordinary int.

The point of atomic_t is to do atomic *changes* to the variable.
