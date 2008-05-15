Return-Path: <linux-kernel-owner+w=401wt.eu-S1753972AbYEOF3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972AbYEOF3S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 01:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751786AbYEOF3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 01:29:05 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42409
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751020AbYEOF3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 01:29:03 -0400
Date: Wed, 14 May 2008 22:28:57 -0700 (PDT)
Message-Id: <20080514.222857.246967279.davem@davemloft.net>
To: rostedt@goodmis.org
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, pq@iki.fi, proski@gnu.org,
       sandmann@redhat.com, a.p.zijlstra@chello.nl, linuxppc-dev@ozlabs.org,
       paulus@samba.org, benh@kernel.crashing.org, srostedt@redhat.com
Subject: Re: [PATCH 2/2] ftrace: support for PowerPC
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080515035918.896765954@goodmis.org>
References: <20080515034942.109223655@goodmis.org>
	<20080515035918.896765954@goodmis.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>
Date: Wed, 14 May 2008 23:49:44 -0400

> +#ifdef CONFIG_FTRACE
> +#ifdef CONFIG_DYNAMIC_FTRACE
> +_GLOBAL(mcount)
> +_GLOBAL(_mcount)
> +	stwu	r1,-48(r1)
> +	stw	r3, 12(r1)
> +	stw	r4, 16(r1)
> +	stw	r5, 20(r1)
> +	stw	r6, 24(r1)
> +	mflr	r3
> +	stw	r7, 28(r1)
> +	mfcr	r5
> +	stw	r8, 32(r1)
> +	stw	r9, 36(r1)
> +	stw	r10,40(r1)
> +	stw	r3, 44(r1)
> +	stw	r5, 8(r1)

Yikes, that's really expensive.

Can't you do a tail call and let the function you end
up calling do all the callee-saved register pops onto
the stack?

That's what I did on sparc.
