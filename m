Return-Path: <linux-kernel-owner+w=401wt.eu-S1755196AbYECXEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196AbYECXEV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 19:04:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752996AbYECXEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 19:04:10 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57740
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752597AbYECXEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 19:04:09 -0400
Date: Sat, 03 May 2008 16:04:08 -0700 (PDT)
Message-Id: <20080503.160408.238581868.davem@davemloft.net>
To: mingo@elte.hu
Cc: benh@kernel.crashing.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       elendil@planet.nl, parag.warudkar@gmail.com,
       linux-kernel@vger.kernel.org, guichaz@yahoo.fr, andi@firstfloor.org
Subject: Re: 'global' rq->clock
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080503223844.GA18344@elte.hu>
References: <20080503.122734.01023096.davem@davemloft.net>
	<1209853855.26383.28.camel@pasglop>
	<20080503223844.GA18344@elte.hu>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Sun, 4 May 2008 00:38:44 +0200

> the same bug existed on x86 too: that too does a few IPIs without 
> irq_enter/irq_exit. We now removed the softlockup dependency so it 
> should not be required to do an irq_enter()/exit anymore - unless the 
> code that the IPI uses accesses jiffies. (but that would be unusual)

That move doesn't solve the problem, I'm strongly certain
arch's still need to add the irq_{enter,exit}().

I'll revert the irq_{enter,exit}() changes on one of my
sparc64 boxes to validate this later today.
