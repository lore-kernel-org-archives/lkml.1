Return-Path: <linux-kernel-owner+w=401wt.eu-S1754532AbZFEJQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532AbZFEJQR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 05:16:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751202AbZFEJQI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 05:16:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47428 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751050AbZFEJQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 05:16:07 -0400
Date: Fri, 5 Jun 2009 02:14:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Tao Ma <tao.ma@oracle.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yinghai@kernel.org>,
       Andi Kleen <ak@linux.intel.com>
Subject: Re: /proc/kcore has a unreasonable size(281474974617600) in x86_64
  2.6.30-rc8.
Message-Id: <20090605021424.ba352b0f.akpm@linux-foundation.org>
In-Reply-To: <2375c9f90906050209h191df8fav36fc9507654c5ca6@mail.gmail.com>
References: <4A289928.7040508@oracle.com>
	<20090604223805.2962e826.akpm@linux-foundation.org>
	<4A28C262.5020605@oracle.com>
	<20090605075614.GC8171@cr0.nay.redhat.com>
	<4A28DDEB.4000409@oracle.com>
	<2375c9f90906050209h191df8fav36fc9507654c5ca6@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Jun 2009 17:09:54 +0800 Am__rico Wang <xiyou.wangcong@gmail.com> wrote:

> On Fri, Jun 5, 2009 at 4:57 PM, Tao Ma<tao.ma@oracle.com> wrote:
> >
> >
> > Amerigo Wang wrote:
> >>
> >> On Fri, Jun 05, 2009 at 02:59:46PM +0800, Tao Ma wrote:
> >>>
> >>> Andrew Morton wrote:
> >>>>
> >>>> On Fri, 05 Jun 2009 12:03:52 +0800 Tao Ma <tao.ma@oracle.com> wrote:
> >>>>
> >>>>> Hi list,
> >>>>> __ __ __ In 2.6.30-rc8, /proc/kcore in x86_64's size is unreasonable large
> >>>>> to be 281474974617600.
> >>>>> While in a x86 box, it is 931131392 which looks sane.
> >>>>>
> >>>>> [root@test8 ~]# ll /proc/kcore
> >>>>> -r-------- 1 root root 281474974617600 Jun __5 11:15 /proc/kcore
> >>>>>
> >>>>> [root@ocfs2-test9 ~]$ ll /proc/kcore
> >>>>> -r-------- 1 root root 931131392 Jun __5 11:58 /proc/kcore
> >>>>>
> >>>>> I just noticed this when kexec fails in "Can't find kernel text map
> >>>>> area from kcore".
> >>>>>
> >>>>> Is there something wrong?
> >>>>>
> >>>> fs/proc/kcore.c hasn't changed since October last year. __Was 2.6.29 OK?
> >>>> Earlier kernels?
> >>>
> >>> with 2.6.29, ls shows the same output.
> >>> [root@test8 ~]# ll /proc/kcore
> >>> -r-------- 1 root root 281474974617600 Jun __5 14:35 /proc/kcore
> >>
> >>
> >> Thanks.
> >>
> >> It looks like the value of 'high_memory' is insane..
> >> Can you get its value on your machine? You can add a printk() or use
> >> systemtap etc..
> >
> > Just did that.
> > Also a strange number.
> > high memory 18446612137615818752.
> >

(top-posting repaired)

> Add some Cc: to x86 people. :)
> 
> Yinghai?
> 

Please send the boot logs: dmesg -s 1000000 > foo
