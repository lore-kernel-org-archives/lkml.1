Return-Path: <linux-kernel-owner+w=401wt.eu-S1753533AbYKZLwA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533AbYKZLwA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 06:52:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752249AbYKZLvu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 06:51:50 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36766 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752218AbYKZLvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 06:51:49 -0500
Date: Wed, 26 Nov 2008 13:02:15 +0100
From: Andi Kleen <andi@firstfloor.org>
To: eranian@googlemail.com
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       x86@kernel.org, andi@firstfloor.org, eranian@gmail.com,
       sfr@canb.auug.org.au
Subject: Re: [patch 20/24] perfmon: system calls interface
Message-ID: <20081126120215.GU6703@one.firstfloor.org>
References: <492d0c0b.170e660a.15ba.ffffdabf@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <492d0c0b.170e660a.15ba.ffffdabf@mx.google.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +static int pfm_task_incompatible(struct pfm_context *ctx,
> +				 struct task_struct *task)
> +{
> +	/*
> +	 * cannot attach to a kernel thread
> +	 */
> +	if (!task->mm) {
> +		PFM_DBG("cannot attach to kernel thread [%d]", task->pid);
> +		return -EPERM;
> +	}

Check for init_mm too?

> +
> +	/*
> +	 * cannot attach to a zombie task
> +	 */
> +	if (task->exit_state == EXIT_ZOMBIE || task->exit_state == EXIT_DEAD) {
> +		PFM_DBG("cannot attach to zombie/dead task [%d]", task->pid);
> +		return -EBUSY;
> +	}

This happens unlocked doesn't it? Couldn't the state change in parallel?

-Andi
-- 
ak@linux.intel.com
