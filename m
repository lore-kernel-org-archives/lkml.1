Return-Path: <linux-kernel-owner+w=401wt.eu-S1755897AbZETIhy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897AbZETIhy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 04:37:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754525AbZETIhr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 04:37:47 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62216 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754246AbZETIhq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 04:37:46 -0400
Message-ID: <4A13C19E.3000303@cn.fujitsu.com>
Date: Wed, 20 May 2009 16:38:54 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Jeff Moyer <jmoyer@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Jens Axboe <jens.axboe@oracle.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>, "Theodore Ts'o" <tytso@mit.edu>,
       Steven Whitehouse <swhiteho@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] convert block trace points to TRACE_EVENT()
References: <4A0BB813.9080807@cn.fujitsu.com> <x49ws8d45am.fsf@segfault.boston.devel.redhat.com> <20090519130841.GA3801@infradead.org>
In-Reply-To: <20090519130841.GA3801@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Tue, May 19, 2009 at 08:59:29AM -0400, Jeff Moyer wrote:
>> I'm not sure I'm comfortable with this.  Having had to diagnose
>> performance problems using blktrace, I find the dev_t information for
>> plugs and unplugs especially interesting.  Maybe we can still figure
>> this out given the context in the trace, though.  Can you comment on
>> that?
> 
> The problem is that right now we still allow request queues shared by
> multiple gendisks, so we can't get at the gendisk.  The blktrace ioctl
> interface gets around that by doing the setup with an ioctl on the
> block device node and storing the dev_t at that point.
> 
> But I don't think we actually have any drivers left sharing a queue
> that way, and I'd love to get rid of that for various reasons.
> 

It will be great if this can be done.

>> from the single letter output to the verbose strings?  Am I just being a
>> curmudgeon?
>>
>> I have one further question, which will expose my ignorance on this
>> implementation.  Would the proposed patch change the information
>> available to the blktrace utility,
> 
> That's the output from /sys/kernel/debug/tracing/trace when the
> block events are enabled.  The blktrace utility should continue to
> work without changes, although it could be ported to use the ftrace
> binary ring buffer directly in the future.
> 

Yes, this patch doesn't affect ioctl-based blktrace or ftrace-plugin
blktrace at all.

To use blktracer:
  # echo 1 > /sys/block/sda/trace/enable
  # echo blk > /debug/tracing/current_tracer
  # cat /debug/tracing/trace_pipe

To use block trace events:
  # echo 'block:*' > /debug/tracing/set_event
  # cat /trace_pipe

You can mixed-use blktracer and trace events, to see how they differ
in the output.
