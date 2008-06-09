Return-Path: <linux-kernel-owner+w=401wt.eu-S1757089AbYFITMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757089AbYFITMV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 15:12:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755657AbYFITMA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 15:12:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41310 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755809AbYFITL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 15:11:59 -0400
Date: Mon, 9 Jun 2008 12:09:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
Cc: Peter Oberparleiter <oberparleiter@googlemail.com>,
       linux-kernel@vger.kernel.org, ltp-coverage@lists.sourceforge.net,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 0/6] gcov kernel support
Message-Id: <20080609120954.7d41a5bf.akpm@linux-foundation.org>
In-Reply-To: <484D34DC.40401@de.ibm.com>
References: <4843F6BF.9070409@de.ibm.com>
	<20080609002509.7782442e.akpm@linux-foundation.org>
	<484D34DC.40401@de.ibm.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 09 Jun 2008 15:49:16 +0200 Peter Oberparleiter <peter.oberparleiter@de.ibm.com> wrote:

> Andrew Morton wrote:
> > On Mon, 02 Jun 2008 15:33:51 +0200 Peter Oberparleiter <peter.oberparleiter@de.ibm.com> wrote:
> > 
> >> This is version #3 of the gcov kernel support patch set 
> > 
> > My build tree is now filled with dead symlinks, like
> > 
> > lrwxrwxrwx 1 akpm akpm 64 Jun  9 00:06 security/selinux/nlmsgtab.gcda -> /sys/kernel/debug/gcov/usr/src/25/security/selinux/nlmsgtab.gcda
> 
> Unfortunately a necessary evil of this approach: symlinks are created
> for all compiled source files while link targets are only available when
> the corresponding code is executed. In other words: those links will be
> dead for source files which don't compile to actual code and for modules
> as long as they are not loaded.

It doesn't seem awfully useful.  I don't run kernels on my build
machines and I'm sure many are in the same situation.  So gcov is going
to need a way of locating these files on the *target* machine.  And
once that is available, there is no need to add all these symlinks into
the build directory.

> > Which causes (at least)
> > 
> > ctags: Warning: cannot open source file "security/selinux/ss/conditional.gcda" : No such file or directory
> > ctags: Warning: cannot open source file "security/selinux/netlink.gcda" : No such file or directory
> > ctags: Warning: cannot open source file "security/selinux/netlabel.gcda" : No such file or directory
> 
> > and probably other thing which I haven't discovered yet.
> 
> I'm sure there's some kind of 'find' magic that can be used to work
> around dead links. I'll see how this can be applied to the ctags case -
> though neither 'make tags' nor 'make TAGS' seem to produce any warnings
> on my system..

I use

	ctags -R --excmd=pattern --format=1

