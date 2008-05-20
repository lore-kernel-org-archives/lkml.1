Return-Path: <linux-kernel-owner+w=401wt.eu-S1763566AbYETXwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763566AbYETXwT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 19:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754642AbYETXwL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 19:52:11 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:51467 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753575AbYETXwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 19:52:10 -0400
Date: Tue, 20 May 2008 16:51:38 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Louis Rilling <Louis.Rilling@kerlabs.com>, linux-kernel@vger.kernel.org,
       ocfs2-devel@oss.oracle.com
Subject: Re: [RFC][PATCH 0/3] configfs: Make nested default groups
	lockdep-friendly
Message-ID: <20080520235138.GL26609@mail.oracle.com>
Mail-Followup-To: Arjan van de Ven <arjan@infradead.org>,
	Louis Rilling <Louis.Rilling@kerlabs.com>,
	linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
References: <20080520163320.025971210@kerlabs.com> <20080520095810.1d50d247@infradead.org> <20080520215639.GG26609@mail.oracle.com> <20080520151341.058f2df4@infradead.org> <20080520222702.GJ26609@mail.oracle.com> <20080520153543.4bafcac9@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080520153543.4bafcac9@infradead.org>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
	come to perfection.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2008 at 03:35:43PM -0700, Arjan van de Ven wrote:
> not quite what I meant; what I meant is more like how sched.c deals
> with per cpu queues:
> 
> (from sched.c)
> 
>                 spin_lock_init(&rq->lock);
>                 lockdep_set_class(&rq->lock, &rq->rq_lock_key); 

	Looking at this, it's taking the address of the struct
lock_class_key as the actual key.  Thus, if we tie one of these guys to
the structure we're representing, we get lock safety...except that we're
talking about i_mutex here, and we want to interact with the VFS's use
thereof.

Joel

-- 

"There is no sincerer love than the love of food."  
         - George Bernard Shaw 

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
