Return-Path: <linux-kernel-owner+w=401wt.eu-S964850AbZLGRTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964850AbZLGRTl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 12:19:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935386AbZLGRTk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 12:19:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60951 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932690AbZLGRTj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 12:19:39 -0500
Message-ID: <4B1D391A.9070801@redhat.com>
Date: Mon, 07 Dec 2009 12:19:22 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
       Jason Baron <jbaron@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH v2] [RFC] tracepoint: Add signal coredump tracepoint
References: <4B128ECF.9020906@redhat.com> <20091202204637.25408.41195.stgit@dhcp-100-2-132.bos.redhat.com> <20091203103935.GA7628@elte.hu> <4B17A1CD.8060706@redhat.com> <20091205071635.GB25383@elte.hu>
In-Reply-To: <20091205071635.GB25383@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>
> * Masami Hiramatsu<mhiramat@redhat.com>  wrote:
>
>> Ingo Molnar wrote:
>>>
>>> * Masami Hiramatsu<mhiramat@redhat.com>  wrote:
>>>
>>>> Add signal coredump tracepoint which shows signal number, mm->flags,
>>>> limits, pointer to file structure and core file name.
>>>
>>> Why is the kernel pointer to the file structure logged? User-space has
>>> no use for it and the analysis value is low.
>>
>> Ah, if open() or opening pipe fails, it becomes 0 or -ERRNO, so we can
>> check if there is an error.
>
> ok, that wasnt obvious from the patch - worth adding it to the
> changelog.

OK.

>> Perhaps, we can do below in trace_printk for trace users.
>> "open %s", (!file || IS_ERR((void *)file)) ? "failed" : "succeeded"
>
> i'd rather suggest to pass an error code (and keep it 0 if none),
> instead of some ad-hoc string message.

Sure. Or, perhaps, is it enough to show error code? (as block_rq_with_error did)

> But ... the whole issue of VFS event logging and new tracepoints should
> be approached from a more generic direction i think. Do we want to log
> inode_nr:dev pairs as well? Shouldnt there be a generic event-class
> definition via DECLARE_EVENT_CLASS for file related events, with 'core
> dumped' just being a sub-event-code?

Hmm, would you mean that coredump event should be a VFS event? or
handling file open errors should be a VFS event?
There are many other special reasons of failing coredump, as I discussed
with Kosaki-san. So, I think coredump event should be different from VFS
events.

Of course, Failure of file opening event should be handled in VFS events
if possible. In that case, we just need to trace coredump event and
VFS open event, and matching file descriptor or something like that.

> I sense reluctance from the direction of Andrew and disinterest from the
> VFS folks - not a good backdrop in general.
>
> 	Ingo

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

