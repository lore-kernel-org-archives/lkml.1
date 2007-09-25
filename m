Return-Path: <linux-kernel-owner+w=401wt.eu-S1754511AbXIYUdj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511AbXIYUdj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 16:33:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751496AbXIYUdb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 16:33:31 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:59347 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786AbXIYUdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 16:33:31 -0400
Date: Tue, 25 Sep 2007 13:32:34 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 3/5] Add samples subdir
Message-Id: <20070925133234.cdd9edf1.randy.dunlap@oracle.com>
In-Reply-To: <20070925190036.GA14579@uranus.ravnborg.org>
References: <20070925121145.262664884@polymtl.ca>
	<20070925121251.954162366@polymtl.ca>
	<20070925190036.GA14579@uranus.ravnborg.org>
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

On Tue, 25 Sep 2007 21:00:36 +0200 Sam Ravnborg wrote:

Hi Sam,

Thanks for looking.  I was hoping that you would find time to
look/comment on it.

> Hi Mathieu & Randy.
> 
> On Tue, Sep 25, 2007 at 08:11:48AM -0400, Mathieu Desnoyers wrote:
> > From: Randy Dunlap <randy.dunlap@oracle.com>
> > 
> > Begin infrastructure for kernel code samples in the samples/ directory.
> > Add its Kconfig and Kbuild files.
> > Source its Kconfig file in all arch/ Kconfigs.
> 
> Sorry for not commenting on this before...
> The samples directory contains sample code so it is wrong to actually
> include it as part of the kernel IMHO.
> We only want to keep the samples buildable and to do so
> we can make a much simpler hack in the top-level Makefile.
> Consider following patch:
> 
> @@ -760,6 +760,9 @@ vmlinux: $(vmlinux-lds) $(vmlinux-init) $(vmlinux-main) $(kallsyms.o) vmlinux.o
>  ifdef CONFIG_HEADERS_CHECK
>         $(Q)$(MAKE) -f $(srctree)/Makefile headers_check
>  endif
> +ifdef CONFIG_SAMPLES
> +       $(Q)$(MAKE) $(build)=samples
> +endif
>         $(call vmlinux-modpost)
>         $(call if_changed_rule,vmlinux__)
>         $(Q)rm -f .old_version
> 
> 
> With this we build the samples when CONFIG_SAMPLES are selected and
> when the kernel is about to be linked.
> 
> 
> As for the Kconfig file I am in favour of it but think a much more
> natural place is to source it in lib/Kconfig.debug.
> Then it will appear in "Kernel hacking" and the smaples
> are used for kernel hacking and not for regular people
> building their own kernel.
> 
> Sourcing samples/Kconfig from lib/Kconfig.debug will then
> take effect for all archs so the result is a much simpler
> Kconfig patch too.

These changes all sound good to me.

Mathieu, can you find time to do this or should I do it?

---
~Randy
Phaedrus says that Quality is about caring.
