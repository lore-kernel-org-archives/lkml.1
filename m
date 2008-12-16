Return-Path: <linux-kernel-owner+w=401wt.eu-S1754531AbYLPHNW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531AbYLPHNW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 02:13:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751787AbYLPHNO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 02:13:14 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45249
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751601AbYLPHNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 02:13:13 -0500
Date: Mon, 15 Dec 2008 23:13:14 -0800 (PST)
Message-Id: <20081215.231314.92267481.davem@davemloft.net>
To: rusty@rustcorp.com.au
Cc: rostedt@goodmis.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, mathieu.desnoyers@polymtl.ca,
       paulus@samba.org, benh@kernel.crashing.org
Subject: Re: local_add_return
From: David Miller <davem@davemloft.net>
In-Reply-To: <200812161703.00697.rusty@rustcorp.com.au>
References: <alpine.DEB.1.10.0812150823370.18692@gandalf.stny.rr.com>
	<200812161703.00697.rusty@rustcorp.com.au>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>
Date: Tue, 16 Dec 2008 17:03:00 +1030

> Now, I posted a benchmark patch before for archs to test.  I'm interested
> in Sparc64.

Here ya go:

UltraSPARC-IIIi:

	atomic_long:	local_inc=8180000021/243
			local_add=7469999999/222
			cpu_local_inc=1260000001/37
			local_read=5690000000/169
			(total was 1326071152640)

	irqsave/restore:
			local_inc=6909999997/205
			local_add=6899999996/205
			cpu_local_inc=860000000/25
			local_read=5690000005/169
			(total was 1326071152640)

	trivalue:
			local_inc=6490000000/193
			local_add=6500000000/193
			cpu_local_inc=370000002/11
			local_read=7419999998/221
			(total was 1326071152640)

	local_t:
			local_inc=7440000000/221
			local_add=7440000000/221
			cpu_local_inc=1260000004/37
			local_read=5689999997/169
			(total was 1326071152640, warm_total 34443624448)

Niagara-2:

	atomic_long:
		local_inc=6960000013/207
		local_add=6940000002/206
		cpu_local_inc=2440000002/72
		local_read=5390000000/160
		(total was 1326071152640)

	irqsave/restore:
		local_inc=7660000002/228
		local_add=7669999999/228
		cpu_local_inc=2650000004/78
		local_read=5379999999/160
		(total was 1326071152640)

	trivalue:
		local_inc=5789999998/172
		local_add=5789999995/172
		cpu_local_inc=689999994/20
		local_read=7470000000/222
		(total was 1326071152640)

	local_t:
		local_inc=6940000000/206
		local_add=6950000000/207
		cpu_local_inc=2460000000/73
		local_read=5390000004/160
		(total was 1326071152640, warm_total 34443624448)

