Return-Path: <linux-kernel-owner+w=401wt.eu-S1754534AbZJURL3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534AbZJURL3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 13:11:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754463AbZJURL2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 13:11:28 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:6748 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754417AbZJURL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 13:11:27 -0400
Message-ID: <4ADF3FE0.5090104@caviumnetworks.com>
Date: Wed, 21 Oct 2009 10:07:44 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: Wu Zhangjin <wuzhangjin@gmail.com>, linux-kernel@vger.kernel.org,
       linux-mips@linux-mips.org, Thomas Gleixner <tglx@linutronix.de>,
       Ralf Baechle <ralf@linux-mips.org>,
       Nicholas Mc Guire <der.herr@hofr.at>
Subject: Re: [PATCH -v4 9/9] tracing: add function graph tracer support for
 MIPS
References: <028867b99ec532b84963a35e7d552becc783cafc.1256135456.git.wuzhangjin@gmail.com>	 <2f73eae542c47ac5bbb9f7280e6c0271d193e90d.1256135456.git.wuzhangjin@gmail.com>	 <3f0d3515f74a58f4cfd11e61b62a129fdc21e3a7.1256135456.git.wuzhangjin@gmail.com>	 <ea8aa927fbd184b54941e4c2ae0be8ea0b4f6b8a.1256135456.git.wuzhangjin@gmail.com>	 <96110ea5dd4d3d54eb97d0bb708a5bd81c7a50b5.1256135456.git.wuzhangjin@gmail.com>	 <5dda13e8e3a9c9dba4bb7179183941bda502604f.1256135456.git.wuzhangjin@gmail.com>	 <af3ec1b5cd06b6f6a461c9fa7d09a51fabccb08d.1256135456.git.wuzhangjin@gmail.com>	 <a6f2959a69b6a77dd32cc36a5c8202f97d524f1e.1256135456.git.wuzhangjin@gmail.com>	 <53bdfdd95ec4fa00d4cc505bb5972cf21243a14d.1256135456.git.wuzhangjin@gmail.com>	 <1256141540.18347.3118.camel@gandalf.stny.rr.com>	 <4ADF38D5.9060100@caviumnetworks.com> <1256143568.18347.3169.camel@gandalf.stny.rr.com>
In-Reply-To: <1256143568.18347.3169.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 Oct 2009 17:07:44.0373 (UTC) FILETIME=[01849A50:01CA5271]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Wed, 2009-10-21 at 09:37 -0700, David Daney wrote:
> 
>> There is no deterministic way to identify MIPS function prologs.  This 
>> is especially true for leaf functions, but also for functions with 
>> multiple return sites.
>>
>> For certain GCC versions there may be a set of command line options that 
>> would give good results, but in general it is not possible.  Attempts at 
>> fast backtrace generation using code inspection are not reliable and 
>> will invariably result in faults and panics when they fail.
> 
> Thanks for the update.
> 
> We can easily protect against panics, since we do fault protection
> within the code (although currently it will panic on fault, but we can
> fix that ;-). We can limit the search to a couple of 100 instructions,
> as well as fail on first panic.
> 
> But are you sure that when compiled with -pg, that GCC does not give a
> reliable prologue. Things are different when GCC is compiled with -pg,
> it may indeed always have something that we can flag.
> 
> We could also add other tests, like the subtraction of the stack too.
> 

I have not used -pg, so I don't know for sure, I think all it does is 
add the calls to _mcount.  Someone could investigate 
-fno-omit-frame-pointer, with that you may be able to use:

    move    s8,sp

To identify function prologs, but it would still be ad hoc, as modern 
versions of GCC will reorder instructions in the prolog for better 
scheduling.

David Daney
