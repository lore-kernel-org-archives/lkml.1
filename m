Return-Path: <linux-kernel-owner+w=401wt.eu-S1758290AbZFWXo1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758290AbZFWXo1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 19:44:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751542AbZFWXoT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 19:44:19 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43666 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755125AbZFWXoS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 19:44:18 -0400
Date: Tue, 23 Jun 2009 22:29:37 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Scott James Remnant <scott@canonical.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Matt Helsley <matthltc@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: +
	proc-connector-add-event-for-process-becoming-session-leader.patch
	added to -mm tree
Message-ID: <20090623202937.GA31252@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The act of a process becoming a session leader is a useful signal to a
> supervising init daemon such as Upstart.
...
> @@ -360,8 +360,10 @@ void __set_special_pids(struct pid *pid)
>  {
>  	struct task_struct *curr = current->group_leader;
>
> -	if (task_session(curr) != pid)
> +	if (task_session(curr) != pid) {
>  		change_pid(curr, PIDTYPE_SID, pid);
> +		proc_sid_connector(curr);
> +	}

Wouldn't it better to change sys_setsid() then? This looks more clear
imho, and we can move proc_sid_connector() outside of tasklist_lock.

Note also that __set_special_pids() does not neccessary mean we are
becoming a session leader, see daemonize().

Oleg.

