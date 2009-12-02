Return-Path: <linux-kernel-owner+w=401wt.eu-S1755374AbZLBSHp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755374AbZLBSHp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 13:07:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755243AbZLBSHp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 13:07:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3681 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755174AbZLBSHo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 13:07:44 -0500
Message-ID: <4B16ACD6.3030402@redhat.com>
Date: Wed, 02 Dec 2009 13:07:18 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, dhowells@redhat.com,
       hidehiro.kawai.ez@hitachi.com, lethal@linux-sh.org, roland@redhat.com,
       vapier@gentoo.org, Takahiro Yasui <tyasui@redhat.com>
Subject: Re: [PATCH v2] mm: Introduce coredump parameter structure
References: <200911202212.nAKMCF2v012068@imap1.linux-foundation.org> <20091126174835.5A73.A69D9226@jp.fujitsu.com> <4B0EA3AA.5070003@redhat.com> <20091126165108.GA13231@redhat.com> <4B11FB6F.4040403@redhat.com> <20091201161800.fa6b6ae4.akpm@linux-foundation.org> <4B15B4ED.8010209@redhat.com> <20091202095012.GD22654@elte.hu>
In-Reply-To: <20091202095012.GD22654@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Masami Hiramatsu<mhiramat@redhat.com>  wrote:
>
>> Andrew Morton wrote:
>>> On Sat, 28 Nov 2009 23:41:19 -0500
>>> Masami Hiramatsu<mhiramat@redhat.com>   wrote:
>>>
>>>> Introduce coredump parameter data structure (struct coredump_params)
>>>> for simplifying binfmt->core_dump() arguments.
>>>>
>>>> Changes in v2:
>>>>     - Don't remove DUMP_WRITE() macro.
>>>
>>> What is the reason for this change?
>>>
>>> Please always include both the "what" and the "why" in changelog text.
>>
>> I see.
>
> I think Andrew wanted to see a longer explanation about precisely what
> we need for these tracepoints and what the various specific usecases are
> to utilize it.

Ah, OK.

>
> I.e. a basic cost/benefit analysis is needed. By looking at the patch we
> can see the cost - but you have to counter-balance that with enough
> stuff in the 'benefits' column of the equation.

Hmm, actually, this tracepoint requirement comes from the viewpoint of
administrators (not developers). Since now we have introduced many
coredump configurations (e.g. dumpable, coredump_filter, core_pattern, etc)
and some of them can be modified by users, we assume it is hard to know
what was actually dumped (or not dumped) after some problem happened on the
system. For example, a process didn't generated core, coredump doesn't have
some sections, etc. In those cases, the coredump tracepoint can help us to
know why the core file is so big or small, or not generated, by recording
all configurations for all processes on the system. That will reduce
system-administration cost.

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

