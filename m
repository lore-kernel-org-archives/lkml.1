Return-Path: <linux-kernel-owner+w=401wt.eu-S1756432AbXJIPzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756432AbXJIPzo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 11:55:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754647AbXJIPzg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 11:55:36 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:44331 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754931AbXJIPzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 11:55:35 -0400
Date: Tue, 9 Oct 2007 08:55:00 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
Cc: Rob Landley <rob@landley.net>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, rdunlap@xenotime.net
Subject: Re: [PATCH] Stop docproc segfaulting when SRCTREE isn't set.
Message-Id: <20071009085500.e7be49a0.randy.dunlap@oracle.com>
In-Reply-To: <20071009130315.GB4245@Ahmed>
References: <200710090125.19089.rob@landley.net>
	<20071009130315.GB4245@Ahmed>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Oct 2007 15:03:15 +0200 Ahmed S. Darwish wrote:

> Hi Rob,
> 
> On Tue, Oct 09, 2007 at 01:25:18AM -0500, Rob Landley wrote:
> [...]
> >  	FILE * infile;
> > +
> > +	srctree = getenv("SRCTREE");
> > +	if (!srctree) srctree = getcwd(NULL,0);
> >  	if (argc != 3) {
> >  		usage();
> >  		exit(1);
> 
> $ man getcwd
> 
>  char *getcwd(char *buf, size_t size);
>       
>  As an extension to the POSIX.1 standard, Linux (libc4, libc5, glibc) getcwd() 
>  allocates the buffer dynamically using malloc() if buf is NULL on call.
> 
> Shouldn't "srctree" be free()ed in case getenv("SRCTREE") failed ?

What is there to free() at that point?  If getenv() fails (i.e.,
the env. variable is not found), it returns NULL.
or do I need another cup of coffee?

---
~Randy
