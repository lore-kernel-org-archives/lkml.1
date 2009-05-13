Return-Path: <linux-kernel-owner+w=401wt.eu-S1755734AbZEMLaf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755734AbZEMLaf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 07:30:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750988AbZEMLaZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 07:30:25 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:52522 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750998AbZEMLaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 07:30:24 -0400
Date: Wed, 13 May 2009 20:30:24 +0900 (JST)
Message-Id: <20090513.203024.193692998.ryov@valinux.co.jp>
To: lizf@cn.fujitsu.com
Cc: Alan.Brunelle@hp.com, dm-devel@redhat.com, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com, mingo@elte.hu, rostedt@goodmis.org,
       fweisbec@gmail.com
Subject: Re: [RFC PATCH dm-ioband] Added in blktrace msgs for dm-ioband
From: Ryo Tsuruta <ryov@valinux.co.jp>
In-Reply-To: <4A0A1AAD.3090606@cn.fujitsu.com>
References: <4A092EE7.4070403@cn.fujitsu.com>
	<20090512.191206.226779551.ryov@valinux.co.jp>
	<4A0A1AAD.3090606@cn.fujitsu.com>
X-Mailer: Mew version 5.2.52 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Li,

From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [RFC PATCH dm-ioband] Added in blktrace msgs for dm-ioband
Date: Wed, 13 May 2009 08:56:13 +0800

> >>>>>> Thanks for your suggestion. I'll use TRACE_EVENT instead.
> >>>>> blk_add_trace_msg() supports both blktrace and tracepoints. I can
> >>>>> get messages from dm-ioband through debugfs. Could you expain why
> >>>>> should we use TRACE_EVENT instead?
> >>>>>
> >>>> Actually blk_add_trace_msg() has nothing to do with tracepoints..
> >>>>
> >>>> If we use blk_add_trace_msg() is dm, we can use it in md, various block
> >>>> drivers and even ext4. So the right thing is, if a subsystem wants to add
> >>>> trace facility, it should use tracepoints/TRACE_EVENT.
> >>>>
> >>>> With TRACE_EVENT, you can get output through debugfs too, and it can be used
> >>>> together with blktrace:
> >>>>
> >>>>  # echo 1 > /sys/block/dm/trace/enable
> >>>>  # echo blk > /debugfs/tracing/current_tracer
> >>>>  # echo dm-ioband-foo > /debugfs/tracing/tracing/set_event
> >>>>  # cat /deubgfs/tracing/trace_pipe
> >>>>  
> >>>> And you can enable dm-ioband-foo while disabling dm-ioband-bar, and you can
> >>>> use filter feature too.
> >>> Thanks for explaining.
> >>> The base kernel of current dm tree (2.6.30-rc4) has not supported
> >>> dm-device tracing yet. I'll consider using TRACE_EVENT when the base
> >>> kernel supports dm-device tracing.
> >>>
> >> I think we don't have any plan on dm-device tracing support, do we? And you
> >> don't need that.
> >>
> >> I downloaded dm-ioband 1.10.4, and applied it to latest tip-tree, and made
> >> a patch to convert those blktrace msgs to trace events.
> >>
> >>  # ls /debug/tracing/events/dm-ioband
> >>  enable  ioband_endio     ioband_issue_list    ioband_urgent_bio
> >>  filter  ioband_hold_bio  ioband_make_request
> >>  # echo 1 /debug/tracing/events/dm-ioband/enable
> >>  # echo blk /debug/tracing/current_tracer
> >>  ...
> > 
> > Is the following line unnecessary in the latest tip-tree?
> > 
> >    # echo 1 > /sys/block/dm/trace/enable
> > 
> 
> Yes, still needed. I was not giving a complete demonstration. ;)
> 
> > How to enable/disable tracing on each device?
> 
> echo 1 > /sys/block/dm-0/trace/enable
> echo 1 > /sys/block/dm-1/trace/enable
> 
> Or use filter facility:
> 
> echo "dev == $(( (ma0 << 20) | mi0 ))" > /debug/tracing/events/dm-ioband/filter
> 
> This will filter out all events generated from dm-1, leaving those from dm-0.
> 

Thanks for further explaining. I'll include your patche into the next
release.

Thanks,
Ryo Tsuruta
