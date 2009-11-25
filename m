Return-Path: <linux-kernel-owner+w=401wt.eu-S1759057AbZKYVa5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759057AbZKYVa5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 16:30:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758981AbZKYVa5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 16:30:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4094 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754553AbZKYVa4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 16:30:56 -0500
Message-ID: <4B0DA1D9.2030609@redhat.com>
Date: Wed, 25 Nov 2009 16:30:01 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Anders Kaseorg <andersk@ksplice.com>, Tim Abbott <tabbott@ksplice.com>,
       Andi Kleen <andi@firstfloor.org>, Jason Baron <jbaron@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [PATCH -tip v5 03/10] kprobes: Introduce kprobes jump optimization
References: <20091123232115.22071.71558.stgit@dhcp-100-2-132.bos.redhat.com>	 <20091123232141.22071.53317.stgit@dhcp-100-2-132.bos.redhat.com>	 <20091124024417.GA6752@nowhere> <20091124033135.GE6752@nowhere>	 <4B0BFCF8.4060905@redhat.com> <20091124201357.GB5071@nowhere>	 <4B0C492D.1060602@redhat.com> <1259183331.21397.71.camel@gandalf.stny.rr.com>
In-Reply-To: <1259183331.21397.71.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Tue, 2009-11-24 at 15:59 -0500, Masami Hiramatsu wrote:
> 
>>> I see...so the non-preemptible kernel requirement looks
>>> hard to workaround :-s
>>
>> It's the next challenge I think :-)
>> Even though, kprobes itself still work on preemptive kernel,
>> so we don't lose any functionality.
> 
>> From kstop_machine, we could search all tasks to see if any are about to
> resume in the modified location. If there is, we could either
> 
> 1) insert a normal kprobe
> 2) modify the return address of the task to jump to some trampoline to
>     finish the work and return to the code spot with a direct jump.
> 
> #2 is kind of nasty but seems like a fun thing to implement ;-)

Sure, anyway, a normal kprobe is already inserted, so we also can
just wait until all tasks don't resume to the spot :-)
(that's another reason why it uses delayed work for optimization.
 we can try it again and again.)
And I think, that code will be shared with ksplice too.

Thank you,


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

