Return-Path: <linux-kernel-owner+w=401wt.eu-S1755767AbXKZUSy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755767AbXKZUSy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 15:18:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753894AbXKZUSr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 15:18:47 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:52731 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751596AbXKZUSr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 15:18:47 -0500
Date: Mon, 26 Nov 2007 23:17:57 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] teach set_special_pids() to use struct pid
Message-ID: <20071126201757.GB84@tv-sign.ru>
References: <20071126142555.GA16528@tv-sign.ru> <m18x4kon6i.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m18x4kon6i.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26, Eric W. Biederman wrote:
>
> Oleg Nesterov <oleg@tv-sign.ru> writes:
> 
> > -	set_special_pids(1, 1);
> > +	if (current->nsproxy != &init_nsproxy) {
> > +		get_nsproxy(&init_nsproxy);
> > +		switch_task_namespaces(current, &init_nsproxy);
> > +	}
> 
> Is there a reason for moving this hunk of code?
> 
> I don't see one as set_special_pids does everything with either
> struct pid or global pid values.  And attach_pid and detach_pid
> don't care.

No particular reason, except "keep related code together".

There was another minor reason. Without the next patch we are doing find_pid(1).
This is correct, we scan the global namespace, but still it looks a bit tidier
to switch namespace first, so we could use find_vpid() in unlikely case we need
it.

Oleg.

