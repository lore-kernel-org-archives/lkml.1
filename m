Return-Path: <linux-kernel-owner+w=401wt.eu-S1761457AbXK1Xka@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761457AbXK1Xka (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 18:40:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757547AbXK1XkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 18:40:20 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:33694 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756843AbXK1XkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 18:40:18 -0500
Message-ID: <474DFC4B.5060006@us.ibm.com>
Date: Wed, 28 Nov 2007 15:39:55 -0800
From: David Wilder <dwilder@us.ibm.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070301)
MIME-Version: 1.0
To: Roland McGrath <roland@redhat.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 20/27] ptrace: arch_has_block_step
References: <20071125215507.4B89226F8C5@magilla.localdomain> <20071125220552.C8D5126F8C5@magilla.localdomain>
In-Reply-To: <20071125220552.C8D5126F8C5@magilla.localdomain>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roland McGrath wrote:
<snip>
> 
> +#ifndef arch_has_block_step
> +/**
> + * arch_has_block_step - does this CPU support user-mode block-step?
> + *
> + * If this is defined, then there must be a function declaration or inline
> + * for user_enable_block_step(), and arch_has_single_step() must be defined
> + * too.  arch_has_block_step() should evaluate to nonzero iff the machine
> + * supports step-until-branch for user mode.  It can be a constant or it
> + * can test a CPU feature bit.
> + */
> +#define arch_has_single_step()		(0)

should this be #define arch_has_block_step()		(0)

> +
> +/**
> + * user_enable_block_step - step until branch in user-mode task
> + * @task: either current or a task stopped in %TASK_TRACED
> + *
> + * This can only be called when arch_has_block_step() has returned nonzero,
> + * and will never be called when single-instruction stepping is being used.
> + * Set @task so that when it returns to user mode, it will trap after the
> + * next branch or trap taken.
> + */
> +static inline void user_enable_block_step(struct task_struct *task)
> +{
> +	BUG();			/* This can never be called.  */
> +}
> +#endif	/* arch_has_block_step */
> +
<snip>
