Return-Path: <linux-kernel-owner+w=401wt.eu-S1756756AbYECXkg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756756AbYECXkg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 19:40:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754990AbYECXk3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 19:40:29 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46971
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754988AbYECXk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 19:40:28 -0400
Date: Sat, 03 May 2008 16:40:24 -0700 (PDT)
Message-Id: <20080503.164024.265682957.davem@davemloft.net>
To: mingo@elte.hu
Cc: benh@kernel.crashing.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       elendil@planet.nl, parag.warudkar@gmail.com,
       linux-kernel@vger.kernel.org, guichaz@yahoo.fr, andi@firstfloor.org
Subject: Re: 'global' rq->clock
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080503233825.GB30600@elte.hu>
References: <20080503.160408.238581868.davem@davemloft.net>
	<20080503.163600.93588714.davem@davemloft.net>
	<20080503233825.GB30600@elte.hu>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Sun, 4 May 2008 01:38:25 +0200

> ah, good! It really looks like unnecessary overhead for the "simple 
> IPIs". But ... i'm wondering ... what about softirq processing? Do these 
> IPIs process softirqs on the way out? In that case the non-processed 
> jiffies might be a problem.
> 
> it's all a bit messy. I wish we could start turning jiffies into a 
> function (which would just read GTOD and estimate jiffies from there), 
> but i fear we are not there yet ...

I think Peter Z. made a good point that we probably need to
keep it there for smp_call_function() receivers, so that
the called functions can test the context they are in accurately.
