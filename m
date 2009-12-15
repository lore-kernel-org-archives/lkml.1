Return-Path: <linux-kernel-owner+w=401wt.eu-S1752881AbZLOBjm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881AbZLOBjm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 20:39:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750910AbZLOBjl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 20:39:41 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:51889 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829AbZLOBjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 20:39:40 -0500
Message-Id: <200912150139.nBF1dXYV065691@www262.sakura.ne.jp>
Subject: Re: [PATCH] TOMOYO: Use RCU primitives for list operation
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: serue@us.ibm.com
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Tue, 15 Dec 2009 10:39:33 +0900
References: <200912112253.BCC87030.FLtMOOFOVSQFJH@I-love.SAKURA.ne.jp> <20091214163910.GA8502@us.ibm.com>
In-Reply-To: <20091214163910.GA8502@us.ibm.com>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: K-Prox Anti-Virus Powered by Kaspersky, bases: 15122009 #3129599, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Serge E. Hallyn wrote:
> Just out of curiosity (and bc I'm personally much more familiar with plain old
> rcu), I assume you have a list of places where sleeping under rcu is necessary
> or greatly simplifies/cleans up the code?

Yes.

TOMOYO checks operations which are permitted to sleep so that we can load
policy like call_usermodehelper("/sbin/modprobe"). I tried to use non-sleeping
RCU while implementing garbage collector support. But that attempt resulted in
messing up the code with full of atomic_inc()/atomic_dec() calls.
Thus, I decided to use sleeping RCU.

I tested garbage collector support using sleeping RCU with non-LSM version of
TOMOYO. It is working well. Thus, I started breaking non-LSM version of TOMOYO
into smaller pieces and proposing for LSM version of TOMOYO.

Thank you for reviewing. I'll send next patches.
