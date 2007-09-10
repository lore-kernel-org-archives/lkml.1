Return-Path: <linux-kernel-owner+w=401wt.eu-S1760258AbXIJNx0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760258AbXIJNx0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 09:53:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758823AbXIJNxL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 09:53:11 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:34164 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754235AbXIJNxI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 09:53:08 -0400
Date: Mon, 10 Sep 2007 15:51:56 +0100
From: Arjan van de Ven <arjan@infradead.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <piggin@cyberone.com.au>,
       Satyam Sharma <satyam@infradead.org>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Paul Mackerras <paulus@samba.org>, Christoph Lameter <clameter@sgi.com>,
       Chris Snook <csnook@redhat.com>,
       Ilpo Jarvinen <ilpo.jarvinen@helsinki.fi>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, ak@suse.de,
       heiko.carstens@de.ibm.com, David Miller <davem@davemloft.net>,
       schwidefsky@de.ibm.com, wensong@linux-vs.org, horms@verge.net.au,
       wjiang@resilience.com, cfriesen@nortel.com, zlynx@acm.org,
       rpjday@mindspring.com, jesper.juhl@gmail.com,
       segher@kernel.crashing.org
Subject: Re: [PATCH 0/24] make atomic_read() behave consistently across all
 architectures
Message-ID: <20070910155156.2c1453fc@laptopd505.fenrus.org>
In-Reply-To: <200709101156.30010.vda.linux@googlemail.com>
References: <18115.52863.638655.658466@cargo.ozlabs.ibm.com>
	<200709091902.55388.vda.linux@googlemail.com>
	<20070909191839.1fa10e88@laptopd505.fenrus.org>
	<200709101156.30010.vda.linux@googlemail.com>
Organization: Intel
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.6; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Sep 2007 11:56:29 +0100
Denys Vlasenko <vda.linux@googlemail.com> wrote:

> 
> Well, if you insist on having it again:
> 
> Waiting for atomic value to be zero:
> 
>         while (atomic_read(&x))
>                 continue;
> 

and this I would say is buggy code all the way.

Not from a pure C level semantics, but from a "busy waiting is buggy"
semantics level and a "I'm inventing my own locking" semantics level.

