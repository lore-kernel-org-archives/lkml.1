Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935596Ab0BZIpJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 03:45:09 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:41801 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935550Ab0BZIpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 03:45:07 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: Re: [RFC][PATCH] mm: Remove ZERO_SIZE_PTR.
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org
In-Reply-To: <201002260838.o1Q8cfr2068194@www262.sakura.ne.jp>
References: <20100226155618.8D9E.A69D9226@jp.fujitsu.com> <201002260838.o1Q8cfr2068194@www262.sakura.ne.jp>
Message-Id: <20100226174131.8DA9.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 26 Feb 2010 17:44:55 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> KOSAKI Motohiro wrote:
> > > Therefore, at the cost of being unable to distinguish "NULL pointer
> > > dereference" and "ZERO_SIZE_PTR dereference" in some cases, removing
> > > ZERO_SIZE_PTR could reduce the risk of "ZERO_SIZE_PTR dereference" in many
> > > cases.
> > 
> > NAK. yes, it could. but it is no worth. nobody want slower kernel.
> > 
> This patch simplifies error checks of both callers/callees from
> 
> 	((unsigned long)(x) <= (unsigned long) 16)
> 
> to
> 
> 	!(x)
> 
> . Why this patch makes the kernel slower?

You misunderstand your patch's effect. you try to change kmalloc
semantics. currently kmalloc(0) is valid and allowed. but you want
to change invalid. then, we need additional check into the caller of
using kmalloc(0). there is in real world.

IOW, your patch is broken and introduce incompatibility.


