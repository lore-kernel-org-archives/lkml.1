Return-Path: <linux-kernel-owner+w=401wt.eu-S1762501AbXIZU56@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762501AbXIZU56 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 16:57:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759039AbXIZU5v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 16:57:51 -0400
Received: from smtp3-g19.free.fr ([212.27.42.29]:47632 "EHLO smtp3-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759017AbXIZU5u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 16:57:50 -0400
Date: Wed, 26 Sep 2007 22:55:38 +0200
From: Guillaume Chazarain <guichaz@yahoo.fr>
To: roel <12o3l@tiscali.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/8] taskstats: fix stats->ac_exitcode to work on
 threads and use group_exit_code
Message-ID: <20070926225538.1dbbe42e@localhost.localdomain>
In-Reply-To: <46FAC57A.3090309@tiscali.nl>
References: <20070926162800.29434.67786.stgit@cheypa.inria.fr>
	<20070926162831.29434.29622.stgit@cheypa.inria.fr>
	<46FAC57A.3090309@tiscali.nl>
X-Mailer: Claws Mail 3.0.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Le Wed, 26 Sep 2007 22:47:54 +0200,
roel <12o3l@tiscali.nl> a écrit :

> > +	if (thread_group_leader(tsk) && ((tsk->flags & PF_FORKNOEXEC)))
> 
> 	if (thread_group_leader(tsk) && (tsk->flags & PF_FORKNOEXEC))

Yeah, right, good catch.

> > +	group_exit_code = tg_stats ? tsk->signal->group_exit_code : 0;
> > +	stats->ac_exitcode = group_exit_code ? : tsk->exit_code;
> 
> Isn't this just confusing? why not
> 
> 	if (tg_stats) {
> 		group_exit_code = tsk->signal->group_exit_code;
> 		stats->ac_exitcode = group_exit_code;

Because in this case if group_exit_code is null, we want
tsk->exit_code, not 0.

> 		
> 	} else {
> 		group_exit_code = 0;
> 		stats->ac_exitcode = tsk->exit_code;
> 	}

Andrew is not interested at the moment in this series (that replaces
all my previous patches on taskstats, for info), but thank you for the
review.


-- 
Guillaume
