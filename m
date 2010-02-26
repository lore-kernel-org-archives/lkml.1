Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935363Ab0BZG7K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 01:59:10 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:36115 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935340Ab0BZG7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 01:59:09 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: Re: [RFC][PATCH] mm: Remove ZERO_SIZE_PTR.
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org
In-Reply-To: <201002260635.o1Q6ZYET040848@www262.sakura.ne.jp>
References: <201002260635.o1Q6ZYET040848@www262.sakura.ne.jp>
Message-Id: <20100226155618.8D9E.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 26 Feb 2010 15:59:03 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> [RFC][PATCH] mm: Remove ZERO_SIZE_PTR.
> 
> kmalloc() and friends are sometimes used in a way
> 
> 	struct foo *ptr = kmalloc(size + sizeof(struct foo), GFP_KERNEL);
> 	if (!ptr)
> 		return -ENOMEM;
> 	ptr->size = size;
> 	...
> 	return 0;
> 
> Everybody should check for ptr != NULL, and most callers are actually checking
> for ptr != NULL. But nobody is checking for ptr != ZERO_SIZE_PTR.
> 
> If caller passed 0 as size argument by error (e.g. integer overflow bug),
> the caller will start writing against address starting from ZERO_SIZE_PTR
> because the caller assumes that "size + sizeof(struct foo)" bytes of memory is
> successfully allocated. (kstrdup() is an example, although it will be
> impossible to pass s where strlen(s) == (size_t) -1 .)
> 
> Yes, this is the fault of caller. But ZERO_SIZE_PTR is too small value to
> distinguish "NULL pointer dereference" and "ZERO_SIZE_PTR dereference" because
> address printed by oops message can easily exceed ZERO_SIZE_PTR when
> "struct foo" is large.
> 
> Therefore, at the cost of being unable to distinguish "NULL pointer
> dereference" and "ZERO_SIZE_PTR dereference" in some cases, removing
> ZERO_SIZE_PTR could reduce the risk of "ZERO_SIZE_PTR dereference" in many
> cases.

NAK. yes, it could. but it is no worth. nobody want slower kernel.



