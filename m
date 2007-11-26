Return-Path: <linux-kernel-owner+w=401wt.eu-S1755506AbXKZOng@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506AbXKZOng (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 09:43:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753095AbXKZOn3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 09:43:29 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:35938 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751401AbXKZOn3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 09:43:29 -0500
Date: Mon, 26 Nov 2007 17:43:42 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] fix setsid() for sub-namespace /sbin/init
Message-ID: <20071126144342.GA17265@tv-sign.ru>
References: <20071126142553.GA16525@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20071126142553.GA16525@tv-sign.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26, Oleg Nesterov wrote:
>
> sys_setsid() still deals with pid_t's from the global namespace. This means
> that the "session > 1" check can't help for sub-namespace init, setsid() can't
> succeed because copy_process(CLONE_NEWPID) populates PIDTYPE_PGID/SID links.
> 
> Remove the usage of task_struct->pid and convert the code to use "struct pid".
> This also simplifies and speedups the code, saves one find_pid().

Паша, глянь пжалста. Я не думаю, что это нужно для 2.6.24, bug (если я еще раз
не ошибся и он есть) очень мелкий, но все-таки...

Вопрос. вот у нас есть task_struct *p = find_task_by_vpid(pid), почему у нас нет
хелпера получить его pid_t ? task_pid_vnr() вернет не то, что нужно (что уже не
очень хорошо с точки зрения именования ;), и мы должны делать

	task_pid_nr_ns(p, current->nsproxy->pid_ns);

УЖОС!!! :-(

Oleg.

