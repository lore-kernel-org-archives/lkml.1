Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357Ab0CHTIQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 14:08:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55469 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753798Ab0CHTID (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 14:08:03 -0500
Date: Mon, 8 Mar 2010 20:06:07 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, sivanich@sgi.com,
       heiko.carstens@de.ibm.com, torvalds@linux-foundation.org, mingo@elte.hu,
       peterz@infradead.org, dipankar@in.ibm.com, josh@freedesktop.org,
       paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org
Subject: Re: [PATCH 2/4] stop_machine: reimplement using cpuhog
Message-ID: <20100308190606.GB9149@redhat.com>
References: <1268063603-7425-1-git-send-email-tj@kernel.org> <1268063603-7425-3-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268063603-7425-3-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09, Tejun Heo wrote:
>
>  int __stop_machine(int (*fn)(void *), void *data, const struct cpumask *cpus)
>  {
> ...
> +	/* Set the initial state and hog all online cpus. */
> +	set_state(&smdata, STOPMACHINE_PREPARE);
> +	return hog_cpus(cpu_online_mask, stop_cpu, &smdata);
>  }

Could you please confirm this is correct?

I am not sure I understand how the code looks with the patch applied,
but the lockless set_state() above can confuse another stop_machine()
in progress?

Oleg.

