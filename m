Return-Path: <linux-kernel-owner+w=401wt.eu-S1754119AbZB1JOy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119AbZB1JOy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 04:14:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754483AbZB1JML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 04:12:11 -0500
Received: from nf-out-0910.google.com ([64.233.182.189]:33891 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755351AbZB1JMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 04:12:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=d70FsVwGTvM6yU+ZUvW9lwHVRRNAvsNVvcK+IimjnghXGlSS0alArGEO164Q4RsOvg
         bvJsn7NyeJ99d6Iy7aRgkCzrNaww+T7TkXsJujT2b2tuxrKjXYVJ0s4z5wu6dSQ+Fxq9
         ow2fM0v7KYO7Mxz5rPD3uoEpjfd30K0r2luzU=
Date: Sat, 28 Feb 2009 10:12:02 +0100
From: Vegard Nossum <vegard.nossum@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Subject: [GIT PULL] kmemcheck fixes for -tip
Message-ID: <20090228091201.GA28985@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I hope this fixes all outstanding problems. We'll have to look more closely
at the CPA conflict (just a temporary Kconfig workaround in place now), but
this should allow your testing to continue.

The following changes since commit 42f6e3ebe50cc97ce0459d4be1bed66117d104c1:
  Ingo Molnar (1):
        Merge branch 'for-tip' of git://git.kernel.org/.../vegard/kmemcheck into kmemcheck

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/vegard/kmemcheck.git for-tip

Pekka Enberg (1):
      kmemcheck: make kconfig accessible for other architectures

Vegard Nossum (6):
      kmemcheck: add opcode self-testing at boot
      kmemcheck: decode sign/zero-extension move instructions correctly
      kmemcheck: bitfields: introduce hack to work around gcc bug
      trace: annotate bitfields in struct ring_buffer_event
      kmemcheck: fix split_page() of the page allocator
      kmemcheck: disable CPA self-test

 arch/x86/Kconfig                  |    1 +
 arch/x86/Kconfig.debug            |   89 +-----------------------------------
 arch/x86/mm/kmemcheck/Makefile    |    2 +-
 arch/x86/mm/kmemcheck/kmemcheck.c |   38 +++++++++------
 arch/x86/mm/kmemcheck/opcode.c    |   46 ++++++++++++++-----
 arch/x86/mm/kmemcheck/selftest.c  |   69 ++++++++++++++++++++++++++++
 arch/x86/mm/kmemcheck/selftest.h  |    6 +++
 include/linux/kmemcheck.h         |    9 +++-
 include/linux/ring_buffer.h       |    6 ++-
 kernel/trace/ring_buffer.c        |    3 +
 lib/Kconfig.debug                 |    2 +
 lib/Kconfig.kmemcheck             |   91 +++++++++++++++++++++++++++++++++++++
 mm/page_alloc.c                   |    8 +++
 13 files changed, 252 insertions(+), 118 deletions(-)
 create mode 100644 arch/x86/mm/kmemcheck/selftest.c
 create mode 100644 arch/x86/mm/kmemcheck/selftest.h
 create mode 100644 lib/Kconfig.kmemcheck


Vegard
