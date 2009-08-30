Return-Path: <linux-kernel-owner+w=401wt.eu-S1753166AbZH3CsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166AbZH3CsV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Aug 2009 22:48:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752666AbZH3CsU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Aug 2009 22:48:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54291 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752595AbZH3CsU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Aug 2009 22:48:20 -0400
Message-ID: <4A99E8CB.1040600@redhat.com>
Date: Sat, 29 Aug 2009 22:49:47 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: Re: [PATCH -tip tracing/kprobes 3/6] kprobes/x86: Fix to add	__kprobes
 to in-kernel fault handing functions
References: <20090827152539.GE6058@nowhere> <20090827172311.8246.92725.stgit@localhost.localdomain> <20090830005355.GB387@nowhere>
In-Reply-To: <20090830005355.GB387@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> On Thu, Aug 27, 2009 at 01:23:11PM -0400, Masami Hiramatsu wrote:
>> Add __kprobes to the functions which handles in-kernel fixable page faults.
>> Since kprobes can cause those in-kernel page faults by accessing kprobe data
>> structures, probing those fault functions will cause fault-int3-loop
>> (do_page_fault has already been marked as __kprobes).
> 
> 
> BTW, is it possible to assert a struct kprobe (and its pointer members)
> haven't been allocated through vmalloc() ?
> 

How about calling vmalloc_sync() always before registering kprobes? :-)

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

