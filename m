Return-Path: <linux-kernel-owner+w=401wt.eu-S1754546AbYJ1XMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546AbYJ1XMS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 19:12:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753267AbYJ1XMH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 19:12:07 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:25819 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332AbYJ1XMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 19:12:06 -0400
Date: Tue, 28 Oct 2008 16:11:36 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Alexey Dobriyan <adobriyan@gmail.com>, lkml <linux-kernel@vger.kernel.org>
Cc: ericvh@gmail.com, mfasheh@suse.com, dedekind@infradead.org
Subject: Re: How do I printk <type> correctly?
Message-Id: <20081028161136.c652b9fd.randy.dunlap@oracle.com>
In-Reply-To: <20081023114133.GA30187@x200.localdomain>
References: <20081023114133.GA30187@x200.localdomain>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Oct 2008 15:41:33 +0400 Alexey Dobriyan wrote:

> If variable is of Type	use	printk format specifier.
> ---------------------------------------------------------
> 		int			%d or %x
> 		unsigned int		%u or %x
> 		long			%ld ot %lx
> 		unsigned long		%lu or %lx
> 		long long		%lld or %llx
> 		unsigned long long	%llu or %llx
> 		size_t			%zu or %zx
> 		ssize_t			%zd or %zx
> 
> Raw pointer value SHOULD be printed with %p.
> 
> u64 SHOULD be printed with %llu/%llx, (unsigned long long):
> 
> 	printk("%llu", (unsigned long long)u64_var);
> 
> s64 SHOULD be printed with %lld/%llx, (long long):
> 
> 	printk("%lld", (long long)s64_var);
> 
> If type is dependent on config option (sector_t), use format specifier
> of biggest type and explicitly cast to it.
> 
> Reminder: sizeof() result is of type size_t.
> 
> Thank you for your cooperation.
  and attention.


Building for Alpha (cross-build) finds over 125 printk format warnings:

net/9p/client.c:820: warning: format '%llx' expects type 'long long unsigned int', but argument 4 has type 'u64'
net/9p/client.c:820: warning: format '%llx' expects type 'long long unsigned int', but argument 5 has type 'u64'
net/9p/client.c:867: warning: format '%llx' expects type 'long long unsigned int', but argument 4 has type 'u64'
net/9p/client.c:867: warning: format '%llx' expects type 'long long unsigned int', but argument 5 has type 'u64'
net/9p/client.c:932: warning: format '%llx' expects type 'long long unsigned int', but argument 5 has type 'u64'
net/9p/client.c:932: warning: format '%llx' expects type 'long long unsigned int', but argument 6 has type 'u64'
net/9p/client.c:982: warning: format '%llx' expects type 'long long unsigned int', but argument 4 has type 'u64'
net/9p/client.c:982: warning: format '%llx' expects type 'long long unsigned int', but argument 5 has type 'u64'
net/9p/client.c:1025: warning: format '%llx' expects type 'long long unsigned int', but argument 4 has type 'u64'
net/9p/client.c:1025: warning: format '%llx' expects type 'long long unsigned int', but argument 5 has type 'u64'
net/9p/client.c:1227: warning: format '%llx' expects type 'long long unsigned int', but argument 7 has type 'u64'
net/9p/client.c:1227: warning: format '%llx' expects type 'long long unsigned int', but argument 12 has type 'u64'
net/9p/client.c:1227: warning: format '%llx' expects type 'long long unsigned int', but argument 8 has type 'u64'
net/9p/client.c:1227: warning: format '%llx' expects type 'long long unsigned int', but argument 13 has type 'u64'
net/9p/client.c:1252: warning: format '%llx' expects type 'long long unsigned int', but argument 7 has type 'u64'
net/9p/client.c:1252: warning: format '%llx' expects type 'long long unsigned int', but argument 12 has type 'u64'
net/9p/client.c:1252: warning: format '%llx' expects type 'long long unsigned int', but argument 8 has type 'u64'
net/9p/client.c:1252: warning: format '%llx' expects type 'long long unsigned int', but argument 13 has type 'u64'

