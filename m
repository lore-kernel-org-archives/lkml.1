Return-Path: <linux-kernel-owner+w=401wt.eu-S934835AbZJNQEO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934835AbZJNQEO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 12:04:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934810AbZJNQEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 12:04:13 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:23466 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934809AbZJNQEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 12:04:11 -0400
Date: Wed, 14 Oct 2009 09:02:45 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       a.p.zijlstra@chello.nl, efault@gmx.de, fweisbec@gmail.com,
       tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/urgent] perf tools: Fix the NO_64BIT build on pure
 64-bit systems
Message-Id: <20091014090245.d04c8ab2.randy.dunlap@oracle.com>
In-Reply-To: <20091014155848.GB15193@ghostprotocols.net>
References: <tip-55621ccf2b7a8afe39df8c80f55b28424fd07d13@git.kernel.org>
	<20091013140915.96cfe060.randy.dunlap@oracle.com>
	<20091014062052.GD784@elte.hu>
	<20091014074404.98577824.randy.dunlap@oracle.com>
	<20091014155848.GB15193@ghostprotocols.net>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4AD5F631.006C:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Oct 2009 12:58:48 -0300 Arnaldo Carvalho de Melo wrote:

> Em Wed, Oct 14, 2009 at 07:44:04AM -0700, Randy Dunlap escreveu:
> > On Wed, 14 Oct 2009 08:20:52 +0200 Ingo Molnar wrote:
> > 
> > > 
> > > * Randy Dunlap <randy.dunlap@ORACLE.COM> wrote:
> > > 
> > > > On Mon, 12 Oct 2009 08:34:16 GMT tip-bot for Ingo Molnar wrote:
> > > > 
> > > > > Commit-ID:  55621ccf2b7a8afe39df8c80f55b28424fd07d13
> > > > > Gitweb:     http://git.kernel.org/tip/55621ccf2b7a8afe39df8c80f55b28424fd07d13
> > > > > Author:     Ingo Molnar <mingo@elte.hu>
> > > > > AuthorDate: Mon, 12 Oct 2009 09:57:25 +0200
> > > > > Committer:  Ingo Molnar <mingo@elte.hu>
> > > > > CommitDate: Mon, 12 Oct 2009 10:00:27 +0200
> > > > > 
> > > > > perf tools: Fix the NO_64BIT build on pure 64-bit systems
> > > > > 
> > > > > Randy Dunlap reported that 'make NO_64BIT=1' fails to build
> > > > > a pure 32-b it binary on 64-bit/64-bit x86 systems.
> > > > > 
> > > > > The reason is that we dont pass in the -m32 and GCC defaults
> > > > > to -m64.
> > > > > 
> > > > > So pass it in - and also extend the warning message about libelf
> > > > > dependencies - glibc-dev[el] is needed as well beyond the libelf
> > > > > library.
> > > > 
> > > > Ingo, thanks, I finally got this working, after installing more 32-bit
> > > > libs etc., like Kyle said that I would need to do.
> > > > 
> > > > The error message is still a little misleading/confusing:
> > > > Makefile:426: *** No libelf.h/libelf found, please install libelf-dev/elfutils-libelf-devel and glibc-dev[el].  Stop.
> > > > 
> > > > when elfutils-libelf-devel.i586 is installed but glibc-devel.i[56]86 is not
> > > > installed.  gcc failed with:
> > > > In file included from /usr/include/features.h:376,
> > > >                  from /usr/include/sys/types.h:27,
> > > >                  from /usr/include/libelf.h:53,
> > > >                  from elfdeveltest.c:1:
> > > > /usr/include/gnu/stubs.h:7:27: error: gnu/stubs-32.h: No such file or directory
> > > 
> > > Why is it misleading? It says it very clearly that you need to install 
> > > both:
> > > 
> > >   please install libelf-dev/elfutils-libelf-devel and glibc-dev[el].  Stop.
> > 
> > It also says very clearly:
> > 
> > Makefile:426: *** No libelf.h/libelf found
> > 
> > which is not correct.
> 
> So the correct way is to first look for the presence of glibc-devel,
> barf if its not present, then after that, do what is done now and test
> for the presence of libelf.h :-\
> 
> But if one just follows the suggestion, and installs the suggested
> packages, it should work, no?

Yes, it's just the confusing message...


---
~Randy
