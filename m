Return-Path: <linux-kernel-owner+w=401wt.eu-S1757429AbZBKRxP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757429AbZBKRxP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 12:53:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755199AbZBKRw7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 12:52:59 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39369 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754378AbZBKRw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 12:52:59 -0500
Message-ID: <49931067.4090802@kernel.org>
Date: Wed, 11 Feb 2009 09:52:39 -0800
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Brian Gerst <brgerst@gmail.com>
CC: Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] x86: Pass in pt_regs pointer for syscalls that need
 it
References: <1234277507-4987-1-git-send-email-brgerst@gmail.com> <1234277507-4987-3-git-send-email-brgerst@gmail.com>
In-Reply-To: <1234277507-4987-3-git-send-email-brgerst@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Brian Gerst wrote:
>  /*
> + * For syscalls that need a pointer to the pt_regs struct (ie. fork).
> + * The regs pointer is passed in %eax as the first argument.  The
> + * remaining function arguments remain on the stack.
> + */
> +#define ptregscall __attribute__((regparm(1)))

I was looking a few weeks ago (still a work in progress, but I'm pretty
close to having something working) at getting rid of asmlinkage and try
to get everything onto regparm(3).  Adding yet another calling
convention seems to be a step in the wrong direction -- especially since
regparm(1) and (2) are unlikely to have been well exercised and
therefore are likely to attract gcc bugs.

That does *not* mean in any way that I disapprove of the concept of
accessing pt_regs via a pointer... quite on the contrary, I think it's
the only sane thing to do.  I would like to see it done without adding
calling conventions, and preferrably killing some off.

	-hpa

