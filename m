Return-Path: <linux-kernel-owner+w=401wt.eu-S1757510AbZGQVM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757510AbZGQVM3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 17:12:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757025AbZGQVM3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 17:12:29 -0400
Received: from mx2.redhat.com ([66.187.237.31]:51780 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755090AbZGQVM2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 17:12:28 -0400
Message-ID: <4A60E972.1060301@redhat.com>
Date: Fri, 17 Jul 2009 17:13:22 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Anders Kaseorg <andersk@ksplice.com>,
       Tim Abbott <tabbott@ksplice.com>
Subject: Re: [RFC][ PATCH -tip v2 3/7] Kbuild: disable gcc crossjumping
References: <20090622212255.5384.53732.stgit@localhost.localdomain> <20090622212313.5384.84166.stgit@localhost.localdomain> <alpine.DEB.2.00.0906271611280.12592@gandalf.stny.rr.com> <20090717202825.GA6872@merkur.ravnborg.org>
In-Reply-To: <20090717202825.GA6872@merkur.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> On Sat, Jun 27, 2009 at 04:13:04PM -0400, Steven Rostedt wrote:
>> A change like this requires an ACK from Sam Ravnborg.
>>
>> -- Steve
> 
> Overdue review...
> 
> I do not know the gcc option so I cannot comment on theeffect of it.

Thanks for comment. however, as far as I can see, I couldn't find
in the difference between binary with -fno-crossjump and without it.
So I decided to drop this patch...

> 
>>> diff --git a/Makefile b/Makefile
>>> index 2903e13..f73b139 100644
>>> --- a/Makefile
>>> +++ b/Makefile
>>> @@ -524,6 +524,10 @@ else
>>>  KBUILD_CFLAGS	+= -O2
>>>  endif
>>>  
>>> +ifdef CONFIG_DISABLE_CROSSJUMP
>>> +KBUILD_CFLAGS	+= -fno-crossjumping
>>> +endif
>>> +
>>>  include $(srctree)/arch/$(SRCARCH)/Makefile
> 
> Why do we add this option _before_ we include the arch specific Makefile?
> If we do not want the arch specific Makefile to undo this then move it lower.
> 
> Also please add a comment what the effect of the disabling is.
> There is no reason I should fire up info gcc to find out
> what -fno-crossjumping is about.

Sure, I'll write a comment on, next time.

> 
> 
>>>  
>>>  ifneq ($(CONFIG_FRAME_WARN),0)
>>> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
>>> index 8da7467..f88e6b8 100644
>>> --- a/lib/Kconfig.debug
>>> +++ b/lib/Kconfig.debug
>>> @@ -673,6 +673,13 @@ config FRAME_POINTER
>>>  	  larger and slower, but it gives very useful debugging information
>>>  	  in case of kernel bugs. (precise oopses/stacktraces/warnings)
>>>  
>>> +config DISABLE_CROSSJUMP
>>> +	bool "Disable cross-function jump optimization"
>>> +	help
>>> +	  This build option disables cross-function jump optimization
>>> +	  (crossjumping) of gcc. Disabling crossjumping might increase
>>> +	  kernel binary size a little.
> 
> So the above comment tells me that is I disable crossjumping I will
> increase the kernel image a little.
> That is by no means a good explanation.
> 
> Please explain the potential advantage of disabling crossjumping.

Agreed.

Thank you,
-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

