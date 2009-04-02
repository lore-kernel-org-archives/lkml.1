Return-Path: <linux-kernel-owner+w=401wt.eu-S1763136AbZDBVUn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763136AbZDBVUn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 17:20:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754245AbZDBVUf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 17:20:35 -0400
Received: from www84.your-server.de ([213.133.104.84]:48600 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876AbZDBVUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 17:20:34 -0400
Subject: Re: Detailed Stack Information Patch [2/3]
From: Stefani Seibold <stefani@seibold.net>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Joerg Engel <joern@logfs.org>
In-Reply-To: <20090401193639.GB12316@elte.hu>
References: <1238511507.364.62.camel@matrix>
	 <20090401193639.GB12316@elte.hu>
Content-Type: text/plain
Date: Thu, 02 Apr 2009 23:25:47 +0200
Message-Id: <1238707547.3882.24.camel@matrix>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, den 01.04.2009, 21:36 +0200 schrieb Ingo Molnar:
> * Stefani Seibold <stefani@seibold.net> wrote:
> 
> > +config PROC_STACK_MONITOR
> > + 	default y
> > +	depends on PROC_STACK
> > +	bool "Enable /proc/stackmon detailed stack monitoring"
> > + 	help
> > +	  This enables detailed monitoring of process and thread stack
> > +	  utilization via the /proc/stackmon interface.
> > +	  Disabling these interfaces will reduce the size of the kernel by
> > +	  approximately 2kb.
> 
> Hm, i'm not convinced about this one. Stupid question: what's wrong 
> with ulimit -s?
> 

To tell a long story short, you are right. After a quick investigation
of the glibc 2.9 library i figure out that this is also the default
stack size of a thread started with pthread_create().

> Also, if for some reason you dont want to (or cannot) enforce a 
> system-wide stack size ulimit, or it has some limitation that makes 
> it impractical for you - if we add what i suggested to the 
> /proc/*/maps files, your user-space watchdog daemon could scan those 
> periodically and report any excesses and zap the culprit ... right?

I think a user space daemon will be the a good way if the /proc/*/maps
or /proc/*/stack will provide the following information:

- start address of the stack
- current address of the stack pointer
- highest used address in the stack

> 
> 	Ingo

Stefani


