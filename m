Return-Path: <linux-kernel-owner+w=401wt.eu-S1754410AbXJJFQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754410AbXJJFQ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 01:16:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751773AbXJJFQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 01:16:19 -0400
Received: from mailbigip.dreamhost.com ([208.97.132.5]:33595 "EHLO
	jankymail-a2.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751574AbXJJFQS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 01:16:18 -0400
Date: Wed, 10 Oct 2007 01:15:23 -0400
From: Gustavo Chain <g@0xff.cl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Reserve N process to root
Message-ID: <20071010011523.7d6cca12@0xff.cl>
In-Reply-To: <470C2FA7.5030207@davidnewall.com>
References: <20071009194820.6c8d6e8d@0xff.cl>
 <470C2FA7.5030207@davidnewall.com>
X-Mailer: Claws Mail 3.0.1 (GTK+ 2.10.14; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

El Wed, 10 Oct 2007 11:19:27 +0930
David Newall <david@davidnewall.com> escribió:

> Gustavo Chain wrote:
> > I think it's necessary to reserve some pids to the super user.
> > 5 must be sufficient.
> 
> Why?  (Sorry if I missed something.)

To prevent a posible DoS ?

> 
> Shouldn't you test for error return before the pid is allocated?  
> Otherwise, I think, you have to free it.  Thus:
> >  long do_fork(unsigned long clone_flags,
> >               int __user *parent_tidptr,
> >               int __user *child_tidptr)
> >  {
> > +#define RESERVED_PIDS   5      /* danged if I know why */
> > +
> > +       if (!capable(CAP_SYS_ADMIN) && nr_threads >= max_threads -
> > RESERVED_PIDS)
> > +               return -EAGAIN;
> > +
> >
> >         struct task_struct *p;
> >         int trace = 0;
> >         struct pid *pid = alloc_pid();
> >         long nr;
> >  
> >         if (!pid)
> >                 return -EAGAIN;
> >         nr = pid->nr;
> >   
> 
> (While I'm being picky, I don't like braces around a simple return,
> and neither, I note, does the style guide.)
> -
> To unsubscribe from this list: send the line "unsubscribe
> linux-kernel" in the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


-- 
Gustavo Chaín Dumit
