Return-Path: <linux-kernel-owner+w=401wt.eu-S1761279AbZJOJsA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761279AbZJOJsA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 05:48:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758037AbZJOJsA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 05:48:00 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51945 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756694AbZJOJr7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 05:47:59 -0400
Message-ID: <4AD6EF65.6080602@cn.fujitsu.com>
Date: Thu, 15 Oct 2009 17:46:13 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Catalin Marinas <catalin.marinas@arm.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Leaks in trace reported by kmemleak
References: <c4e36d110910150159j6092d0d1lb20434bd9d43d8ce@mail.gmail.com>
In-Reply-To: <c4e36d110910150159j6092d0d1lb20434bd9d43d8ce@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: ...

Zdenek Kabelac wrote:
> I've noticed your latest patch for memory leak in filter setting
> (8ad807318fcd...) - but even with this patch - kmemleak seems to still
> report  lots  (~900) of following leaks - note - they come only from
> i915 and kvm module - so I'm not sure if these two modules are doing
> something wrong or the problem is in trace code.
> 
> It looks like whole directory is somehow forgotten.
> 

Fortunately those are false-positives:

 # modprobe i915
 # echo scan > /debug/kmemleak
 # cat /debug/kmemleak
 (lots of "leaks")
 # rmmod i915
 # echo scan > /debug/kmemleak
 # cat /debug/kmemleak
 (no leaks)

All the memory allocated when loading the module is
freed in trace_module_remove_events() at module unload.

But I haven't looked into how to suppress those false-postives.
I'd like to, but I'm going to leave my office and won't be
back until 26th..

