Return-Path: <linux-kernel-owner+w=401wt.eu-S1765447AbYBPDmg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765447AbYBPDmg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 22:42:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756556AbYBPDmS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 22:42:18 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38565 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764925AbYBPDmP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 22:42:15 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Rene Herman <rene.herman@keyaccess.nl>
X-Fcc: ~/Mail/linus
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, linux-kbuild@vger.kernel.org
Subject: Re: 2.6.25-rc2 vdso_install breaks user "make install"
In-Reply-To: Rene Herman's message of  Saturday, 16 February 2008 04:31:54 +0100 <47B6592A.6030200@keyaccess.nl>
References: <47B6592A.6030200@keyaccess.nl>
X-Zippy-Says: I'll eat ANYTHING that's BRIGHT BLUE!!
Message-Id: <20080216034211.8DD03270193@magilla.localdomain>
Date: Fri, 15 Feb 2008 19:42:11 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Perhaps it makes more sense to have vdso_install be a dependency of
modules_install rather than install, since they both put things in /lib/modules.
The installed vdso images are potentially useful for a kernel when you
aren't bothering to build or install any modules, but those images are only
ever useful for sophisticated debugging uses anyway.

Sam, any thoughts?  (See arch/x86/Makefile and arch/powerpc/Makefile.)

The only kind of install runs I actually care about are for packaging
system builds.  There the packaged build does 'make vdso_install'
explicitly anyway (at least Fedora rpms' .spec does).  So if the consensus
is just to drop the dependency on vdso_install completely, I don't object.


Thanks,
Roland
