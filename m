Return-Path: <linux-kernel-owner+w=401wt.eu-S938400AbXHPDqa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938400AbXHPDqa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 23:46:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932532AbXHPDqS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 23:46:18 -0400
Received: from elasmtp-junco.atl.sa.earthlink.net ([209.86.89.63]:46453 "EHLO
	elasmtp-junco.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932274AbXHPDqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 23:46:16 -0400
X-Greylist: delayed 518 seconds by postgrey-1.27 at vger.kernel.org; Wed, 15 Aug 2007 23:46:16 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=mindspring.com;
  b=m5w/STjzcGRdaFc9sCr/ZhyrcFcUgz5h+Ue5vD3eO/F+bAH3IC0OqplqTjC5NpS2;
  h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-ELNK-Trace:X-Originating-IP;
Date: Wed, 15 Aug 2007 23:37:21 -0400
From: Bill Fink <billfink@mindspring.com>
To: Satyam Sharma <satyam@infradead.org>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Christoph Lameter <clameter@sgi.com>, Chris Snook <csnook@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>, netdev@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, ak@suse.de,
       heiko.carstens@de.ibm.com, davem@davemloft.net, schwidefsky@de.ibm.com,
       wensong@linux-vs.org, horms@verge.net.au, wjiang@resilience.com,
       cfriesen@nortel.com, zlynx@acm.org, rpjday@mindspring.com,
       jesper.juhl@gmail.com, segher@kernel.crashing.org,
       Herbert Xu <herbert@gondor.apana.org.au>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/24] make atomic_read() behave consistently across all
 architectures
Message-Id: <20070815233721.91032366.billfink@mindspring.com>
In-Reply-To: <alpine.LFD.0.999.0708151713080.16414@enigma.security.iitk.ac.in>
References: <20070809131423.GA9927@shell.boston.redhat.com>
	<Pine.LNX.4.64.0708141529310.32693@schroedinger.engr.sgi.com>
	<alpine.LFD.0.999.0708150417240.6482@enigma.security.iitk.ac.in>
	<46C2D6F3.3070707@s5r6.in-berlin.de>
	<alpine.LFD.0.999.0708151713080.16414@enigma.security.iitk.ac.in>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; powerpc-yellowdog-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ELNK-Trace: c598f748b88b6fd49c7f779228e2f6aeda0071232e20db4dce6e2b4563ef7c3651bbd3882e1617f9350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 68.55.21.22
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Aug 2007, Satyam Sharma wrote:

> (C)
> $ cat tp3.c
> int a;
> 
> void func(void)
> {
> 	*(volatile int *)&a = 10;
> 	*(volatile int *)&a = 20;
> }
> $ gcc -Os -S tp3.c
> $ cat tp3.s
> ...
> movl    $10, a
> movl    $20, a
> ...

I'm curious about one minor tangential point.  Why, instead of:

	b = *(volatile int *)&a;

why can't this just be expressed as:

	b = (volatile int)a;

Isn't it the contents of a that's volatile, i.e. it's value can change
invisibly to the compiler, and that's why you want to force a read from
memory?  Why do you need the "*(volatile int *)&" construct?

						-Bill
