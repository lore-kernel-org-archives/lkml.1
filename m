Return-Path: <linux-kernel-owner+w=401wt.eu-S1753734AbXCQPA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753734AbXCQPA3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 11:00:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753731AbXCQPA3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 11:00:29 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:18702 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154AbXCQPA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 11:00:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=IlBsry/uJhllUoWCm+i3/ZcvTw1DDfe+yzOsfYz+JdxPNDw97cKOLae/T1K0WFD7awBaTg8z0lElQA03Ajwgc2qC7YIgciCkU5owz9I0NSVAYrvz/dgZg41wByZf+apSlNycvRJahIIbSnUahKWdUf96oSC43Pc7SQwLBpxGs48=
Date: Sat, 17 Mar 2007 17:00:21 +0200
To: hannes-kernel@saeurebad.de
Cc: kernel-janitors@lists.osdl.org, linux-kernel@vger.kernel.org,
       trivial@kernel.org
Subject: Re: [PATCH 2.6.21-rc4] kernel/exit: Fix a comment and code contradiction
Message-ID: <20070317150021.GA3618@Ahmed>
References: <20070317062132.GA11326@Ahmed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070317093856.GB32496@leiferikson>
User-Agent: Mutt/1.5.11
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Johannes please use replay-to-all to notify all readers]

On 2007-03-17 9:45:36 Johannes Weiner wrote:
> On Sat, Mar 17, 2007 at 08:21:32AM +0200, Ahmed S. Darwish wrote:
> > Comment in release_task() claims that group leader's parent process 
> > is signalled only if it desires so, which is not true.
>
> AFAIS, `if it wants notification' means, it does not ignore its children
> via SIG_IGN als handler for SIGCHLD.
>

AFAIK, exit_signal = -1 means that the parent don't want to be signalled,
like what happenes when using CLONE_THREAD. 

But it's even signalled in that case (after issuing a BUG):
   BUG_ON(leader->exit_signal == -1);
   do_notify_parent(leader, leader->exit_signal);

> do_notify_parent() checks if the parent wants to get informed about the
> child states.
>

Yes it does the check but it notifies the given task_struct anyway:

	BUG_ON(sig == -1);
	[ Continue parent notification normally ]
-- 
Ahmed S. Darwish
http://darwish.07.googlepages.com

