Return-Path: <linux-kernel-owner+w=401wt.eu-S1758099AbZFZQVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758099AbZFZQVW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 12:21:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751074AbZFZQVP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 12:21:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52751 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750698AbZFZQVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 12:21:14 -0400
Date: Fri, 26 Jun 2009 09:20:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org, earl_chew@agilent.com,
       Oleg Nesterov <oleg@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] exec: Make do_coredump more robust and safer when using
 pipes in core_pattern
Message-Id: <20090626092001.32e35e17.akpm@linux-foundation.org>
In-Reply-To: <20090626104804.GA7337@hmsreliant.think-freely.org>
References: <20090622172818.GB14673@hmsreliant.think-freely.org>
	<20090625163050.d6a71a13.akpm@linux-foundation.org>
	<20090626104804.GA7337@hmsreliant.think-freely.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Jun 2009 06:48:04 -0400 Neil Horman <nhorman@tuxdriver.com> wrote:

> > > --- a/kernel/sysctl.c
> > > +++ b/kernel/sysctl.c
> > > @@ -75,6 +75,7 @@ extern int max_threads;
> > >  extern int core_uses_pid;
> > >  extern int suid_dumpable;
> > >  extern char core_pattern[];
> > > +extern unsigned int core_pipe_limit;
> > 
> > Bah.
> > 
> > We should fix this one day.
> > 
> Is there a particular way you'd like to see it fixed?

Not in the context of this patch.

One way would be to add a new sysctl-externs.h and then put all the
declarations in there.  That file gets included by sysctl.c and by each
file which shares a global with sysctl.c


