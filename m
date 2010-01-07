Return-Path: <linux-kernel-owner+w=401wt.eu-S1756639Ab0AGCfR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756639Ab0AGCfR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 21:35:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756613Ab0AGCfQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 21:35:16 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:38474 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755461Ab0AGCfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 21:35:15 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 7 Jan 2010 11:31:54 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       "menage@google.com" <menage@google.com>, kirill@shutemov.name,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>
Subject: Re: mmotm 2010-01-06-14-34 uploaded (kernel/cgroup)
Message-Id: <20100107113154.a1fa0103.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100106170849.d0d95c9b.randy.dunlap@oracle.com>
References: <201001062259.o06MxQrp023236@imap1.linux-foundation.org>
	<20100106170849.d0d95c9b.randy.dunlap@oracle.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Jan 2010 17:08:49 -0800
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> On Wed, 06 Jan 2010 14:34:36 -0800 akpm@linux-foundation.org wrote:
> 
> > The mm-of-the-moment snapshot 2010-01-06-14-34 has been uploaded to
> > 
> >    http://userweb.kernel.org/~akpm/mmotm/
> > 
> > and will soon be available at
> > 
> >    git://zen-kernel.org/kernel/mmotm.git
> > 
> > It contains the following patches against 2.6.33-rc3:
> 
> 
> kernel/cgroup.c: In function 'cgroup_write_event_control':
> kernel/cgroup.c:2949: error: implicit declaration of function 'eventfd_fget'
> kernel/cgroup.c:2949: warning: assignment makes pointer from integer without a cast
> kernel/cgroup.c:2955: error: implicit declaration of function 'eventfd_ctx_fileget'
> kernel/cgroup.c:2955: warning: assignment makes pointer from integer without a cast
> make[2]: *** [kernel/cgroup.o] Error 1
> 

Hmm, how about this rather than adding #ifdefs..
Paul, Li, how do you think ?
==
Cgroup's eventdf feature has depenedecy to EVENTFD

This is a patch onto
cgroup-implement-eventfd-based-generic-api-for-notifications.patch

CC: Li Zefan <lizf@cn.fujitsu.com>
CC: Kirill A. Shutemov <kirill@shutemov.name>
CC: Paul Menage <menage@google.com>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

---
 init/Kconfig |    1 +
 1 file changed, 1 insertion(+)

Index: ref-mmotm/init/Kconfig
===================================================================
--- ref-mmotm.orig/init/Kconfig
+++ ref-mmotm/init/Kconfig
@@ -509,6 +509,7 @@ endchoice
 
 menuconfig CGROUPS
 	boolean "Control Group support"
+	depends on EVENTFD
 	help
 	  This option adds support for grouping sets of processes together, for
 	  use with process control subsystems such as Cpusets, CFS, memory

