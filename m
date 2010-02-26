Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965369Ab0BZQjR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 11:39:17 -0500
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:44857 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965310Ab0BZQjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 11:39:16 -0500
Date: Fri, 26 Feb 2010 10:39:12 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] mm: Remove ZERO_SIZE_PTR.
In-Reply-To: <201002260635.o1Q6ZYET040848@www262.sakura.ne.jp>
Message-ID: <alpine.DEB.2.00.1002261009320.7719@router.home>
References: <201002260635.o1Q6ZYET040848@www262.sakura.ne.jp>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Feb 2010, Tetsuo Handa wrote:

> Everybody should check for ptr != NULL, and most callers are actually checking
> for ptr != NULL. But nobody is checking for ptr != ZERO_SIZE_PTR.

That is so intentionally because some kernel subsystem can do a zero size
allocation.

> If caller passed 0 as size argument by error (e.g. integer overflow bug),
> the caller will start writing against address starting from ZERO_SIZE_PTR
> because the caller assumes that "size + sizeof(struct foo)" bytes of memory is
> successfully allocated. (kstrdup() is an example, although it will be
> impossible to pass s where strlen(s) == (size_t) -1 .)

Therefore you will get a NULL deference error since ZERO_SIZE_PTR points
to the NULL page.

> Yes, this is the fault of caller. But ZERO_SIZE_PTR is too small value to
> distinguish "NULL pointer dereference" and "ZERO_SIZE_PTR dereference" because
> address printed by oops message can easily exceed ZERO_SIZE_PTR when
> "struct foo" is large.

Correct.

But you can check for <= ZERO_SIZE_PTR to check for NULL or ZERO_SIZE_PTR
in the same comparison if necessary.


