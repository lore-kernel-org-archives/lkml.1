Return-Path: <linux-kernel-owner+w=401wt.eu-S1760873AbZBXWso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760873AbZBXWso (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 17:48:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758316AbZBXWsf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 17:48:35 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56305 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756596AbZBXWse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 17:48:34 -0500
Date: Tue, 24 Feb 2009 14:48:00 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: serue@us.ibm.com, clg@fr.ibm.com, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org
Subject: Re: [PATCH 4/4] mqueue namespace: adapt sysctl
Message-Id: <20090224144800.4c7e3fcb.akpm@linux-foundation.org>
In-Reply-To: <20090224223245.GA17473@x200.localdomain>
References: <20090224220256.GA31001@us.ibm.com>
	<20090224141651.70155ebd.akpm@linux-foundation.org>
	<20090224223245.GA17473@x200.localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Feb 2009 01:32:45 +0300
Alexey Dobriyan <adobriyan@gmail.com> wrote:

> > > +proc_handler *proc_mq_dointvec = NULL;
> > > +proc_handler *proc_mq_dointvec_minmax = NULL;
> > > +#endif
> > 
> > looks odd.  Was this
> > 
> > --- a/ipc/mq_sysctl.c~mqueue-namespace-adapt-sysctl-update-fix
> > +++ a/ipc/mq_sysctl.c
> > @@ -52,8 +52,8 @@ static int proc_mq_dointvec_minmax(ctl_t
> >  					lenp, ppos);
> >  }
> >  #else
> > -proc_handler *proc_mq_dointvec = NULL;
> > -proc_handler *proc_mq_dointvec_minmax = NULL;
> > +#define proc_mq_dointvec NULL
> > +#define proc_mq_dointvec_minmax NULL
> >  #endif
> 
> I hope, not.
> 
> "#define foo NULL" is the least intrusive thing.

well the original code would have spat a warning at compile time
then tried to execute code from BSS at runtime, methinks.

But I can't be assed working out how to disable CONFIG_SYSCTL to
test that.  Gawd I hate `select'.
