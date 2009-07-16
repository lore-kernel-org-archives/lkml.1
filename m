Return-Path: <linux-kernel-owner+w=401wt.eu-S933179AbZGPTzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933179AbZGPTzs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 15:55:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933116AbZGPTzr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 15:55:47 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:54689 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932805AbZGPTzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 15:55:46 -0400
Date: Thu, 16 Jul 2009 21:55:42 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>, kvm <kvm@vger.kernel.org>,
       DLE <dle-develop@lists.sourceforge.net>,
       Jim Keniston <jkenisto@us.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Andi Kleen <ak@linux.intel.com>,
       Vegard Nossum <vegard.nossum@gmail.com>, Avi Kivity <avi@redhat.com>,
       Przemys??awPawe??czyk <przemyslaw@pawelczyk.it>
Subject: Re: [PATCH -tip -v12 02/11] x86: x86 instruction decoder build-time
	selftest
Message-ID: <20090716195542.GA5994@merkur.ravnborg.org>
Mail-Followup-To: Masami Hiramatsu <mhiramat@redhat.com>,
	Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
	lkml <linux-kernel@vger.kernel.org>,
	systemtap <systemtap@sources.redhat.com>, kvm <kvm@vger.kernel.org>,
	DLE <dle-develop@lists.sourceforge.net>,
	Jim Keniston <jkenisto@us.ibm.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
	Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Andi Kleen <ak@linux.intel.com>,
	Vegard Nossum <vegard.nossum@gmail.com>,
	Avi Kivity <avi@redhat.com>,
	Przemys??awPawe??czyk <przemyslaw@pawelczyk.it>
References: <20090716155652.6266.39970.stgit@localhost.localdomain> <20090716155706.6266.79022.stgit@localhost.localdomain> <20090716162947.GA5804@merkur.ravnborg.org> <4A5F6571.3020002@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A5F6571.3020002@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> +      cmd_posttest = objdump -d $(objtree)/vmlinux | awk -f $(srctree)/arch/x86/scripts/distill.awk | $(obj)/test_get_len
> >> +
> > 
> > You are using the native objdump here.
> > But I assume this fails miserably when you build x86 on a powerpc host.
> > In other words - you broke an allyesconfig build for -next...
> > We have $(OBJDUMP) for this.
> 
> Ah, I see... Would you know actual name of x86-objdump on the powerpc
> (or any other crosscompiling host)? I just set "OBJDUMP=objdump" is OK?
> I'm not so sure about cross-compiling kernel...

Replacing objdump with $(OBJDUMP) will do the trick.
We set OBJDUMP to the correct value in the top-level makefile.

Are there any parts of your user-space program that rely
on the host is little-endian?
If it does then it would fail on a power-pc target despite using the
correct objdump.

	Sam
