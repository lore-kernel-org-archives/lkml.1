Return-Path: <linux-kernel-owner+w=401wt.eu-S1752834AbYJDIPN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834AbYJDIPN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 04:15:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751459AbYJDIOz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 04:14:55 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:33620 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044AbYJDIOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 04:14:53 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 2/2] Report the pagesize backing a VMA in /proc/pid/maps
Cc: kosaki.motohiro@jp.fujitsu.com, akpm@linux-foundation.org,
       dave@linux.vnet.ibm.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1223052415-18956-3-git-send-email-mel@csn.ul.ie>
References: <1223052415-18956-1-git-send-email-mel@csn.ul.ie> <1223052415-18956-3-git-send-email-mel@csn.ul.ie>
Message-Id: <20081004171256.CE3C.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Sat,  4 Oct 2008 17:14:50 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch adds a new field for hugepage-backed memory regions to show the
> pagesize in /proc/pid/maps.  While the information is available in smaps,
> maps is more human-readable and does not incur the cost of calculating Pss. An
> example of a /proc/self/maps output for an application using hugepages with
> this patch applied is;
> 
> 08048000-0804c000 r-xp 00000000 03:01 49135      /bin/cat
> 0804c000-0804d000 rw-p 00003000 03:01 49135      /bin/cat
> 08400000-08800000 rw-p 00000000 00:10 4055       /mnt/libhugetlbfs.tmp.QzPPTJ (deleted) (hpagesize=4096kB)
> b7daa000-b7dab000 rw-p b7daa000 00:00 0
> b7dab000-b7ed2000 r-xp 00000000 03:01 116846     /lib/tls/i686/cmov/libc-2.3.6.so
> b7ed2000-b7ed7000 r--p 00127000 03:01 116846     /lib/tls/i686/cmov/libc-2.3.6.so
> b7ed7000-b7ed9000 rw-p 0012c000 03:01 116846     /lib/tls/i686/cmov/libc-2.3.6.so
> b7ed9000-b7edd000 rw-p b7ed9000 00:00 0
> b7ee1000-b7ee8000 r-xp 00000000 03:01 49262      /root/libhugetlbfs-git/obj32/libhugetlbfs.so
> b7ee8000-b7ee9000 rw-p 00006000 03:01 49262      /root/libhugetlbfs-git/obj32/libhugetlbfs.so
> b7ee9000-b7eed000 rw-p b7ee9000 00:00 0
> b7eed000-b7f02000 r-xp 00000000 03:01 119345     /lib/ld-2.3.6.so
> b7f02000-b7f04000 rw-p 00014000 03:01 119345     /lib/ld-2.3.6.so
> bf8ef000-bf903000 rwxp bffeb000 00:00 0          [stack]
> bf903000-bf904000 rw-p bffff000 00:00 0
> ffffe000-fffff000 r-xp 00000000 00:00 0          [vdso]
> 
> To be predictable for parsers, the patch adds the notion of reporting on VMA
> attributes by appending one or more fields that look like "(attribute)". This
> already happens when a file is deleted and the user sees (deleted) after the
> filename. The expectation is that existing parsers will not break as those
> that read the filename should be reading forward after the inode number
> and stopping when it sees something that is not part of the filename.
> Parsers that assume everything after / is a filename will get confused by
> (hpagesize=XkB) but are already broken due to (deleted).
> 
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

This patch is nicer and cleaner than my version.
Thanks! mel.




