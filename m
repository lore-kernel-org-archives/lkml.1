Return-Path: <linux-kernel-owner+w=401wt.eu-S1751321AbZH1CEx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751321AbZH1CEx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 22:04:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751200AbZH1CEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 22:04:53 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55866 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751189AbZH1CEw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 22:04:52 -0400
Message-ID: <4A973AE9.7020905@cn.fujitsu.com>
Date: Fri, 28 Aug 2009 10:03:21 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jens Axboe <jens.axboe@oracle.com>, Christoph Hellwig <hch@infradead.org>,
       rostedt@goodmis.org, fweisbec@gmail.com, acme@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: blktrace ftrace plugin, was Re: Receive side performance issue
 with multi-10-GigE and NUMA
References: <20090826181502.GC13632@elte.hu> <20090826190435.GC10816@hmsreliant.think-freely.org> <20090826190830.GF13632@elte.hu> <20090826.123631.79533250.davem@davemloft.net> <20090826194835.GA16508@elte.hu> <20090826202344.GE10816@hmsreliant.think-freely.org> <20090826204027.GA21159@elte.hu> <20090827003047.GA30341@infradead.org> <20090827052628.GE12579@kernel.dk> <20090827091227.GB4260@elte.hu>
In-Reply-To: <20090827091227.GB4260@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-Product-Ver: : ISVW-6.0.0.2339-3.52.0.1010-13974000
X-TM-AS-Result: : No
X-TM-AS-Category-Info: : 31:0.000000
X-TM-AS-MatchedID: : 1-90-150567-139010-110609-113228-110581-187067-121108
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jens Axboe <jens.axboe@oracle.com> wrote:
> 
>> On Wed, Aug 26 2009, Christoph Hellwig wrote:
>>> On Wed, Aug 26, 2009 at 10:40:27PM +0200, Ingo Molnar wrote:
>>>> We are also converting non-trivial plugins to generic tracepoints. A 
>>>> recent example are the system call tracepoints, but we also 
>>>> converted blktrace and kmemtrace to generic tracepoints.
>>> On something semi-related: Any reason to keep the blktrace 
>>> ftrace plugin around?  I don't think there's much point in it.  
>>> It only got added in 2.6.29, and all the blktrace tooling just 
>>> uses the legacy ioctls.  All new uses should just use the 
>>> TRACE_EVENT output.
>> Lets kill it.
> 
> Agreed.
> 
> I think we should keep the relayfs and ioctl compatibility bits 
> though: blktrace has a mature user-space environment with many
> years of installed base.
> 
> We could even move those bits back to block/blktrace_compat.c or so 
> (after the ftrace plugin bits are removed), to make sure it's nicely 
> isolated.
> 
> What do you think?
> 

I'm all for removing the ftrace plugin. There're 2 concerns:

- dev_t info can't be recorded in some blk trace events. I think
  this will change in the future when we can map a request_queue to
  a unique device?

- Not all the output of ftrace plugin comes from tracepoints probing,
  but via blk_add_trace_msg(), which directly writes a string into
  ring buffer. I think they need to be converted to TRACE_EVENT.

