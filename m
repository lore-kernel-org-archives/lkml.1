Return-Path: <linux-kernel-owner+w=401wt.eu-S1759364AbZDBOOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759364AbZDBOOU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 10:14:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757436AbZDBOOA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 10:14:00 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:46266 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757344AbZDBON7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 10:13:59 -0400
Date: Thu, 2 Apr 2009 22:13:42 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: David Miller <davem@davemloft.net>
Cc: dada1@cosmosbay.com, jarkao2@gmail.com, vernux@us.ibm.com,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
Subject: Re: High contention on the sk_buff_head.lock
Message-ID: <20090402141342.GA377@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090323.013749.122944803.davem@davemloft.net>
Organization: Core
X-Newsgroups: apana.lists.os.linux.kernel,apana.lists.os.linux.netdev
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> wrote:
> From: Eric Dumazet <dada1@cosmosbay.com>
> Date: Mon, 23 Mar 2009 09:32:39 +0100
> 
>> I dont understand, doesnt it defeat the ticket spinlock thing and fairness ?
>> 
>> Thread doing __qdisc_run() already owns the __QDISC_STATE_RUNNING bit.
> 
> Right.
> 
> Remember, the way this is designed is that if there is a busy
> cpu taking packets out of the queue and putting them into the
> device then other cpus will simply add to the queue and immediately
> return.  This effectively keeps the queue running there processing
> all the new work that other cpus are adding to the qdisc.
> 
> Those other cpus make these decisions by looking at that
> __QDISC_STATE_RUNNING bit, which the queue runner grabs before
> it does any work.

Come on guys, if this lock is a problem. go out and buy a proper
NIC that supports multiequeue TX!

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
