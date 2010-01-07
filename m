Return-Path: <linux-kernel-owner+w=401wt.eu-S1753334Ab0AGQtx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334Ab0AGQtx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 11:49:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753337Ab0AGQtv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 11:49:51 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:24141 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753261Ab0AGQtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 11:49:50 -0500
Date: Thu, 7 Jan 2010 08:47:59 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       "menage@google.com" <menage@google.com>, kirill@shutemov.name,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>
Subject: Re: mmotm 2010-01-06-14-34 uploaded (kernel/cgroup)
Message-Id: <20100107084759.638aa3bd.randy.dunlap@oracle.com>
In-Reply-To: <20100107113154.a1fa0103.kamezawa.hiroyu@jp.fujitsu.com>
References: <201001062259.o06MxQrp023236@imap1.linux-foundation.org>
	<20100106170849.d0d95c9b.randy.dunlap@oracle.com>
	<20100107113154.a1fa0103.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4B46104C.0050:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jan 2010 11:31:54 +0900 KAMEZAWA Hiroyuki wrote:

> On Wed, 6 Jan 2010 17:08:49 -0800
> Randy Dunlap <randy.dunlap@oracle.com> wrote:
> 
> > On Wed, 06 Jan 2010 14:34:36 -0800 akpm@linux-foundation.org wrote:
> > 
> > > The mm-of-the-moment snapshot 2010-01-06-14-34 has been uploaded to
> > > 
> > >    http://userweb.kernel.org/~akpm/mmotm/
> > > 
> > > and will soon be available at
> > > 
> > >    git://zen-kernel.org/kernel/mmotm.git
> > > 
> > > It contains the following patches against 2.6.33-rc3:
> > 
> > 
> > kernel/cgroup.c: In function 'cgroup_write_event_control':
> > kernel/cgroup.c:2949: error: implicit declaration of function 'eventfd_fget'
> > kernel/cgroup.c:2949: warning: assignment makes pointer from integer without a cast
> > kernel/cgroup.c:2955: error: implicit declaration of function 'eventfd_ctx_fileget'
> > kernel/cgroup.c:2955: warning: assignment makes pointer from integer without a cast
> > make[2]: *** [kernel/cgroup.o] Error 1
> > 
> 
> Hmm, how about this rather than adding #ifdefs..
> Paul, Li, how do you think ?
> ==
> Cgroup's eventdf feature has depenedecy to EVENTFD
> 
> This is a patch onto
> cgroup-implement-eventfd-based-generic-api-for-notifications.patch
> 
> CC: Li Zefan <lizf@cn.fujitsu.com>
> CC: Kirill A. Shutemov <kirill@shutemov.name>
> CC: Paul Menage <menage@google.com>
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

Thanks.

> ---
>  init/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
> 
> Index: ref-mmotm/init/Kconfig
> ===================================================================
> --- ref-mmotm.orig/init/Kconfig
> +++ ref-mmotm/init/Kconfig
> @@ -509,6 +509,7 @@ endchoice
>  
>  menuconfig CGROUPS
>  	boolean "Control Group support"
> +	depends on EVENTFD
>  	help
>  	  This option adds support for grouping sets of processes together, for
>  	  use with process control subsystems such as Cpusets, CFS, memory
> 


---
~Randy
