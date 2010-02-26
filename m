Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965683Ab0BZSXL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 13:23:11 -0500
Received: from taverner.CS.Berkeley.EDU ([128.32.153.193]:46901 "EHLO
	taverner.cs.berkeley.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965631Ab0BZSXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 13:23:09 -0500
To: linux-kernel@vger.kernel.org
Path: not-for-mail
From: daw@cs.berkeley.edu (David Wagner)
Newsgroups: isaac.lists.linux-kernel
Subject: Re: [RFC][PATCH] mm: Remove ZERO_SIZE_PTR.
Date: Fri, 26 Feb 2010 18:23:06 +0000 (UTC)
Organization: University of California, Berkeley
Message-ID: <hm93ia$15p$1@taverner.cs.berkeley.edu>
References: <201002260635.o1Q6ZYET040848@www262.sakura.ne.jp> <20100226155618.8D9E.A69D9226@jp.fujitsu.com> <201002260838.o1Q8cfr2068194@www262.sakura.ne.jp>
NNTP-Posting-Host: taverner.cs.berkeley.edu
X-Trace: taverner.cs.berkeley.edu 1267208586 1209 128.32.153.193 (26 Feb 2010 18:23:06 GMT)
X-Complaints-To: news@taverner.cs.berkeley.edu
NNTP-Posting-Date: Fri, 26 Feb 2010 18:23:06 +0000 (UTC)
X-Newsreader: trn 4.0-test76 (Apr 2, 2001)
Originator: daw@taverner.cs.berkeley.edu (David Wagner)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tetsuo Handa  wrote:
>This patch simplifies error checks of both callers/callees from
>
>	((unsigned long)(x) <= (unsigned long) 16)
>
>to
>
>	!(x)

I don't follow.  If you want to avoid integer overflow, the caller
of kmalloc() must check to make sure that the arithmetic operations
it performs do not overflow.  That's true whether or not your patch
is accepted.  An integer overflow in an arithmetic operation can yield
a non-zero value, so checking "!(x)" does not guarantee that there was
no integer overflow involved in the computation of x.
