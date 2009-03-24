Return-Path: <linux-kernel-owner+w=401wt.eu-S1757077AbZCXIdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757077AbZCXIdR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 04:33:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753609AbZCXIdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 04:33:00 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57908 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753442AbZCXIdA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 04:33:00 -0400
Message-ID: <49C89ACE.9070102@cn.fujitsu.com>
Date: Tue, 24 Mar 2009 16:33:18 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jens Axboe <jens.axboe@oracle.com>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/5] blktrace: fix off-by-one bug
References: <49C893FC.9080905@cn.fujitsu.com> <49C89447.5060303@cn.fujitsu.com> <20090324082754.GA13016@elte.hu>
In-Reply-To: <20090324082754.GA13016@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> -	if (unlikely(what == 0 || what > ARRAY_SIZE(what2act)))
>> +	if (unlikely(what == 0 || what >= ARRAY_SIZE(what2act)))
> 
> ah, nice. How did you notice - did we miss "remap" events due to 
> this bug?
> 

By code review, but we can get NULL dereference bug if we receive an
"abort" event, this event may be generated only when using device-mapper.

We don't print out this event currently, neither does the userspace
blktrace, which should be fixed.


