Return-Path: <linux-kernel-owner+w=401wt.eu-S1758721AbXIBCyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758721AbXIBCyV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 22:54:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754417AbXIBCyJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 22:54:09 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:39553 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753165AbXIBCyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 22:54:08 -0400
Date: Sat, 1 Sep 2007 20:54:07 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: akpm@osdl.org, torvalds@osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] Use macros instead of TASK_ flags
Message-ID: <20070902025407.GK14130@parisc-linux.org>
References: <20070902024348.GJ14130@parisc-linux.org> <11887012142333-git-send-email-matthew@wil.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11887012142333-git-send-email-matthew@wil.cx>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 01, 2007 at 10:46:51PM -0400, Matthew Wilcox wrote:
> Abstracting away direct uses of TASK_ flags allows us to change the
> definitions of the task flags more easily.
> --- a/kernel/exit.c
> +++ b/kernel/exit.c
> @@ -259,7 +259,7 @@ static int has_stopped_jobs(struct pid *pgrp)
>  	struct task_struct *p;
>  
>  	do_each_pid_task(pgrp, PIDTYPE_PGID, p) {
> -		if (p->state != TASK_STOPPED)
> +		if (is_task_stopped(p))

Funny how I can't spot these things before I send them.

Fixed locally; I'll see if anyone else spots a problem before I send out
a v3.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
