Return-Path: <linux-kernel-owner+w=401wt.eu-S1755202AbZJ2ULY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202AbZJ2ULY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 16:11:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755076AbZJ2ULX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 16:11:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51512 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755056AbZJ2ULW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 16:11:22 -0400
Message-ID: <4AE9F6BF.8000501@redhat.com>
Date: Thu, 29 Oct 2009 16:10:39 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?ISO-8859-1?Q?Fr=E9d=E9r?= =?ISO-8859-1?Q?ic_Weisbecker?= 
	<fweisbec@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Jason Baron <jbaron@redhat.com>, "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH -tip perf/probes 00/10] x86 insn decoder bugfixes
References: <20091027204156.30545.96425.stgit@harusame> <20091029085348.GD26970@elte.hu> <4AE9C919.4070003@redhat.com>
In-Reply-To: <4AE9C919.4070003@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Masami Hiramatsu wrote:
> Ingo Molnar wrote:
>> Another problem i noticed is that a vmlinux without DEBUG_INFO will fail
>> in this way:
>>
>>    aldebaran:~/linux/linux>   perf probe schedule
>>      Fatal: Failed to call dwarf_init(). Maybe, not a dwarf file.
>
> Ah, really? I think I broke need_dwarf logic somehow...

Hmm, I've found that is for searching (implicitly) inlined symbols,
this means "the behavior is by (bad) design" :-(

I think it should be search the symbol in Elf (or kallsyms) first,
and only if it fails, use Dwarf for searching the symbol again.

Or, it may be enough that just trying to setup probe and if it fails
use Dwarf. This way doesn't require any vmlinux access.

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

