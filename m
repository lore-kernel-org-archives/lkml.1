Return-Path: <linux-kernel-owner+w=401wt.eu-S1763353AbXLTMRP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763353AbXLTMRP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 07:17:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763299AbXLTMNm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 07:13:42 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43426
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1763168AbXLTMNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 07:13:40 -0500
Date: Thu, 20 Dec 2007 04:13:39 -0800 (PST)
Message-Id: <20071220.041339.197739349.davem@davemloft.net>
To: herbert@gondor.apana.org.au
Cc: dada1@cosmosbay.com, kuznet@ms2.inr.ac.ru, wangchen@cn.fujitsu.com,
       gerrit@erg.abdn.ac.uk, andi@firstfloor.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, clameter@sgi.com, mingo@elte.hu
Subject: Re: [SNMP]: Fix SNMP counters with PREEMPT
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071216023025.GA959@gondor.apana.org.au>
References: <20071215135851.GA29063@gondor.apana.org.au>
	<476408D7.50205@cosmosbay.com>
	<20071216023025.GA959@gondor.apana.org.au>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Sun, 16 Dec 2007 10:30:25 +0800

> On Sat, Dec 15, 2007 at 06:03:19PM +0100, Eric Dumazet wrote:
> >
> > How come you change SNMP_INC_STATS_USER() but not SNMP_INC_STATS() ?
> 
> Heh, my brain must have blocked me from seeing it because it's
> too hard :)
> 
> Let's fix it the stupid way first and I'll do a local_t conversion
> later.
> 
> [SNMP]: Fix SNMP counters with PREEMPT
> 
> The SNMP macros use raw_smp_processor_id() in process context
> which is illegal because the process may be preempted and then
> migrated to another CPU.
> 
> This patch makes it use get_cpu/put_cpu to disable preemption.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

I just noticed this and replaced the other SNMP fix patch
with this one.
