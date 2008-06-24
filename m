Return-Path: <linux-kernel-owner+w=401wt.eu-S1758855AbYFXQGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758855AbYFXQGU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 12:06:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752105AbYFXQGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 12:06:12 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35551 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750936AbYFXQGL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 12:06:11 -0400
Message-ID: <48611B03.1000003@redhat.com>
Date: Tue, 24 Jun 2008 12:04:19 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Takashi Nishiie <t-nishiie@np.css.fujitsu.com>
CC: "'Alexey Dobriyan'" <adobriyan@gmail.com>,
       "'Mathieu Desnoyers'" <mathieu.desnoyers@polymtl.ca>,
       "'Peter Zijlstra'" <peterz@infradead.org>,
       "'Steven Rostedt'" <rostedt@goodmis.org>,
       "'Frank Ch. Eigler'" <fche@redhat.com>, "'Ingo Molnar'" <mingo@elte.hu>,
       "'LKML'" <linux-kernel@vger.kernel.org>,
       "'systemtap-ml'" <systemtap@sources.redhat.com>,
       "'Hideo AOKI'" <haoki@redhat.com>
Subject: Re: [RFC] Tracepoint proposal
References: <485BE2C6.1080901@redhat.com> <20080620174529.GB10943@Krystal> <1213992446.3223.195.camel@lappy.programming.kicks-ass.net> <20080622171135.GA19432@Krystal> <20080622175928.GA5022@martell.zuzino.mipt.ru> <20080622182705.GA23301@Krystal> <20080624002010.GA4777@martell.zuzino.mipt.ru> <486071AF.3080709@redhat.com> <007601c8d5ca$18fa0e10$4aee2a30$@css.fujitsu.com>
In-Reply-To: <007601c8d5ca$18fa0e10$4aee2a30$@css.fujitsu.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Takashi Nishiie wrote:
> Hi
> 
> Hiramatsu wrote:
>> One reason why we need markers or other in-the-middle-of-function 
>> trace point is that some events happen inside functions, not it's 
>> interface.
> 
>   Each kernel sub-system seems to have its own way of dealing with 
> debugging statements. Some of these methods include 'dprintk', 
> 'pr_debug', 'dev_debug', 'DEBUGP'. I think that these functions are
> the tracepoints that has been availably mounted without setting up 
> the tool set of the outside. I think whether mounting that unites 
> these functions can be done if kernel marker and tracepoint are used.

Sure, I think those functions covers each partially, but some requirements
are different.

dynamic printk
 - stored in a section
 - dynamic activation
 - formatted message (multiple messages for each activation group)
 - export basic types
 - variadic function
 - low frequently called
 - module support

Marker
 - stored in a section
 - dynamic activation
 - formatted string (single format for each marker)
 - export basic types
 - variadic function
 - low-high frequently called
 - module support

Tracepoint
 - stored in a section
 - dynamic activation
 - no message
 - export kernel structure
 - arguments depending on points
 - high frequently called
 - no module support (kernel use only)


>   By the way, isn't there problem on security?
>   What kprobe, jprobe, and kernel marker, etc. offer looks like what
> the framework of Linux Security Module had offered before. Gotten
> kprobe, jprobe, and kernel marker, etc. should not be exported to the
> userland for security because it becomes the hotbed of rootkits. Users
> such as kprobe, jprobe, and kernel marker should not be Loadable Kernel
> Module. I think that there are some solutions in LTTng about this
> security problem. However, will the environment to be able to operate
> SystemTap be really secure?
> 　At least, kernel commandline option to invalidate all of kprobe,
> jprobe, and kernel marker, etc. because of the batch might be
> necessary.

Please, set CONFIG_MODULES=no.
If your system really really needs to be hardened, please
don't make kernel module loadable. Otherwise, any kernel module
can modify any kernel code. So, I think it's not a problem of
any specific functionality.

Anyway, I think selinux will give you more flexible way to
restrict who can load what modules.

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

