Return-Path: <linux-kernel-owner+w=401wt.eu-S1754952AbZKWOhO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952AbZKWOhO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 09:37:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752246AbZKWOhN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 09:37:13 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:47421 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399AbZKWOhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 09:37:12 -0500
Date: Mon, 23 Nov 2009 12:37:02 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Li Zefan <lizf@cn.fujitsu.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [RFC][PATCH 1/2] perf: Add 'perf kmem' tool
Message-ID: <20091123143701.GC15547@ghostprotocols.net>
References: <84144f020911200019p4978c8e8tc593334d974ee5ff@mail.gmail.com> <20091120083053.GB19778@elte.hu> <4B0657A4.2040606@cs.helsinki.fi> <4B06590C.7010109@cn.fujitsu.com> <20091120090353.GE19778@elte.hu> <20091120144215.GH18283@ghostprotocols.net> <20091120164110.GA24183@elte.hu> <20091120175228.GD27926@ghostprotocols.net> <20091123065110.GC31758@elte.hu> <1258960941.4531.19.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258960941.4531.19.camel@laptop>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Nov 23, 2009 at 08:22:21AM +0100, Peter Zijlstra escreveu:
> On Mon, 2009-11-23 at 07:51 +0100, Ingo Molnar wrote:
> > I havent tried this - is this really possible to do on an x86 box, with 
> > a typical distro? Can i install say Fedora PowerPC debuginfo packages on 
> > an x86 box, while also having the x86 debuginfo packages there? 
> 
> The best option would be to allow to specify a chroot parameter, where
> we can specify the embedded root filesystem on out machine.

yeah, I'm working now on a vmlinux_path, so that the symbol machinery in
perf looks at /lib/module/`uname -r`/build/vmlinux,
/usr/lib/debug/lib/modules/`uname -r`/vmlinux, ./vmlinux as a default or
in getenv("VMLINUX_PATH") if set. Being able to specify a
SYMTAB_PREFIX_PATH also should be possible.
 
> I'm not even sure embedded distros even have this separate debug package
> crazyness, you simply build the distro with or without debuginfo.

Whatever crazyness people usually do to find the files with matching,
richer symtabs we should support :)

- Arnaldo
