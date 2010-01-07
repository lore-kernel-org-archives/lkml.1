Return-Path: <linux-kernel-owner+w=401wt.eu-S932330Ab0AGCuo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932330Ab0AGCuo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 21:50:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755950Ab0AGCun
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 21:50:43 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:54250 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755569Ab0AGCum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 21:50:42 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 7 Jan 2010 11:47:28 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, "menage@google.com" <menage@google.com>,
       kirill@shutemov.name
Subject: Re: mmotm 2010-01-06-14-34 uploaded (kernel/cgroup)
Message-Id: <20100107114728.58166ce4.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4B4549CB.8000809@cn.fujitsu.com>
References: <201001062259.o06MxQrp023236@imap1.linux-foundation.org>
	<20100106170849.d0d95c9b.randy.dunlap@oracle.com>
	<20100107113154.a1fa0103.kamezawa.hiroyu@jp.fujitsu.com>
	<4B4549CB.8000809@cn.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 07 Jan 2010 10:41:15 +0800
Li Zefan <lizf@cn.fujitsu.com> wrote:

> KAMEZAWA Hiroyuki wrote:
> > On Wed, 6 Jan 2010 17:08:49 -0800
> > Randy Dunlap <randy.dunlap@oracle.com> wrote:
> > 
> >> On Wed, 06 Jan 2010 14:34:36 -0800 akpm@linux-foundation.org wrote:
> >>
> >>> The mm-of-the-moment snapshot 2010-01-06-14-34 has been uploaded to
> >>>
> >>>    http://userweb.kernel.org/~akpm/mmotm/
> >>>
> >>> and will soon be available at
> >>>
> >>>    git://zen-kernel.org/kernel/mmotm.git
> >>>
> >>> It contains the following patches against 2.6.33-rc3:
> >>
> >> kernel/cgroup.c: In function 'cgroup_write_event_control':
> >> kernel/cgroup.c:2949: error: implicit declaration of function 'eventfd_fget'
> >> kernel/cgroup.c:2949: warning: assignment makes pointer from integer without a cast
> >> kernel/cgroup.c:2955: error: implicit declaration of function 'eventfd_ctx_fileget'
> >> kernel/cgroup.c:2955: warning: assignment makes pointer from integer without a cast
> >> make[2]: *** [kernel/cgroup.o] Error 1
> >>
> > 
> > Hmm, how about this rather than adding #ifdefs..
> > Paul, Li, how do you think ?
> 
> I think make CONFIG_CGROUPS select EVENTFD would be better.
> 
Hm, as far as I know, SELECT is not recommended. But yes, it seems side-effect
of select is small here. But I avoid it as much as possible, usually.

Moreover, in this case,
  - EVENTFD is a feature which is enabled by default.
  - cgroup is "Say N if unsure" config.

In this case, "depends on" is good.

Thanks,
-Kame

