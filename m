Return-Path: <linux-kernel-owner+w=401wt.eu-S1759704AbZBSTFJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759704AbZBSTFJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 14:05:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758656AbZBSTCm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 14:02:42 -0500
Received: from mx2.redhat.com ([66.187.237.31]:33237 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758648AbZBSTCk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 14:02:40 -0500
Date: Thu, 19 Feb 2009 19:59:54 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@osdl.org>, roland@redhat.com,
       "Eric W. Biederman" <ebiederm@xmission.com>, daniel@hozac.com,
       Containers <containers@lists.osdl.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7][v8] zap_pid_ns_process() should use force_sig()
Message-ID: <20090219185954.GB374@redhat.com>
References: <20090219030207.GA18783@us.ibm.com> <20090219030704.GE18990@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090219030704.GE18990@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18, Sukadev Bhattiprolu wrote:
>
>  	read_lock(&tasklist_lock);
>  	nr = next_pidmap(pid_ns, 1);
>  	while (nr > 0) {
> -		kill_proc_info(SIGKILL, SEND_SIG_PRIV, nr);
> +		rcu_read_lock();
> +
> +		/*
> +		 * Use force_sig() since it clears SIGNAL_UNKILLABLE ensuring
> +		 * any nested-container's init processes don't ignore the
> +		 * signal
> +		 */
> +		task = pid_task(find_vpid(nr), PIDTYPE_PID);
> +		force_sig(SIGKILL, task);

Shouldn't we check task != NULL ?

Oleg.

