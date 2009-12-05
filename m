Return-Path: <linux-kernel-owner+w=401wt.eu-S1752663AbZLEHRC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752663AbZLEHRC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 02:17:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752526AbZLEHRB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 02:17:01 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:51283 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752351AbZLEHRA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 02:17:00 -0500
Date: Sat, 5 Dec 2009 08:16:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
       Jason Baron <jbaron@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH v2] [RFC] tracepoint: Add signal coredump tracepoint
Message-ID: <20091205071635.GB25383@elte.hu>
References: <4B128ECF.9020906@redhat.com>
 <20091202204637.25408.41195.stgit@dhcp-100-2-132.bos.redhat.com>
 <20091203103935.GA7628@elte.hu>
 <4B17A1CD.8060706@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B17A1CD.8060706@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Masami Hiramatsu <mhiramat@redhat.com> wrote:

> Ingo Molnar wrote:
> > 
> > * Masami Hiramatsu <mhiramat@redhat.com> wrote:
> > 
> >> Add signal coredump tracepoint which shows signal number, mm->flags, 
> >> limits, pointer to file structure and core file name.
> > 
> > Why is the kernel pointer to the file structure logged? User-space has 
> > no use for it and the analysis value is low.
> 
> Ah, if open() or opening pipe fails, it becomes 0 or -ERRNO, so we can 
> check if there is an error.

ok, that wasnt obvious from the patch - worth adding it to the 
changelog.

> Perhaps, we can do below in trace_printk for trace users.
> "open %s", (!file || IS_ERR((void *)file)) ? "failed" : "succeeded"

i'd rather suggest to pass an error code (and keep it 0 if none), 
instead of some ad-hoc string message.

But ... the whole issue of VFS event logging and new tracepoints should 
be approached from a more generic direction i think. Do we want to log 
inode_nr:dev pairs as well? Shouldnt there be a generic event-class 
definition via DECLARE_EVENT_CLASS for file related events, with 'core 
dumped' just being a sub-event-code?

I sense reluctance from the direction of Andrew and disinterest from the 
VFS folks - not a good backdrop in general.

	Ingo
