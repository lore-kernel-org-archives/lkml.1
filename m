Return-Path: <linux-kernel-owner+w=401wt.eu-S1753957AbYHJRR0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957AbYHJRR0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 13:17:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752626AbYHJRRO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 13:17:14 -0400
Received: from qb-out-0506.google.com ([72.14.204.228]:38536 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223AbYHJRRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 13:17:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:sender;
        b=uxhAKHotTGAkJe21o3+j+fwLGVqx0dvmXVGccJM9N0kmcfg4wMqKeWET1etmcZ7u2n
         6v8hSyjia7RhGPJQJ5zawPVLHjYqlShHprmSLhSQUeglDK3uesOeK8/OlR37wJv7VhOr
         EzvmfMH4Y7UNAGPwYTaw/awzMD7tsnoxFl1Hs=
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: penberg@cs.helsinki.fi
Cc: mathieu.desnoyers@polymtl.ca, cl@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, rdunlap@xenotime.net, mpm@selenic.com,
       rostedt@goodmis.org, tglx@linutronix.de
Subject: [PATCH 0/5] kmemtrace
Date: Sun, 10 Aug 2008 20:14:02 +0300
Message-Id: <1218388447-5578-1-git-send-email-eduard.munteanu@linux360.ro>
X-Mailer: git-send-email 1.5.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everybody,

As usual, the kmemtrace userspace repo is located at
git://repo.or.cz/kmemtrace-user.git

It's not updated now, but I will rebase it. So re-clone it, don't just
git-rebase it. The changes were too extensive and I'd like to keep the
revision history clean.

Changes in kmemtrace:
- new ABI, supports variable sized packets and it's much shorter (it has
specific fields for allocations)
- we'll use splice() in userspace
- replaced timestamps with sequence numbers, since timestamps don't have a good
enough resolution (though they could be added as an additional feature)
- used relay_reserve() as Mathieu Desnoyers suggested
- moved additional docs into a different commit and documented the replacement
of inline with __always_inline in those commits

Please have a look and let me know what you think.

Eduard - Gabriel Munteanu (5):
  kmemtrace: Core implementation.
  kmemtrace: Additional documentation.
  kmemtrace: SLAB hooks.
  kmemtrace: SLUB hooks.
  kmemtrace: SLOB hooks.

 Documentation/ABI/testing/debugfs-kmemtrace |   71 ++++++
 Documentation/kernel-parameters.txt         |   10 +
 Documentation/vm/kmemtrace.txt              |  126 ++++++++++
 MAINTAINERS                                 |    6 +
 include/linux/kmemtrace.h                   |   85 +++++++
 include/linux/slab_def.h                    |   68 +++++-
 include/linux/slob_def.h                    |    9 +-
 include/linux/slub_def.h                    |   53 ++++-
 init/main.c                                 |    2 +
 lib/Kconfig.debug                           |   28 +++
 mm/Makefile                                 |    2 +-
 mm/kmemtrace.c                              |  335 +++++++++++++++++++++++++++
 mm/slab.c                                   |   71 +++++-
 mm/slob.c                                   |   37 +++-
 mm/slub.c                                   |   66 +++++-
 15 files changed, 933 insertions(+), 36 deletions(-)
 create mode 100644 Documentation/ABI/testing/debugfs-kmemtrace
 create mode 100644 Documentation/vm/kmemtrace.txt
 create mode 100644 include/linux/kmemtrace.h
 create mode 100644 mm/kmemtrace.c