fs/ext4/balloc.c:615: warning: format '%lld' expects type 'long long int', but argument 2 has type 's64'
fs/ext4/inode.c:1833: warning: format '%lld' expects type 'long long int', but argument 2 has type 's64'
fs/ext4/inode.c:1835: warning: format '%lld' expects type 'long long int', but argument 2 has type 's64'

net/mac80211/rc80211_minstrel_debugfs.c:98: warning: format '%8llu' expects type 'long long unsigned int', but argument 11 has type 'u64'
net/mac80211/rc80211_minstrel_debugfs.c:98: warning: format '%8llu' expects type 'long long unsigned int', but argument 12 has type 'u64'
net/mac80211/rc80211_minstrel_debugfs.c:98: warning: format '%8llu' expects type 'long long unsigned int', but argument 11 has type 'u64'
net/mac80211/rc80211_minstrel_debugfs.c:98: warning: format '%8llu' expects type 'long long unsigned int', but argument 12 has type 'u64'

fs/ocfs2/xattr.c:2400: warning: format '%llu' expects type 'long long unsigned int', but argument 7 has type 'u64'
fs/ocfs2/xattr.c:2400: warning: format '%llu' expects type 'long long unsigned int', but argument 7 has type 'u64'
fs/ocfs2/xattr.c:2400: warning: format '%llu' expects type 'long long unsigned int', but argument 7 has type 'u64'
fs/ocfs2/xattr.c:2424: warning: format '%llu' expects type 'long long unsigned int', but argument 7 has type 'u64'
fs/ocfs2/xattr.c:2424: warning: format '%llu' expects type 'long long unsigned int', but argument 7 has type 'u64'
fs/ocfs2/xattr.c:2424: warning: format '%llu' expects type 'long long unsigned int', but argument 7 has type 'u64'
fs/ocfs2/xattr.c:2443: warning: format '%llu' expects type 'long long unsigned int', but argument 6 has type 'u64'
fs/ocfs2/xattr.c:2443: warning: format '%llu' expects type 'long long unsigned int', but argument 6 has type 'u64'
fs/ocfs2/xattr.c:2443: warning: format '%llu' expects type 'long long unsigned int', but argument 6 has type 'u64'
fs/ocfs2/xattr.c:2779: warning: format '%llu' expects type 'long long unsigned int', but argument 6 has type 'u64'
fs/ocfs2/xattr.c:2779: warning: format '%llu' expects type 'long long unsigned int', but argument 6 has type 'u64'
fs/ocfs2/xattr.c:2779: warning: format '%llu' expects type 'long long unsigned int', but argument 6 has type 'u64'
fs/ocfs2/xattr.c:2942: warning: format '%llu' expects type 'long long unsigned int', but argument 6 has type 'u64'
fs/ocfs2/xattr.c:2942: warning: format '%llu' expects type 'long long unsigned int', but argument 6 has type 'u64'
fs/ocfs2/xattr.c:2942: warning: format '%llu' expects type 'long long unsigned int', but argument 6 has type 'u64'
fs/ocfs2/xattr.c:3060: warning: format '%llu' expects type 'long long unsigned int', but argument 6 has type 'u64'
fs/ocfs2/xattr.c:3060: warning: format '%llu' expects type 'long long unsigned int', but argument 7 has type 'u64'
fs/ocfs2/xattr.c:3060: warning: format '%llu' expects type 'long long unsigned int', but argument 6 has type 'u64'
fs/ocfs2/xattr.c:3060: warning: format '%llu' expects type 'long long unsigned int', but argument 7 has type 'u64'
fs/ocfs2/xattr.c:3060: warning: format '%llu' expects type 'long long unsigned int', but argument 6 has type 'u64'
fs/ocfs2/xattr.c:3060: warning: format '%llu' expects type 'long long unsigned int', but argument 7 has type 'u64'
fs/ocfs2/xattr.c:3189: warning: format '%llu' expects type 'long long unsigned int', but argument 6 has type 'u64'
fs/ocfs2/xattr.c:3189: warning: format '%llu' expects type 'long long unsigned int', but argument 7 has type 'u64'
fs/ocfs2/xattr.c:3189: warning: format '%llu' expects type 'long long unsigned int', but argument 6 has type 'u64'
fs/ocfs2/xattr.c:3189: warning: format '%llu' expects type 'long long unsigned int', but argument 7 has type 'u64'
fs/ocfs2/xattr.c:3189: warning: format '%llu' expects type 'long long unsigned int', but argument 6 has type 'u64'
fs/ocfs2/xattr.c:3189: warning: format '%llu' expects type 'long long unsigned int', but argument 7 has type 'u64'
fs/ocfs2/xattr.c:3360: warning: format '%llu' expects type 'long long unsigned int', but argument 6 has type 'u64'
fs/ocfs2/xattr.c:3360: warning: format '%llu' expects type 'long long unsigned int', but argument 7 has type 'u64'
fs/ocfs2/xattr.c:3360: warning: format '%llu' expects type 'long long unsigned int', but argument 6 has type 'u64'
fs/ocfs2/xattr.c:3360: warning: format '%llu' expects type 'long long unsigned int', but argument 7 has type 'u64'
fs/ocfs2/xattr.c:3360: warning: format '%llu' expects type 'long long unsigned int', but argument 6 has type 'u64'
fs/ocfs2/xattr.c:3360: warning: format '%llu' expects type 'long long unsigned int', but argument 7 has type 'u64'
fs/ocfs2/xattr.c:3431: warning: format '%llu' expects type 'long long unsigned int', but argument 6 has type 'u64'
fs/ocfs2/xattr.c:3431: warning: format '%llu' expects type 'long long unsigned int', but argument 7 has type 'u64'
fs/ocfs2/xattr.c:3431: warning: format '%llu' expects type 'long long unsigned int', but argument 6 has type 'u64'
fs/ocfs2/xattr.c:3431: warning: format '%llu' expects type 'long long unsigned int', but argument 7 has type 'u64'
fs/ocfs2/xattr.c:3431: warning: format '%llu' expects type 'long long unsigned int', but argument 6 has type 'u64'
fs/ocfs2/xattr.c:3431: warning: format '%llu' expects type 'long long unsigned int', but argument 7 has type 'u64'
fs/ocfs2/xattr.c:3561: warning: format '%llu' expects type 'long long unsigned int', but argument 6 has type 'u64'
fs/ocfs2/xattr.c:3561: warning: format '%llu' expects type 'long long unsigned int', but argument 8 has type 'u64'
fs/ocfs2/xattr.c:3561: warning: format '%llu' expects type 'long long unsigned int', but argument 6 has type 'u64'
fs/ocfs2/xattr.c:3561: warning: format '%llu' expects type 'long long unsigned int', but argument 8 has type 'u64'
fs/ocfs2/xattr.c:3561: warning: format '%llu' expects type 'long long unsigned int', but argument 6 has type 'u64'
fs/ocfs2/xattr.c:3561: warning: format '%llu' expects type 'long long unsigned int', but argument 8 has type 'u64'
fs/ocfs2/xattr.c:3629: warning: format '%llu' expects type 'long long unsigned int', but argument 8 has type 'u64'
fs/ocfs2/xattr.c:3629: warning: format '%llu' expects type 'long long unsigned int', but argument 8 has type 'u64'
fs/ocfs2/xattr.c:3629: warning: format '%llu' expects type 'long long unsigned int', but argument 8 has type 'u64'
fs/ocfs2/xattr.c:3718: warning: format '%llu' expects type 'long long unsigned int', but argument 7 has type 'u64'
fs/ocfs2/xattr.c:3718: warning: format '%llu' expects type 'long long unsigned int', but argument 7 has type 'u64'
fs/ocfs2/xattr.c:3718: warning: format '%llu' expects type 'long long unsigned int', but argument 7 has type 'u64'
fs/ocfs2/xattr.c:3763: warning: format '%llu' expects type 'long long unsigned int', but argument 6 has type 'u64'
fs/ocfs2/xattr.c:3763: warning: format '%llu' expects type 'long long unsigned int', but argument 6 has type 'u64'
fs/ocfs2/xattr.c:3763: warning: format '%llu' expects type 'long long unsigned int', but argument 6 has type 'u64'

