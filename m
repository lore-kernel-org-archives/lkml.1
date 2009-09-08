Return-Path: <linux-kernel-owner+w=401wt.eu-S1753186AbZIHBHz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186AbZIHBHz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 21:07:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752969AbZIHBHy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 21:07:54 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62307 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752911AbZIHBHy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 21:07:54 -0400
Message-ID: <4AA5AE29.6020107@cn.fujitsu.com>
Date: Tue, 08 Sep 2009 09:06:49 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, Tom Zanussi <tzanussi@gmail.com>,
       Jason Baron <jbaron@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/6] perf trace: Add filter support
References: <4AA4C04D.1050201@cn.fujitsu.com> <20090908000219.GB6312@nowhere>
In-Reply-To: <20090908000219.GB6312@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> An example:
>>
>>  #./perf record -f -e irq:irq_handler_entry:irq==18:record
>>  or
>>  #./perf record -f -e irq:irq_handler_entry:irq==18 -R
>>  ^C
> 
> We may want to write complex filters. While looking at this patchset,
> that seems possible this way, but the raw line may become unreadable:
> 
> perf record -f -e irq:irq_handler_entry:"irq==18 && (name == 'foo' || bar == 'blah')":record
> 
> May be we should add an option to let one also set the filters seperately then
> we could do:
> 
> perf record -f -e -R irq:irq_handler_entry --filter "irq==18 && (name == 'foo' || bar == 'blah')"
> 

I had the same idea. ;)

But using this option, is it possible to specify different filters
for different events? like this:

perf record -f -e -R irq:irq_handler_entry --filter "irq==18"
-e irq:softirq_entry --filter "vec==1"

