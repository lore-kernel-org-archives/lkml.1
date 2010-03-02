Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314Ab0CBC41 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 21:56:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52377 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753048Ab0CBC40 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 21:56:26 -0500
Message-ID: <4B8C7E23.1000302@redhat.com>
Date: Mon, 01 Mar 2010 21:55:31 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
CC: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Anders Kaseorg <andersk@ksplice.com>, Tim Abbott <tabbott@ksplice.com>,
       Andi Kleen <andi@firstfloor.org>, Jason Baron <jbaron@redhat.com>
Subject: Re: [PATCH -tip v3&10 02/18] kprobes: Introduce generic insn_slot
 framework
References: <20100225133342.6725.26971.stgit@localhost6.localdomain6> <20100225133358.6725.82430.stgit@localhost6.localdomain6> <20100225152130.GB12635@Krystal>
In-Reply-To: <20100225152130.GB12635@Krystal>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> * Masami Hiramatsu (mhiramat@redhat.com) wrote:
>> Make insn_slot framework support various size slots.
>> Current insn_slot just supports one-size instruction buffer slot. However,
>> kprobes jump optimization needs larger size buffers.
> 
> OK, so you end up having one insn slot cache for kprobes and one insn
> slot (eventually) for the static jump patching (which needs larger
> instruction slots than kprobes). That seems like a good way to ensure
> you do not use more memory than necessary.
> 
> We could possibly go even further and automatically use the right insn
> slot cache given the size of the instruction entry that must be added (a
> bit like the memory allocator which have different pools for each
> allocation order).

Sure, that will be simpler interface.

> Possibly that using the terminology of "memory pools" rather than
> "cache" could be a better fit too. So what this really becomes is an
> instruction slot allocator and garbage collector.

Ah, right. It would be better to rename kprobe_insn_pool() :)

Thank you,



-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com
