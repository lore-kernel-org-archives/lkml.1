Return-Path: <linux-kernel-owner+w=401wt.eu-S1753399AbYJ2JVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399AbYJ2JVU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 05:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752758AbYJ2JVM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 05:21:12 -0400
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:53701 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621AbYJ2JVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 05:21:11 -0400
Date: Wed, 29 Oct 2008 10:18:57 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, lethal@linux-sh.org
Subject: Re: ftrace: fix depends
Message-ID: <20081029091857.GA4414@osiris.boeblingen.de.ibm.com>
References: <200810281802.m9SI2fYX030138@hera.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810281802.m9SI2fYX030138@hera.kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2008 at 06:02:41PM +0000, Linux Kernel Mailing List wrote:
> Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=c2db8054c1eaf99983d8deee347876b01c26c2cf
> Commit:     c2db8054c1eaf99983d8deee347876b01c26c2cf
> Parent:     bd95b88d9e51fcbf392a7e90338a8fcc3499cbd6
> Author:     Steven Rostedt <rostedt@goodmis.org>
> AuthorDate: Mon Oct 6 19:06:11 2008 -0400
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Mon Oct 20 18:27:02 2008 +0200
> 
>     ftrace: fix depends
>     
>     A lot of tracers have HAVE_FTRACE as a dependent config where it
>     really should not. The HAVE_FTRACE is a misnomer (soon to be fixed)
>     and describes if the architecture has the function tracer (mcount)
>     implemented. The ftrace infrastructure is implemented in all archs.
>     
>     Signed-off-by: Steven Rostedt <srostedt@redhat.com>
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>

Hmm... this is not very true. I count three architectures which have this
implemented plus arm with a 'depends on' plus sh with the broken HAVE_FTRACE
instead of HAVE_FUNCTION_TRACER.

All other architectures will see something like this:

kernel/built-in.o: In function `tracer_alloc_buffers':
trace.c:(.init.text+0x42c2): undefined reference to `nop_trace'
trace.c:(.init.text+0x42ec): undefined reference to `nop_trace'
make: *** [.tmp_vmlinux1] Error 1
