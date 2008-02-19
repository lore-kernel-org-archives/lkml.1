Return-Path: <linux-kernel-owner+w=401wt.eu-S1759282AbYBSDP5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759282AbYBSDP5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 22:15:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754726AbYBSDPt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 22:15:49 -0500
Received: from mga05.intel.com ([192.55.52.89]:19816 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752362AbYBSDPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 22:15:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,374,1199692800"; 
   d="scan'208";a="520747802"
Subject: Re: NULL pointer in kmem_cache_alloc with 2.6.25-rc1
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20080218085229.3fe9649c@laptopd505.fenrus.org>
References: <1203058021.3027.143.camel@ymzhang>
	 <20080218045918.2b80ee08.akpm@linux-foundation.org>
	 <20080218085229.3fe9649c@laptopd505.fenrus.org>
Content-Type: text/plain; charset=utf-8
Date: Tue, 19 Feb 2008 11:14:11 +0800
Message-Id: <1203390851.3248.14.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.2 (2.9.2-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-02-18 at 08:52 -0800, Arjan van de Ven wrote:
> On Mon, 18 Feb 2008 04:59:18 -0800
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Fri, 15 Feb 2008 14:47:01 +0800 "Zhang, Yanmin"
> > <yanmin_zhang@linux.intel.com> wrote:
> > 
> > > Call Trace:
> > >  [<ffffffff805e0024>] ? __alloc_skb+0x31/0x121
> > >  [<ffffffff805dc389>] ? sock_alloc_send_skb+0x77/0x1d2
> > >  [<ffffffff80243897>] ? autoremove_wake_function+0x0/0x2e
> > >  [<ffffffff805e12d5>] ? memcpy_fromiovec+0x36/0x66
> > >  [<ffffffff80636ec0>] ? unix_stream_sendmsg+0x165/0x333
> > >  [<ffffffff805d9863>] ? sock_aio_write+0xd1/0xe0
> > >  [<ffffffff80227834>] ? __wake_up_common+0x41/0x74
> > >  [<ffffffff8027d267>] ? do_sync_write+0xc9/0x10c
> > >  [<ffffffff80265fbb>] ? __do_fault+0x382/0x3cd
> > >  [<ffffffff80243897>] ? autoremove_wake_function+0x0/0x2e
> > >  [<ffffffff80268840>] ? handle_mm_fault+0x38a/0x70d
> > >  [<ffffffff806afd39>] ? error_exit+0x0/0x51
> > >  [<ffffffff80228008>] ? __dequeue_entity+0x1c/0x32
> > >  [<ffffffff8027d9bb>] ? vfs_write+0xc0/0x136
> > >  [<ffffffff8027dee5>] ? sys_write+0x45/0x6e
> > >  [<ffffffff8020bdcb>] ? system_call_after_swapgs+0x7b/0x80
> > 
> > off-topic, but...  Why are all the backtrace decodes here marked as
> > being unreliable?
At least ffffffff80279948 is correct. The register values and ip address looks like
matching the disassembled codes.

> 
> probably because the stack is a tad confused, so the back tracer doesn't see
> even a single good stack frame.
> 
> Is CONFIG_FRAME_POINTER on?
No.

With 2.6.25-rc2, 3 x86-64 machines hit the same issue.

-yanmin


