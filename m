Return-Path: <linux-kernel-owner+w=401wt.eu-S1755978AbZLDSvi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978AbZLDSvi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 13:51:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755798AbZLDSvg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 13:51:36 -0500
Received: from g4t0014.houston.hp.com ([15.201.24.17]:31464 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755564AbZLDSvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 13:51:36 -0500
Date: Fri, 4 Dec 2009 11:51:42 -0700
From: Alex Chiang <achiang@hp.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, sam@ravnborg.org,
       mmarek@suse.cz
Subject: Re: kbuild - hostprogs not seeing CONFIG_FOO?
Message-ID: <20091204185142.GB28311@ldl.fc.hp.com>
References: <20091204180749.GA28311@ldl.fc.hp.com> <20091204102826.3648025a.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091204102826.3648025a.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Randy Dunlap <randy.dunlap@oracle.com>:
> On Fri, 4 Dec 2009 11:07:49 -0700 Alex Chiang wrote:
> 
> > <stdin>:1519:2: warning: #warning syscall perf_event_open not implemented
> > <stdin>:1523:2: warning: #warning syscall recvmmsg not implemented
> > <stdin>:1527:2: warning: #warning syscall fanotify_init not implemented
> > <stdin>:1531:2: warning: #warning syscall fanotify_mark not implemented
> > make -f scripts/Makefile.build obj=scripts
> > make -f scripts/Makefile.build obj=scripts/genksyms
> > make -f scripts/Makefile.build obj=scripts/mod
> > mkdir -p .tmp_versions 
> > make KBUILD_MODULES=1 \
> > 	-f scripts/Makefile.build obj=Documentation/vm
> > (cat /dev/null; ) > Documentation/vm/modules.order
> >   gcc -Wp,-MD,Documentation/vm/.page-types.d -Wall
> >   -Wmissing-prototypes -Wstrict-prototypes -O2
> >   -fomit-frame-pointer     -o Documentation/vm/page-types
> >   Documentation/vm/page-types.c  
> 
> Try adding in Documentation/vm/Makefile something like:
> 
> HOSTCFLAGS_page-types.o += -I$(objtree)/usr/include
> 
> or
> 
> HOSTCFLAGS_page-types.o += $(LINUXINCLUDE)

Thanks Randy, that got it.

/ac

