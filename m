Return-Path: <linux-kernel-owner+w=401wt.eu-S1761492AbYEWIHu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761492AbYEWIHu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 04:07:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753749AbYEWIH3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 04:07:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43669 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752214AbYEWIHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 04:07:21 -0400
Date: Fri, 23 May 2008 01:05:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Randy Dunlap <RANDY.DUNLAP@ORACLE.COM>, linux-kernel@vger.kernel.org
Subject: Re: -mm merge plans for 2.6.26
Message-Id: <20080523010551.ed0b290e.akpm@linux-foundation.org>
In-Reply-To: <20080519204417.GA25312@uranus.ravnborg.org>
References: <20080420072053.6bcb7884.akpm@linux-foundation.org>
	<20080516170310.35d7b407.randy.dunlap@oracle.com>
	<20080516172816.9d98c0f2.akpm@linux-foundation.org>
	<482E3DDA.7050708@oracle.com>
	<482E5F80.7040206@oracle.com>
	<8779236.1211228793416.JavaMail.oracle@acsmt301.oracle.com>
	<20080519133841.92de7f90.akpm@linux-foundation.org>
	<20080519204417.GA25312@uranus.ravnborg.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 May 2008 22:44:17 +0200 Sam Ravnborg <sam@ravnborg.org> wrote:

> On Mon, May 19, 2008 at 01:38:41PM -0700, Andrew Morton wrote:
> > On Mon, 19 May 2008 15:26:33 -0500 (CDT)
> > Randy Dunlap <RANDY.DUNLAP@ORACLE.COM> wrote:
> > 
> > > > > Oh yeah.  I think that this was fixed by
> > > > > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=b11caa7c7063ea92a0a58115d3fc6d038ed89510 
> > > > > 
> > > > > but I'll check/verify/confirm that.
> > > > > 
> > > > 
> > > > Yes, it builds fine now (built against 2.6.26-rc2-git5).
> > > 
> > > Andrew,
> > > Will you merge this now?
> > 
> > It's had no public testing because I disabled it in config, so it looks
> > like a 2.6.27 thing to me.
> > 
> > >  or do you want me to see about Sam merging it?
> > > or something else?
> > 
> > I'll move it into my send-to-Sam queue.
> 
> OK - I will apply them the kbuild-next.git when I receive latest version.
> 

Still causing problems.  A slew of warnings on various architectures
and a huge crackup on sparc64:

In file included from /usr/src/devel/usr/include/linux/errno.h:4,
                 from /usr/include/bits/errno.h:25,
                 from /usr/include/errno.h:36,
                 from Documentation/accounting/getdelays.c:16:
/usr/src/devel/usr/include/asm/errno.h:9:4: warning: #warning This machine appears to be neither sparc64 nor sparc.
In file included from /usr/include/bits/socket.h:310,
                 from /usr/include/sys/socket.h:35,
                 from Documentation/accounting/getdelays.c:23:
/usr/src/devel/usr/include/asm/socket.h:9:4: warning: #warning This machine appears to be neither sparc64 nor sparc.
In file included from /usr/src/devel/usr/include/linux/posix_types.h:47,
                 from /usr/src/devel/usr/include/linux/types.h:5,
                 from /usr/src/devel/usr/include/linux/netlink.h:5,
                 from /usr/src/devel/usr/include/linux/genetlink.h:4,
                 from Documentation/accounting/getdelays.c:26:
/usr/src/devel/usr/include/asm/posix_types.h:9:4: warning: #warning This machine appears to be neither sparc64 nor sparc.
In file included from /usr/src/devel/usr/include/linux/types.h:6,
                 from /usr/src/devel/usr/include/linux/netlink.h:5,
                 from /usr/src/devel/usr/include/linux/genetlink.h:4,
                 from Documentation/accounting/getdelays.c:26:
/usr/src/devel/usr/include/asm/types.h:9:4: warning: #warning This machine appears to be neither sparc64 nor sparc.
In file included from /usr/src/devel/usr/include/linux/netlink.h:5,
                 from /usr/src/devel/usr/include/linux/genetlink.h:4,
                 from Documentation/accounting/getdelays.c:26:
/usr/src/devel/usr/include/linux/types.h:153: error: expected '=', ',', ';', 'asm' or '__attribute__' before '__le16'
/usr/src/devel/usr/include/linux/types.h:154: error: expected '=', ',', ';', 'asm' or '__attribute__' before '__be16'
/usr/src/devel/usr/include/linux/types.h:155: error: expected '=', ',', ';', 'asm' or '__attribute__' before '__le32'
/usr/src/devel/usr/include/linux/types.h:156: error: expected '=', ',', ';', 'asm' or '__attribute__' before '__be32'
/usr/src/devel/usr/include/linux/types.h:158: error: expected '=', ',', ';', 'asm' or '__attribute__' before '__le64'
/usr/src/devel/usr/include/linux/types.h:159: error: expected '=', ',', ';', 'asm' or '__attribute__' before '__be64'
/usr/src/devel/usr/include/linux/types.h:161: error: expected '=', ',', ';', 'asm' or '__attribute__' before '__sum16'
/usr/src/devel/usr/include/linux/types.h:162: error: expected '=', ',', ';', 'asm' or '__attribute__' before '__wsum'
In file included from /usr/src/devel/usr/include/linux/genetlink.h:4,
                 from Documentation/accounting/getdelays.c:26:
/usr/src/devel/usr/include/linux/netlink.h:36: error: expected specifier-qualifier-list before '__u32'
/usr/src/devel/usr/include/linux/netlink.h:42: error: expected specifier-qualifier-list before '__u32'
/usr/src/devel/usr/include/linux/netlink.h:109: error: expected specifier-qualifier-list before '__u32'
/usr/src/devel/usr/include/linux/netlink.h:130: error: expected specifier-qualifier-list before '__u16'
In file included from Documentation/accounting/getdelays.c:26:
/usr/src/devel/usr/include/linux/genetlink.h:12: error: expected specifier-qualifier-list before '__u8'
In file included from Documentation/accounting/getdelays.c:27:
/usr/src/devel/usr/include/linux/taskstats.h:44: error: expected specifier-qualifier-list before '__u16'
In file included from Documentation/accounting/getdelays.c:28:
...


