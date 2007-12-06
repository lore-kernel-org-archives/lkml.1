Return-Path: <linux-kernel-owner+w=401wt.eu-S1753541AbXLFRBL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541AbXLFRBL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 12:01:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752339AbXLFRA6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 12:00:58 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:44707 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751399AbXLFRA5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 12:00:57 -0500
Date: Thu, 6 Dec 2007 20:01:45 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Linux Containers <containers@lists.osdl.org>,
       Pavel Emelyanov <xemul@openvz.org>, sukadev@us.ibm.com
Subject: Re: [PATCH] pid: sys_wait... fixes
Message-ID: <20071206170145.GA10674@tv-sign.ru>
References: <m17ijsv7iu.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m17ijsv7iu.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05, Eric W. Biederman wrote:
> 
> This modifies do_wait and eligible_child to take a pair of
> enum pid_type and struct pid *pid to precisely specify what
> set of processes are eligible to be waited for,  instead of the
> raw pid_t value from sys_wait4.

Personally, I like this patch very much. Not only it fixes the bug,
in my opinion it also makes the code more clean.

However at first glance it has a minor fixable problem,

> +	if (type < PIDTYPE_MAX) {
> +		if (p->pids[type].pid != pid)
>  			return 0;
>  	}

If type != PIDTYPE_PID we can't trust p->pids[type].pid unless p is a
group leader. This .pid could be just a "random value".

Oleg.

