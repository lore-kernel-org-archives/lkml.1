Return-Path: <linux-kernel-owner+w=401wt.eu-S1758614AbZB0KxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758614AbZB0KxQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 05:53:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755479AbZB0Kw5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 05:52:57 -0500
Received: from mail-fx0-f176.google.com ([209.85.220.176]:55694 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755472AbZB0Kwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 05:52:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=dii3DKZHZXXOZmSSz9iK8zQRw5MqTudtPC0g+BK1t5ig0V0pmexiH3BohYnElz6geM
         G9+kQre+2irjJ4r4PRweB5IXQuZEP6Mcd3Myui7YWccQzn2aNwV/Ib08tjMUT3hTjymg
         rQ+zvWQgmqdRBL//HyGD5yo2IGYTArhF0jyWQ=
Date: Fri, 27 Feb 2009 13:59:35 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Dave Hansen <dave@linux.vnet.ibm.com>,
       mpm@selenic.com, containers@lists.linux-foundation.org, hpa@zytor.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       viro@zeniv.linux.org.uk, linux-api@vger.kernel.org,
       torvalds@linux-foundation.org, tglx@linutronix.de, xemul@openvz.org
Subject: Re: How much of a mess does OpenVZ make? ;) Was: What can OpenVZ
	do?
Message-ID: <20090227105935.GD2939@x200.localdomain>
References: <1234467035.3243.538.camel@calx> <20090212114207.e1c2de82.akpm@linux-foundation.org> <1234475483.30155.194.camel@nimitz> <20090212141014.2cd3d54d.akpm@linux-foundation.org> <1234479845.30155.220.camel@nimitz> <20090226162755.GB1456@x200.localdomain> <20090226173302.GB29439@elte.hu> <20090226223112.GA2939@x200.localdomain> <20090227090323.GC16211@elte.hu> <20090227012209.65401324.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090227012209.65401324.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 27, 2009 at 01:22:09AM -0800, Andrew Morton wrote:
> On Fri, 27 Feb 2009 10:03:23 +0100 Ingo Molnar <mingo@elte.hu> wrote:
> 
> > >  arch/x86/include/asm/unistd_32.h   |    2 
> > >  arch/x86/kernel/syscall_table_32.S |    2 
> > >  include/linux/Kbuild               |    1 
> > >  include/linux/cr.h                 |   56 ++++++
> > >  include/linux/ipc_namespace.h      |    3 
> > >  include/linux/syscalls.h           |    5 
> > >  init/Kconfig                       |    2 
> > >  kernel/Makefile                    |    1 
> > >  kernel/cr/Kconfig                  |   11 +
> > >  kernel/cr/Makefile                 |    8 
> > >  kernel/cr/cpt-cred.c               |  115 +++++++++++++
> > >  kernel/cr/cpt-fs.c                 |  122 +++++++++++++
> > >  kernel/cr/cpt-mm.c                 |  134 +++++++++++++++
> > >  kernel/cr/cpt-ns.c                 |  324 +++++++++++++++++++++++++++++++++++++
> > >  kernel/cr/cpt-signal.c             |  121 +++++++++++++
> > >  kernel/cr/cpt-sys.c                |  228 ++++++++++++++++++++++++++
> > >  kernel/cr/cr-ctx.c                 |  141 ++++++++++++++++
> > >  kernel/cr/cr.h                     |   61 ++++++
> > >  kernel/cr/rst-sys.c                |    9 +
> > >  kernel/sys_ni.c                    |    3 
> > >  20 files changed, 1349 insertions(+)
> > 
> > That does not look scary to me at all. Andrew?
> 
> btw, why is there no need for a kernel/cr/cpt-net.c?

Too early :-) There is no rst-*.c counterparts either :-) But I'm
working on this.

But, yes, cpt-net.c will be definitely: all sorts of sockets, virtual
netdevices, iptables, ...
