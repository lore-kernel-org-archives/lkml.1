Return-Path: <linux-kernel-owner+w=401wt.eu-S1757211AbZJ1CN4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757211AbZJ1CN4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 22:13:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757142AbZJ1CN4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 22:13:56 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:51787 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756940AbZJ1CNz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 22:13:55 -0400
Date: Wed, 28 Oct 2009 13:13:56 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Mundt <lethal@linux-sh.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Kumar Gala <galak@kernel.crashing.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, <linuxppc-dev@ozlabs.org>
Subject: linux-next: manual merge of the sh tree with the powerpc-merge tree
Message-Id: <20091028131356.7a6ba355.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

Today's linux-next merge of the sh tree got a conflict in fs/Kconfig
between commit 0cd9ad73b8d181737005ff4e506b9b6bd043f4dd ("powerpc: Limit
hugetlbfs support to PPC64 Book-3S machines") from the powerpc-merge tree
and commit ffb4a73d8906f71910e6c83ec2b499e70025ee8e ("sh: Fix hugetlbfs
dependencies for SH-3 && MMU configurations") from the sh tree.

I fixed it up (see below) and can carry the fix for a while (the
powerpc-merge commit should be in Linus' tree soon).
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/Kconfig
index f93d0ed,48b81f9..0000000
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@@ -135,8 -135,8 +135,8 @@@ config TMPFS_POSIX_AC
  
  config HUGETLBFS
  	bool "HugeTLB file system support"
- 	depends on X86 || IA64 || PPC_BOOK3S_64 || SPARC64 || (SUPERH && MMU) || \
 -	depends on X86 || IA64 || PPC64 || SPARC64 || (S390 && 64BIT) || \
 -		   SYS_SUPPORTS_HUGETLBFS || BROKEN
++	depends on X86 || IA64 || PPC_BOOK3S_64 || SPARC64 || \
 +		   (S390 && 64BIT) || SYS_SUPPORTS_HUGETLBFS || BROKEN
  	help
  	  hugetlbfs is a filesystem backing for HugeTLB pages, based on
  	  ramfs. For architectures that support it, say Y here and read
