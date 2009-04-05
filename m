Return-Path: <linux-kernel-owner+w=401wt.eu-S1754538AbZDEMfU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538AbZDEMfU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 08:35:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751369AbZDEMfB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 08:35:01 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:60102 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256AbZDEMfA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 08:35:00 -0400
Message-ID: <49D8A56A.8050606@cosmosbay.com>
Date: Sun, 05 Apr 2009 14:34:50 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@medozas.de>
CC: David Miller <davem@davemloft.net>, graham@gmurray.org.uk,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       netfilter-devel@vger.kernel.org
Subject: Re: Regression caused by commit "netfilter: iptables: lock free counters"
References: <20090329234702.4988017f@desktop.r000n.info> <8763hja8cy.fsf@newton.gmurray.org.uk> <20090405.012237.198610462.davem@davemloft.net> <49D88162.5040809@cosmosbay.com> <alpine.LSU.2.00.0904051328030.7501@fbirervta.pbzchgretzou.qr>
In-Reply-To: <alpine.LSU.2.00.0904051328030.7501@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Sun, 05 Apr 2009 14:34:52 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt a écrit :
> On Sunday 2009-04-05 12:01, Eric Dumazet wrote:
>> This could probably be solved using a single "table" containing
>> rules only, that could be shared for every cpus. Only counters
>> should be percpu. This should save a lot of ram, over previous
>> situation (2.6.29 or current one)
> 
> Why would counters stay separate?
> 
> I recognize all of this table copying is related to do NUMA
> optimizations, and I think I heard cache bouncing too somewhere else.
> 
> [ http://marc.info/?l=netfilter-devel&m=119903624211253&w=2 ]
> 
> 

Not only NUMA, but SMP too. counters are integrated in rules themselves.
So in order to avoid ping pongs between cpus, we choose to allocate
one copy of rules/counters per cpu.

But with some changes, we could let the rules read-only and shared by
all cpus, and shadow counters only on percpu variables, thus reducing
memory costs.


