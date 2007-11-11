Return-Path: <linux-kernel-owner+w=401wt.eu-S1757553AbXKKTdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757553AbXKKTdU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 14:33:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755051AbXKKTdF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 14:33:05 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58168 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755728AbXKKTdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 14:33:04 -0500
Date: Sun, 11 Nov 2007 11:30:16 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Erez Zadok <ezk@cs.sunysb.edu>, linux-kernel@vger.kernel.org,
       Ulrich Drepper <drepper@redhat.com>, Roland McGrath <roland@redhat.com>,
       "Andrew G. Morgan" <morgan@kernel.org>,
       Casey Schaufler <casey@schaufler-ca.com>,
       Chris Wright <chrisw@sous-sol.org>, James Morris <jmorris@namei.org>,
       Serge Hallyn <serue@us.ibm.com>, Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [PATCH] kernel/capability.c get_task_comm compile error (MMOTM)
Message-Id: <20071111113016.6956ce70.akpm@linux-foundation.org>
In-Reply-To: <20071111141510.GA29126@elte.hu>
References: <200711110101.lAB110LV017867@agora.fsl.cs.sunysb.edu>
	<20071111141510.GA29126@elte.hu>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 Nov 2007 15:15:10 +0100 Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Erez Zadok <ezk@cs.sunysb.edu> wrote:
> 
> > Small patch below fixes compile error.
> 
> > +			char name[sizeof(current->comm)];
> >  			warned++;
> >  			printk(KERN_INFO
> >  			       "warning: process `%s' sets w/ old libcap\n",
> > -			       get_task_comm(current));
> > +			       get_task_comm(name, current));
> 
> that's buggy - get_task_comm() returns void.
> 
> the proper fix would be to first do a get_task_comm() then pass in 
> 'name' as an argument to printk.

yup, it is all dependent upon http://lkml.org/lkml/2007/11/8/231
