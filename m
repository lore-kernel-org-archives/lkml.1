Return-Path: <linux-kernel-owner+w=401wt.eu-S935058AbZKYVIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935058AbZKYVIs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 16:08:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932636AbZKYVIs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 16:08:48 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:65392 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932562AbZKYVIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 16:08:47 -0500
Subject: Re: [PATCH -tip v5 03/10] kprobes: Introduce kprobes jump
 optimization
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
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
In-Reply-To: <4B0C492D.1060602@redhat.com>
References: <20091123232115.22071.71558.stgit@dhcp-100-2-132.bos.redhat.com>
	 <20091123232141.22071.53317.stgit@dhcp-100-2-132.bos.redhat.com>
	 <20091124024417.GA6752@nowhere> <20091124033135.GE6752@nowhere>
	 <4B0BFCF8.4060905@redhat.com> <20091124201357.GB5071@nowhere>
	 <4B0C492D.1060602@redhat.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Wed, 25 Nov 2009 16:08:51 -0500
Message-Id: <1259183331.21397.71.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-24 at 15:59 -0500, Masami Hiramatsu wrote:

> > I see...so the non-preemptible kernel requirement looks
> > hard to workaround :-s
> 
> It's the next challenge I think :-)
> Even though, kprobes itself still work on preemptive kernel,
> so we don't lose any functionality.

>From kstop_machine, we could search all tasks to see if any are about to
resume in the modified location. If there is, we could either

1) insert a normal kprobe
2) modify the return address of the task to jump to some trampoline to 
   finish the work and return to the code spot with a direct jump.

#2 is kind of nasty but seems like a fun thing to implement ;-)

-- Steve


