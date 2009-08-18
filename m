Return-Path: <linux-kernel-owner+w=401wt.eu-S1752247AbZHRHen@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752247AbZHRHen (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 03:34:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751144AbZHRHem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 03:34:42 -0400
Received: from one.firstfloor.org ([213.235.205.2]:37390 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847AbZHRHem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 03:34:42 -0400
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] task_struct: stack_canary is not needed without CC_STACKPROTECTOR
From: Andi Kleen <andi@firstfloor.org>
References: <4A8A44CA.2020701@ct.jp.nec.com>
Date: Tue, 18 Aug 2009 09:34:38 +0200
In-Reply-To: <4A8A44CA.2020701@ct.jp.nec.com> (Hiroshi Shimamoto's message of "Tue, 18 Aug 2009 15:06:02 +0900")
Message-ID: <87ws51r2wh.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> writes:

> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
>
> The field stack_canary is only used with CC_STACKPROTECTOR.
> This patch reduces task_struct size without CC_STACKPROTECTOR.

Adding a ifdef in the middle of a widely used structure is nasty.  It
means that if someone changes the option then the newly loaded modules
don't work anymore (yes that's not officially supported, but works
most of the time and is often convenient in practice)

So when you add a ifdef please move the field to the end at least.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
