Return-Path: <linux-kernel-owner+w=401wt.eu-S1756043AbYJVJk5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756043AbYJVJk5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 05:40:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755580AbYJVJip
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 05:38:45 -0400
Received: from smtp-out-45.synserver.de ([217.119.50.45]:1049 "HELO
	smtp-out-45.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755031AbYJVJio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 05:38:44 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Oct 2008 05:38:43 EDT
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: markus@trippelsdorf.de
X-SynServer-PPID: 4699
Date: Wed, 22 Oct 2008 11:32:01 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: linux-kernel@vger.kernel.org, eugene@ibrix.com, msnitzer@ibrix.com,
       tytso@mit.edu, akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: ext3: fix ext3_dx_readdir hash collision handling - Regression
Message-ID: <20081022093201.GA2227@gentoox2.trippelsdorf.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 6a897cf447a83c9c3fd1b85a1e525c02d6eada7d 
"ext3: fix ext3_dx_readdir hash collision handling" causes a regression
when deleting big directories.

I'm using an ext3 filesystem in data=writeback mode as my root fs.
When I untar a kernel tarball and then rm -r the files, this is what
happens on my machine (latest git):

markus@gentoox2 ~ % tar xjf  linux-2.6.27.2.tar.bz2
markus@gentoox2 ~ % rm -r linux-2.6.27.2
rm: cannot remove `linux-2.6.27.2/arch/alpha/include/asm/statfs.h': No such file or directory
rm: cannot remove `linux-2.6.27.2/arch/m68knommu/include/asm/cputime.h': No such file or directory
rm: cannot remove `linux-2.6.27.2/arch/sparc/include/asm/highmem.h': No such file or directory
rm: cannot remove `linux-2.6.27.2/arch/sparc/include/asm/sections_32.h': No such file or directory
rm: cannot remove `linux-2.6.27.2/arch/s390/include/asm/io.h': No such file or directory
rm: cannot remove `linux-2.6.27.2/arch/arm/configs/pcm038_defconfig': No such file or directory
rm: cannot remove `linux-2.6.27.2/arch/powerpc/include/asm/pgtable-ppc32.h': No such file or directory
rm: cannot remove `linux-2.6.27.2/include/asm-um/linkage.h': No such file or directory
rm: cannot remove `linux-2.6.27.2/include/asm-m68k/cachectl.h': No such file or directory
markus@gentoox2 ~ % rm -r linux-2.6.27.2
markus@gentoox2 ~ % 

After reverting 6a897cf447a83c9c3fd1b85a1e525c02d6eada7d I get the
expected result:

markus@gentoox2 ~ % tar xjf  linux-2.6.27.2.tar.bz2
markus@gentoox2 ~ % rm -r linux-2.6.27.2
markus@gentoox2 ~ % 

-- 
Markus
