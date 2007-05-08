Return-Path: <linux-kernel-owner+w=401wt.eu-S1031841AbXEHUA4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031841AbXEHUA4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 16:00:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031831AbXEHUAw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 16:00:52 -0400
Received: from khc.piap.pl ([195.187.100.11]:44846 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031654AbXEHUAv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 16:00:51 -0400
To: David Rientjes <rientjes@google.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Sokolovsky <pmiscml@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH] doc: volatile considered evil
References: <516386418.20070501080839@gmail.com>
	<20070430235642.e576e917.akpm@linux-foundation.org>
	<20070508121404.17bd97a6.randy.dunlap@oracle.com>
	<alpine.DEB.0.99.0705081217180.12908@chino.kir.corp.google.com>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Tue, 08 May 2007 22:00:49 +0200
In-Reply-To: <alpine.DEB.0.99.0705081217180.12908@chino.kir.corp.google.com> (David Rientjes's message of "Tue, 8 May 2007 12:18:33 -0700 (PDT)")
Message-ID: <m3k5vj2iha.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Rientjes <rientjes@google.com> writes:

> Since 'volatile' has two different semantics depending on the context in 
> which it is used, this warning should be appended to include the fact that 
> it is legitimate to use for inline assembly.

I think it hasn't two semantics, it's like arguing that char has two
semantics.

Volatile does one thing - prohibits C compiler from optimizing
accesses to the variable. Either with (volatile *) casts and with
volatile var;

Linus is right in that volatile != direct access to the hardware
and direct sync between all CPUs. Yes, most uses in high level code
are probably bugs. OTOH, there are other uses where optimizing must
be prohibited. It doesn't matter which form
is used, in fact
	volatile type name;
	name
is equivalent to:
	type name;
	*(volatile type *)&name;
At least as long as "volatile" keyword is concerned.
-- 
Krzysztof Halasa
