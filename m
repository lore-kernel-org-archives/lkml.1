Return-Path: <linux-kernel-owner+w=401wt.eu-S1765409AbYEVIUk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765409AbYEVIUk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 04:20:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760314AbYEVIUT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 04:20:19 -0400
Received: from ozlabs.org ([203.10.76.45]:51644 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759154AbYEVIUQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 04:20:16 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Subject: Re: initialization of static per-cpu variables
Date: Thu, 22 May 2008 18:20:06 +1000
User-Agent: KMail/1.9.9
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       David Miller <davem@davemloft.net>
References: <19f34abd0805211128r29fa437fm9e9e4c3d3c196f62@mail.gmail.com>
In-Reply-To: <19f34abd0805211128r29fa437fm9e9e4c3d3c196f62@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805221820.07290.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 22 May 2008 04:28:02 Vegard Nossum wrote:
> Hi,
>
> I encountered this comment in kernel/softirq.c:
>
> /* Some compilers disobey section attribute on statics when not
>    initialized -- RR */
> static DEFINE_PER_CPU(struct tasklet_head, tasklet_vec) = { NULL };
> static DEFINE_PER_CPU(struct tasklet_head, tasklet_hi_vec) = { NULL };
>
> So I assume it's the combination of static and whatever section
> DFINE_PER_CPU puts the variable in which is the problem.
>
> However, there's a LOT of these "static DEFINE_PER_CPU" without any
> initializer in the rest of the code, e.g.:

Yep, it was an old toolchain used by Sparc: DaveM found this one.  As you say, 
it's ancient: I'm happy to queue a cleanup patch now everyone is on a modern 
compiler.

Thanks,
Rusty.
