Return-Path: <linux-kernel-owner+w=401wt.eu-S1754760AbZDOA5O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760AbZDOA5O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 20:57:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752928AbZDOA4z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 20:56:55 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49939 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755266AbZDOA4w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 20:56:52 -0400
Message-ID: <49E53103.7020404@cn.fujitsu.com>
Date: Wed, 15 Apr 2009 08:57:39 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Jens Axboe <jens.axboe@oracle.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: blktrace: event traces displayed wrong while ftrace blktrace
 is active
References: <E1LtUBT-0007kq-HU@closure.thunk.org> <49E45F7B.7060709@cn.fujitsu.com> <20090414212532.GD5968@nowhere> <20090414213207.GP955@mit.edu>
In-Reply-To: <20090414213207.GP955@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
> On Tue, Apr 14, 2009 at 11:25:33PM +0200, Frederic Weisbecker wrote:
>> Indeed. Note that you can overwrite this default by typing:
>>
>> echo context-info > trace_option
>>
>> after setting bkltrace as the current tracer.
> 
> The problem with doing that is that blktrace will then display this:
> 
>     fsync-tester-27934 [001]   208.031278:     fsync-tester-27934 [001]   208.031278: 254,4    Q  WS 268392 + 8 [fsync-tester]
> 
> I think the real problem is that blk trace is displaying the standard
> context-info, so it's suppressing the normal context info.  So I have
> the choice on having no context information on my event trace lines,
> or two copies of the context information for the block trace lines.  
> 
> :-(
> 

I'll provide a patch to solve this confusing behavior.

> I'm guessing things were done this way in order to support the old
> legancy blktrace format?
> 

Right, in 2 ways:

 1. we can make the output the same as userspace 'btrace /dev/sda':
	# echo blk > current_tracer
	# echo 1 > options/blk_classic

 2. we can make the binary output parsable by userspace blkparse:
	# echo blk > current_tracer
	# echo bin > trace_options
	# cat trace_pipe | blkparse -i -
