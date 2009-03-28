Return-Path: <linux-kernel-owner+w=401wt.eu-S1755520AbZC1UMP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520AbZC1UMP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 16:12:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752276AbZC1UL6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 16:11:58 -0400
Received: from casper.infradead.org ([85.118.1.10]:35385 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536AbZC1UL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 16:11:57 -0400
Date: Sat, 28 Mar 2009 13:13:15 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] async / fast boot patches
Message-ID: <20090328131315.090fde9d@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Please pull the git tree below to get three changes that help make boot faster
1) Remove the temporary "disable async" from 2.6.29
2) Flip the order of networking and ata; ata needs to init as early as possible
   since it takes the longest. Both Jeff and Dave agreed and suggested the patch
   should go via this tree
3) Don't do the unpack_to_rootfs() twice... it's expensive



The following changes since commit
5d80f8e5a9dc9c9a94d4aeaa567e219a808b8a4a: Linus Torvalds (1):
        Merge git://git.kernel.org/.../davem/net-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arjan/linux-2.6-async-for-30.git master

Arjan van de Ven (2):
      async: remove the temporary (2.6.29) "async is off by default" code
      ide/net: flip the order of SATA and network init

Li, Shaohua (1):
      fastboot: remove duplicate unpack_to_rootfs()

 drivers/Makefile |    5 ++-
 init/initramfs.c |   71 ++++++++++++++++++++++++++++++++++++++++++-----------
 kernel/async.c   |   18 ++++----------
 3 files changed, 64 insertions(+), 30 deletions(-)

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
