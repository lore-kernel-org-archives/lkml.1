Return-Path: <linux-kernel-owner+w=401wt.eu-S1756218AbYFINuM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218AbYFINuM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 09:50:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750699AbYFINuA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 09:50:00 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:57214 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbYFINt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 09:49:59 -0400
Message-ID: <484D34DC.40401@de.ibm.com>
Date: Mon, 09 Jun 2008 15:49:16 +0200
From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Peter Oberparleiter <oberparleiter@googlemail.com>,
       linux-kernel@vger.kernel.org, ltp-coverage@lists.sourceforge.net,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 0/6] gcov kernel support
References: <4843F6BF.9070409@de.ibm.com> <20080609002509.7782442e.akpm@linux-foundation.org>
In-Reply-To: <20080609002509.7782442e.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Mon, 02 Jun 2008 15:33:51 +0200 Peter Oberparleiter <peter.oberparleiter@de.ibm.com> wrote:
> 
>> This is version #3 of the gcov kernel support patch set 
> 
> My build tree is now filled with dead symlinks, like
> 
> lrwxrwxrwx 1 akpm akpm 64 Jun  9 00:06 security/selinux/nlmsgtab.gcda -> /sys/kernel/debug/gcov/usr/src/25/security/selinux/nlmsgtab.gcda

Unfortunately a necessary evil of this approach: symlinks are created
for all compiled source files while link targets are only available when
the corresponding code is executed. In other words: those links will be
dead for source files which don't compile to actual code and for modules
as long as they are not loaded.

> Which causes (at least)
> 
> ctags: Warning: cannot open source file "security/selinux/ss/conditional.gcda" : No such file or directory
> ctags: Warning: cannot open source file "security/selinux/netlink.gcda" : No such file or directory
> ctags: Warning: cannot open source file "security/selinux/netlabel.gcda" : No such file or directory

> and probably other thing which I haven't discovered yet.

I'm sure there's some kind of 'find' magic that can be used to work
around dead links. I'll see how this can be applied to the ctags case -
though neither 'make tags' nor 'make TAGS' seem to produce any warnings
on my system..


Regards,
  Peter
