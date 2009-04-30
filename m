Return-Path: <linux-kernel-owner+w=401wt.eu-S1763490AbZD3O2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763490AbZD3O2u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 10:28:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755465AbZD3O2j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 10:28:39 -0400
Received: from mail-bw0-f163.google.com ([209.85.218.163]:38871 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752842AbZD3O2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 10:28:39 -0400
Message-ID: <49F9B594.6050000@monstr.eu>
Date: Thu, 30 Apr 2009 16:28:36 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: John Williams <john.williams@petalogix.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: Memory limits - mm_segment_t - MAKE_MM_SEG
References: <49F85C27.9000308@monstr.eu> <200904301550.35112.arnd@arndb.de>
In-Reply-To: <200904301550.35112.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> On Wednesday 29 April 2009, Michal Simek wrote:
>> I look at some things which I need to clear for MMU Microblaze patches and
>> I would like to know your opinion about.
>>
>> First of all I found that almost all archs use MAKE_MM_SEG macro which 
>> should be good to move to generic location (asm-generic/uaccess.h ? )
>> #define MAKE_MM_SEG(s) ((mm_segment_t) { (s) })
> 
> I have a generic uaccess.h queued up, which I'm planning to submit for
> 2.6.30 that includes this. 

Please CC me for this patch. Thanks.

> 
>> The second thing is about place where is stored limit for processes -> mm_segment_t structure
>>
>> Where is the proper location for storing mm_segment_t? Some arch use
>> thread_info some of them thread_struct
> 
> The method that is used here is different on some architectures.
> Most of them use the address limit, which is a property of the
> thread, and sensibly belongs into the thread_info. s390 and possibly
> others have separate address spaces for user access and use a CPU
> feature for this, which belongs into thread_struct.

Great. I'll use only thread_info structure.

> 
>> Here is the small table for cpus which are in linux kernel and location and type for them.
>> The most of them uses thread_info structure for it and name is addr_limit.
>> The location of mm_segment_t is different too -> we should move it to any generic location too.
>> What do you think?
> 
> Sounds fair to me. I think uaccess.h is the best place for this, or maybe
> a new mm_segment.h, but not segment.h which is used traditionally for
> real segments on x86.

OK. I'll move all things from segment.h to uaccess.h in my next branch.

Michal

> 
> 	Arnd <><


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
