Return-Path: <linux-kernel-owner+w=401wt.eu-S1758064AbYG3Le4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758064AbYG3Le4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 07:34:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752756AbYG3Let
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 07:34:49 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56127
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752753AbYG3Les (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 07:34:48 -0400
Date: Wed, 30 Jul 2008 04:34:48 -0700 (PDT)
Message-Id: <20080730.043448.217891740.davem@davemloft.net>
To: peterz@infradead.org
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lockdep: change scheduler annotation
From: David Miller <davem@davemloft.net>
In-Reply-To: <1217417217.8157.23.camel@twins>
References: <20080728.174415.154327359.davem@davemloft.net>
	<20080729.214503.126934382.davem@davemloft.net>
	<1217417217.8157.23.camel@twins>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>
Date: Wed, 30 Jul 2008 13:26:57 +0200

> While thinking about David's patch it _finally_ dawned on me that there
> is no reason we have a lock class per cpu..
> 
> Sorry for being dense :-/
> 
> The below changes the annotation from a lock class per cpu, to a single
> nested lock, as the scheduler never holds more that 2 rq locks at a time
> anyway.
> 
> If there was code requiring holding all rq locks this would not work and
> the original annotation would be the only option, but that not being the
> case, this is a much lighter one.
> 
> Compiles and boots on a 2-way x86_64.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

I had been wondering this entire debugging session why the
per-rq lock classes were even there, thanks for getting
rid of them :)
