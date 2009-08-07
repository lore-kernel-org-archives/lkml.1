Return-Path: <linux-kernel-owner+w=401wt.eu-S1756460AbZHGC1N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756460AbZHGC1N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 22:27:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756405AbZHGC1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 22:27:12 -0400
Received: from gate.crashing.org ([63.228.1.57]:50808 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756335AbZHGC1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 22:27:11 -0400
Cc: benh@kernel.crashing.org, paulus@samba.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Message-Id: <FD045DD8-3932-4BA0-9AB9-C2405F601C45@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Julia Lawall <julia@diku.dk>
In-Reply-To: <Pine.LNX.4.64.0908062203380.19100@ask.diku.dk>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v936)
Subject: Re: [PATCH 1/3] arch/powerpc: Add kmalloc NULL tests
Date: Thu, 6 Aug 2009 21:26:59 -0500
References: <Pine.LNX.4.64.0908062203380.19100@ask.diku.dk>
X-Mailer: Apple Mail (2.936)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 6, 2009, at 3:04 PM, Julia Lawall wrote:

> From: Julia Lawall <julia@diku.dk>
>
> Check that the result of kmalloc/kzalloc is not NULL before  
> dereferencing it.
>
> The semantic match that finds this problem is as follows:
> (http://coccinelle.lip6.fr/)
>
> // <smpl>
> @@
> expression *x;
> identifier f;
> constant char *C;
> @@
>
> x = \(kmalloc\|kcalloc\|kzalloc\)(...);
> ... when != x == NULL
>    when != x != NULL
>    when != (x || ...)
> (
> kfree(x)
> |
> f(...,C,...,x,...)
> |
> *f(...,x,...)
> |
> *x->f
> )
> // </smpl>
>
> Signed-off-by: Julia Lawall <julia@diku.dk>
>
> ---
> arch/powerpc/sysdev/fsl_rio.c       |   18 ++++++++++++++----
> 1 files changed, 14 insertions(+), 4 deletions(-)


applied to next

- k
