Return-Path: <linux-kernel-owner+w=401wt.eu-S934337AbXHMFRX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934337AbXHMFRX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 01:17:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752832AbXHMFRJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 01:17:09 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:1387 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752666AbXHMFRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 01:17:07 -0400
From: Herbert Xu <herbert@gondor.apana.org.au>
To: paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH 6/24] make atomic_read() behave consistently on frv
Cc: herbert@gondor.apana.org.au, csnook@redhat.com, dhowells@redhat.com,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       torvalds@linux-foundation.org, netdev@vger.kernel.org,
       akpm@linux-foundation.org, ak@suse.de, heiko.carstens@de.ibm.com,
       davem@davemloft.net, schwidefsky@de.ibm.com, wensong@linux-vs.org,
       horms@verge.net.au, wjiang@resilience.com, cfriesen@nortel.com,
       zlynx@acm.org, rpjday@mindspring.com, jesper.juhl@gmail.com
Organization: Core
In-Reply-To: <20070811042943.GA13410@linux.vnet.ibm.com>
X-Newsgroups: apana.lists.os.linux.kernel,apana.lists.os.linux.netdev
User-Agent: tin/1.7.4-20040225 ("Benbecula") (UNIX) (Linux/2.6.17-rc4 (i686))
Message-Id: <E1IKSHQ-0007hg-00@gondolin.me.apana.org.au>
Date: Mon, 13 Aug 2007 13:15:52 +0800
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> On Sat, Aug 11, 2007 at 08:54:46AM +0800, Herbert Xu wrote:
>> Chris Snook <csnook@redhat.com> wrote:
>> > 
>> > cpu_relax() contains a barrier, so it should do the right thing.  For 
>> > non-smp architectures, I'm concerned about interacting with interrupt 
>> > handlers.  Some drivers do use atomic_* operations.
>> 
>> What problems with interrupt handlers? Access to int/long must
>> be atomic or we're in big trouble anyway.
> 
> Reordering due to compiler optimizations.  CPU reordering does not
> affect interactions with interrupt handlers on a given CPU, but
> reordering due to compiler code-movement optimization does.  Since
> volatile can in some cases suppress code-movement optimizations,
> it can affect interactions with interrupt handlers.

If such reordering matters, then you should use one of the
*mb macros or barrier() rather than relying on possibly
hidden volatile cast.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