fs/ubifs/journal.c:693: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
fs/ubifs/journal.c:1131: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
fs/ubifs/dir.c:163: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
fs/ubifs/tnc.c:2680: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
fs/ubifs/tnc.c:2700: warning: format '%lu' expects type 'long unsigned int', but argument 5 has type 'ino_t'
fs/ubifs/replay.c:1066: warning: format '%lu' expects type 'long unsigned int', but argument 7 has type 'ino_t'
fs/ubifs/orphan.c:108: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
fs/ubifs/orphan.c:135: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
fs/ubifs/orphan.c:142: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
fs/ubifs/orphan.c:154: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
fs/ubifs/orphan.c:159: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
fs/ubifs/orphan.c:451: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
fs/ubifs/orphan.c:539: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
fs/ubifs/orphan.c:612: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
fs/ubifs/orphan.c:843: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
fs/ubifs/orphan.c:856: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
fs/ubifs/recovery.c:1438: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
fs/ubifs/recovery.c:1443: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
fs/ubifs/recovery.c:1475: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
fs/ubifs/recovery.c:1495: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
fs/ubifs/debug.c:105: warning: format '%lu' expects type 'long unsigned int', but argument 3 has type 'ino_t'
fs/ubifs/debug.c:105: warning: format '%lu' expects type 'long unsigned int', but argument 3 has type 'ino_t'
fs/ubifs/debug.c:110: warning: format '%lu' expects type 'long unsigned int', but argument 3 has type 'ino_t'
fs/ubifs/debug.c:110: warning: format '%lu' expects type 'long unsigned int', but argument 3 has type 'ino_t'
fs/ubifs/debug.c:114: warning: format '%lu' expects type 'long unsigned int', but argument 3 has type 'ino_t'
fs/ubifs/debug.c:114: warning: format '%lu' expects type 'long unsigned int', but argument 3 has type 'ino_t'
fs/ubifs/debug.c:118: warning: format '%lu' expects type 'long unsigned int', but argument 3 has type 'ino_t'
fs/ubifs/debug.c:118: warning: format '%lu' expects type 'long unsigned int', but argument 3 has type 'ino_t'
fs/ubifs/debug.c:1591: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
fs/ubifs/debug.c:1671: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
fs/ubifs/debug.c:1674: warning: format '%lu' expects type 'long unsigned int', but argument 5 has type 'ino_t'
fs/ubifs/debug.c:1680: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
fs/ubifs/debug.c:1699: warning: format '%lu' expects type 'long unsigned int', but argument 5 has type 'ino_t'
fs/ubifs/debug.c:1788: warning: format '%lu' expects type 'long unsigned int', but argument 5 has type 'ino_t'
fs/ubifs/debug.c:1821: warning: format '%lu' expects type 'long unsigned int', but argument 5 has type 'ino_t'
fs/ubifs/debug.c:1833: warning: format '%lu' expects type 'long unsigned int', but argument 5 has type 'ino_t'
fs/ubifs/debug.c:1924: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
fs/ubifs/debug.c:1932: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
fs/ubifs/debug.c:1938: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
fs/ubifs/debug.c:1945: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
fs/ubifs/debug.c:1953: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
fs/ubifs/debug.c:1960: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
fs/ubifs/debug.c:1967: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
fs/ubifs/debug.c:1973: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
fs/ubifs/debug.c:1988: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
fs/ubifs/debug.c:1991: warning: format '%lu' expects type 'long unsigned int', but argument 5 has type 'ino_t'
fs/ubifs/debug.c:2009: warning: format '%lu' expects type 'long unsigned int', but argument 2 has type 'ino_t'

drivers/isdn/sc/shmem.c:57: warning: format '%d' expects type 'int', but argument 3 has type 'size_t'
drivers/net/mlx4/en_rx.c:289: warning: format '%llx' expects type 'long long unsigned int', but argument 4 has type 'dma_addr_t'
drivers/net/mlx4/en_netdev.c:1002: warning: format '%llx' expects type 'long long unsigned int', but argument 5 has type 'u64'


---
~Randy
