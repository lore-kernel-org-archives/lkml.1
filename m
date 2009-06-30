Return-Path: <linux-kernel-owner+w=401wt.eu-S1755130AbZF3Vp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755130AbZF3Vp2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 17:45:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754579AbZF3VpT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 17:45:19 -0400
Received: from mx2.redhat.com ([66.187.237.31]:51889 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754156AbZF3VpS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 17:45:18 -0400
Message-ID: <4A4A8804.1040004@redhat.com>
Date: Tue, 30 Jun 2009 17:47:48 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Jim Keniston <jkenisto@us.ibm.com>
Subject: Re: [PATCH -tip 3/3] kprobes: cleanup: use list instead of hlist
 for insn_pages
References: <20090630210757.17851.409.stgit@localhost.localdomain> <20090630210814.17851.64651.stgit@localhost.localdomain> <20090630212512.GA10831@elte.hu>
In-Reply-To: <20090630212512.GA10831@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Masami Hiramatsu <mhiramat@redhat.com> wrote:
> 
>> Use struct list instead of struct hlist for managing insn_pages, 
>> because insn_pages doesn't use hash table.
> 
>>  struct kprobe_insn_page {
>> -	struct hlist_node hlist;
>> +	struct list_head list;
> 
> Hm, you know that this increases the size of kprobe_insn_page by 4/8 
> bytes, right?

Sure, that will increase size.

> hlists are not just used for hashes - but also when we want a more 
> compact / smaller list head.

Oh, I thought hlists are used for hash tables...

> 
> How many kprobe_insn_page's can be allocated in the system, 
> maximally?

It's depends on how many probes you will use, but logically,
1 kprobe_insn_pages is allocated per 4096/16 = 256 probes.
So, if you use 25,600 probes on your system, memory
consumption will increase 400/800 bytes.

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

