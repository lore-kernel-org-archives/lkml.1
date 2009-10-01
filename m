Return-Path: <linux-kernel-owner+w=401wt.eu-S1753692AbZJAWfK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692AbZJAWfK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 18:35:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752920AbZJAWfJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 18:35:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20548 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752370AbZJAWfI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 18:35:08 -0400
Date: Fri, 2 Oct 2009 00:29:42 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>, scott@ubuntu.com,
       zbr@ioremap.net, linux-kernel@vger.kernel.org, matthltc@us.ibm.com,
       davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH] connector: Fix regression introduced by sid connector
Message-ID: <20091001222941.GA15096@redhat.com>
References: <200909251123.03482.borntraeger@de.ibm.com> <200909291712.33099.borntraeger@de.ibm.com> <20090929162855.GA15319@redhat.com> <200909300843.11208.borntraeger@de.ibm.com> <20091001141426.2c1a0139.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091001141426.2c1a0139.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01, Andrew Morton wrote:
>
> On Wed, 30 Sep 2009 08:43:11 +0200
> Christian Borntraeger <borntraeger@de.ibm.com> wrote:
>
> > --- linux-2.6.orig/kernel/sys.c
> > +++ linux-2.6/kernel/sys.c
> > @@ -1110,6 +1110,8 @@ SYSCALL_DEFINE0(setsid)
> >  	err = session;
> >  out:
> >  	write_unlock_irq(&tasklist_lock);
> > +	if (err > 0)
> > +		proc_sid_connector(sid);
> >  	return err;
> >  }
>
> kernel/sys.c: In function 'sys_setsid':
> kernel/sys.c:1114: warning: passing argument 1 of 'proc_sid_connector' from incompatible pointer type
>
> Pass a `struct pid*' into a function expecting a `struct task_struct*'.
> Surely it will crash??

Oh, indeed, it should be

	proc_sid_connector(group_leader);

Oleg.

