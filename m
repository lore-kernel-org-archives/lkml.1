Return-Path: <linux-kernel-owner+w=401wt.eu-S1757940AbYDGN51@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757940AbYDGN51 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 09:57:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758790AbYDGN5D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 09:57:03 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:51426 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758767AbYDGN5A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 09:57:00 -0400
To: dwalker@mvista.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, takedakn@nttdata.co.jp,
       haradats@nttdata.co.jp, linux-fsdevel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [TOMOYO #7 30/30] Hooks for SAKURA and TOMOYO.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20080404122242.867070732@I-love.SAKURA.ne.jp><20080404122408.986477936@I-love.SAKURA.ne.jp><1207326576.21308.71.camel@localhost.localdomain>
In-Reply-To: <1207326576.21308.71.camel@localhost.localdomain>
Message-Id: <200804072256.IFJ17170.QFOJFHtLSOOVFM@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Mon, 7 Apr 2008 22:56:58 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Walker wrote:
> From a reviews perspective what I would want is each set of changes,
> file system, networking, arch, etc split into separate patches. For
> example you have a number of patches just adding header files. You could
> merge the header file with the hook additions. Then you have a natural
> code split up which should be easier to review..
Filesystem part to fsdevel, socket operation part to netdev. That's OK.
But I wonder where to post the rest part.
Since the patches for passing "struct vfsmount" to LSM has been rejected,
TOMOYO has been unable to use LSM.
Thus, I proposed this patch set as a non-LSM version, but it bothers me
where to post this patch. If you know, please teach me where to post.

> > --- linux-2.6.25-rc8-mm1.orig/include/linux/init_task.h
> > +++ linux-2.6.25-rc8-mm1/include/linux/init_task.h
> > @@ -197,6 +197,10 @@ extern struct group_info init_groups;
> >  	INIT_IDS							\
> >  	INIT_TRACE_IRQFLAGS						\
> >  	INIT_LOCKDEP							\
> > +	/***** TOMOYO Linux start. *****/        \
> > +	.domain_info = &KERNEL_DOMAIN,           \
> > +	.tomoyo_flags = 0,                       \
> > +	/***** TOMOYO Linux end. *****/          \
> >  }
> 
> ifdef's ?

Or security_initcall()?

> > @@ -1278,6 +1283,10 @@ struct task_struct {
> >  	int latency_record_count;
> >  	struct latency_record latency_record[LT_SAVECOUNT];
> >  #endif
> > +	/***** TOMOYO Linux start. *****/
> > +	struct domain_info *domain_info;
> > +	u32 tomoyo_flags;
> > +	/***** TOMOYO Linux end. *****/
> >  };
> 
> ifdefs? 
>
I see.

Thank you.
