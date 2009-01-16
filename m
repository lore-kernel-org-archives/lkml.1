Return-Path: <linux-kernel-owner+w=401wt.eu-S937807AbZAPWWf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937807AbZAPWWf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 17:22:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761082AbZAPWWU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 17:22:20 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47677 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761022AbZAPWWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 17:22:20 -0500
Date: Fri, 16 Jan 2009 14:21:50 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: ebiederm@xmission.com, xemul@openvz.org, sukadev@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] pids: refactor vnr/nr_ns helpers to make them safe
Message-Id: <20090116142150.7100c1da.akpm@linux-foundation.org>
In-Reply-To: <20090116055520.GA28131@redhat.com>
References: <20090116055520.GA28131@redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Jan 2009 06:55:20 +0100
Oleg Nesterov <oleg@redhat.com> wrote:

> --- CUR/include/linux/sched.h~SP_3_NR	2009-01-16 02:13:50.000000000 +0100
> +++ CUR/include/linux/sched.h	2009-01-16 04:16:12.000000000 +0100
> @@ -1481,17 +1481,23 @@ struct pid_namespace;
>   *
>   * see also pid_nr() etc in include/linux/pid.h
>   */
> +pid_t __task_pid_nr_ns(struct task_struct *task, enum pid_type type,
> +			struct pid_namespace *ns);

Sometime it would be nice to pull all the pid-related helpers out of
sched.h, into a dedicated header file which is included only by those
.c files which actually use them.

