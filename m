Return-Path: <linux-kernel-owner+w=401wt.eu-S1756179AbXIQQWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756179AbXIQQWt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 12:22:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752041AbXIQQWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 12:22:39 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:43227 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751945AbXIQQWi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 12:22:38 -0400
Date: Mon, 17 Sep 2007 20:26:27 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Guillaume Chazarain <guichaz@yahoo.fr>
Cc: akpm@linux-foundation.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       balbir@in.ibm.com, jlan@engr.sgi.com, jlim@sgi.com
Subject: Re: + taskstats-add-all-thread-stats-for-taskstats_cmd_attr_tgid.patch added to -mm tree
Message-ID: <20070917162627.GB1398@tv-sign.ru>
References: <200709130018.l8D0IgHl026136@imap1.linux-foundation.org> <20070913124141.GA2673@tv-sign.ru> <20070915205124.4ccac9a9@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070915205124.4ccac9a9@localhost.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/15, Guillaume Chazarain wrote:
>
> Le Thu, 13 Sep 2007 16:41:41 +0400,
> Oleg Nesterov <oleg@tv-sign.ru> a ??crit :
> 
> > > +	do
> > > +		if (!tsk->exit_state)
> > > +			add_tsk(stats, tsk);
> > > +	while_each_thread(first, tsk);
> > 
> > This reminds me. The "!tsk->exit_state" is not good and racy, it
> > can't prevent the double accounting (of course, I don't blame this
> > patch).
> 
> I documented this in v4, but I was wondering if always setting
> tsk->exit_state under the protection of lock_task_sighand() would fix
> the race.

No, this is not enough. There is a window between do_exit()->taskstats_exit()
and do_exit()->exit_notify() which sets ->exit_state. Probably, we can
shift taskstats_exit() into exit_notify() but this is not good.

Oleg.

