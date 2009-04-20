Return-Path: <linux-kernel-owner+w=401wt.eu-S1753355AbZDTHTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355AbZDTHTU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 03:19:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751905AbZDTHTG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 03:19:06 -0400
Received: from ti-out-0910.google.com ([209.85.142.184]:64128 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562AbZDTHTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 03:19:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=hEeoNltDuyOZb8GYEtd1Ya5Dii1F1Nq9vk0MBMvsu8AggTvB6W2mW6H/ikvkkLEQ5K
         4L8XUmP6k60W8crtGkESLLl/LlN+1YBA8jWYiA/06NBV6Oh/6xSj4ggIDsriR3s2IzsH
         TtHf81LjPCxbgvtBLGMny+hqJNcUTwEDJdjlY=
Subject: Re: "RT_PREEMPT for loongson" is updated to patch-2.6.29.1-rt8
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: Zhang Le <r0bertz@gentoo.org>
Cc: linux-kernel@vger.kernel.org, Nicholas Mc Guire <hofrat@hofr.at>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       zhangfx@lemote.com, loongson-dev@googlegroups.com, yanh@lemote.com,
       Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
       linux-rt-users@vger.kernel.org
In-Reply-To: <20090420050419.GA22520@adriano.hkcable.com.hk>
References: <1240193547.25532.52.camel@falcon>
	 <20090420050419.GA22520@adriano.hkcable.com.hk>
Content-Type: text/plain
Organization: DSLab, Lanzhou University, China
Date: Mon, 20 Apr 2009 15:18:46 +0800
Message-Id: <1240211926.8884.27.camel@falcon>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-04-20 at 13:04 +0800, Zhang Le wrote:
> Hi, Zhangjin,
> 
> Ralf told me he has a ftrace implementation too.
> 
> 11:47 < Ralf> r0bertz: ftrace looks nice but not yet mergable yet.
> 11:47 < Ralf> r0bertz: I also have my own ftrace implementation which in some
> parts is better, in some is worse. 
> 11:47 < Ralf> r0bertz: So this is going to be quite a job.  
> 
> So I think you can talk to Ralf about how to get this merged, :)
> 

to Zhangle, 

thx very much for your info :-) 

hope Ralf can reply this E-mail and pull the source code from my git
tree:

git://dev.lemote.com/rt4ls.git

to Ralf, 

I have divided ftrace to several commits in the above git tree, hope you
can check it, thx :-) 

in addition to the static/dynamic/graph function tracer & system call
tracer implementation, a mips specific ring_buffer_time_stamp
(kernel/trace/ring_buffer.c) is also implemented to get 1us precision
time, this is very important to make ftrace available in mips,
otherwise, we can only get 1ms precision time for the original
ring_buffer_time_stamp is based on sched_clock(jiffies based). 

perhaps we can implement a more precise sched_clock directly, just as
x86 does(native_sched_clock, tsc based), but in mips, there is only a
32bit timer count which will quickly overflow, so it will need an extra
overflow protection, which may influence the other parts of the kernel.

best regards,
Wu Zhangjin

