Return-Path: <linux-kernel-owner+w=401wt.eu-S1756446AbZLNCPi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756446AbZLNCPi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 21:15:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755162AbZLNCPi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 21:15:38 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:63601 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903AbZLNCPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 21:15:37 -0500
Message-Id: <200912140215.nBE2FMRk085925@www262.sakura.ne.jp>
Subject: Re: [PATCH] fix tasklist + find_pid() with CONFIG_PREEMPT_RCU
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Mon, 14 Dec 2009 11:15:22 +0900
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: K-Prox Anti-Virus Powered by Kaspersky, bases: 13122009 #3125530, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Below change (found at http://lkml.org/lkml/2008/1/30/1 ) is not yet applied
as of 2.6.32-git10 . Any reason not to apply?

> diff --git a/include/linux/pid.h b/include/linux/pid.h
> index e29a900..0ffb8cc 100644
> --- a/include/linux/pid.h
> +++ b/include/linux/pid.h
> @@ -100,8 +100,7 @@ struct pid_namespace;
>  extern struct pid_namespace init_pid_ns;
> 
>  /*
> - * look up a PID in the hash table. Must be called with the tasklist_lock
> - * or rcu_read_lock() held.
> + * look up a PID in the hash table. Must be called with the rcu_read_lock() held.
>   *
>   * find_pid_ns() finds the pid in the namespace specified
>   * find_pid() find the pid by its global id, i.e. in the init namespace
