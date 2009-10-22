Return-Path: <linux-kernel-owner+w=401wt.eu-S1756279AbZJVQRJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756279AbZJVQRJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 12:17:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754880AbZJVQRI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 12:17:08 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:17112 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753287AbZJVQRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 12:17:07 -0400
Message-ID: <4AE08559.40806@caviumnetworks.com>
Date: Thu, 22 Oct 2009 09:16:25 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: wuzhangjin@gmail.com, linux-kernel@vger.kernel.org,
       linux-mips@linux-mips.org, Thomas Gleixner <tglx@linutronix.de>,
       Ralf Baechle <ralf@linux-mips.org>,
       Nicholas Mc Guire <der.herr@hofr.at>
Subject: Re: [PATCH -v4 9/9] tracing: add function graph tracer support for
 MIPS
References: <028867b99ec532b84963a35e7d552becc783cafc.1256135456.git.wuzhangjin@gmail.com>	 <ea8aa927fbd184b54941e4c2ae0be8ea0b4f6b8a.1256135456.git.wuzhangjin@gmail.com>	 <96110ea5dd4d3d54eb97d0bb708a5bd81c7a50b5.1256135456.git.wuzhangjin@gmail.com>	 <5dda13e8e3a9c9dba4bb7179183941bda502604f.1256135456.git.wuzhangjin@gmail.com>	 <af3ec1b5cd06b6f6a461c9fa7d09a51fabccb08d.1256135456.git.wuzhangjin@gmail.com>	 <a6f2959a69b6a77dd32cc36a5c8202f97d524f1e.1256135456.git.wuzhangjin@gmail.com>	 <53bdfdd95ec4fa00d4cc505bb5972cf21243a14d.1256135456.git.wuzhangjin@gmail.com>	 <1256141540.18347.3118.camel@gandalf.stny.rr.com>	 <4ADF38D5.9060100@caviumnetworks.com>	 <1256143568.18347.3169.camel@gandalf.stny.rr.com>	 <4ADF3FE0.5090104@caviumnetworks.com>	 <1256145813.18347.3210.camel@gandalf.stny.rr.com>	 <1256211516.3852.47.camel@falcon>  <4AE08173.7070500@caviumnetworks.com> <1256227916.20866.784.camel@gandalf.stny.rr.com>
In-Reply-To: <1256227916.20866.784.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Oct 2009 16:16:25.0743 (UTC) FILETIME=[00ECB1F0:01CA5333]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Thu, 2009-10-22 at 08:59 -0700, David Daney wrote:
> 
>> This is what I was talking about up-thread.  Leaf functions may have no 
>> function prolog.  If you do code scanning you will fail.  While scanning 
>> backwards, there is no way to know when you have entered a new function. 
>>   Looking for function return sequences 'jr ra' doesn't work as there 
>> may be functions with multiple return sites, functions that never 
>> return, or arbitrary data before the function.  I think you have to 
>> force a frame pointer to be established if you want this to work.
> 
> Functions that run off into another function?? I guess the compiler
> could do that, but with -pg enable, I would think is broken.
> 

Use of GCC-4.5's __builtin_unreachable() can lead to this, as well as 
functions that call noreturn functions.


Note to self: Time to resend the __builtin_unreachable() patch set again...

David Daney
