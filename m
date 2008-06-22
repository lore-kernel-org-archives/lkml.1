Return-Path: <linux-kernel-owner+w=401wt.eu-S1752813AbYFVED3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813AbYFVED3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 00:03:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750770AbYFVEDV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 00:03:21 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36707 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750751AbYFVEDU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 00:03:20 -0400
Message-ID: <485DCE79.3040508@redhat.com>
Date: Sun, 22 Jun 2008 00:00:57 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       systemtap-ml <systemtap@sources.redhat.com>,
       Hideo AOKI <haoki@redhat.com>
Subject: Re: [RFC][Patch 2/2] markers: example of irq regular kernel markers
References: <20080620174529.GB10943@Krystal> <485C064E.5020705@redhat.com> <20080621190132.E835.KOSAKI.MOTOHIRO@jp.fujitsu.com>
In-Reply-To: <20080621190132.E835.KOSAKI.MOTOHIRO@jp.fujitsu.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Motohiro,

KOSAKI Motohiro wrote:
>>> By doing so, we could leave a gcc format string check by passing the
>>> format string to __mark_check_format(). We could extract the field names
>>> from the prototype, so there is no need to duplicate field information
>>> in the format string.
>> I thought that someone complained against those format strings in
>> kernel code. Thus I removed it from DEFINE_TRACE.
>>
>> even though, I think you can do that by adding below string table
>> to LTTng module.
>>
>> const char *lookup_table[MAX_MARKERS][2] = {
>> {"irq_entry", "%d %d"}, // or "(int irq_id, int kernel_mode)", "%d %d"
>> ...
>> };
> 
> if move string to out of kernel core, compiler may kill some variable.
> thus, we will get incomplete tracing result.

I think you might worry about the lookup_table variable will be removed
by compiler if the variable is not referred from nowhere, right?

Here what I said is, if LTTng needs printf-style format, LTTng can "have"
a lookup table in its module. In that case, since LTTng must have (at
least one) functions which refers the lookup table, it is not optimized out.

Of course, LTTng maintainers have to put their eyes on changes of markers
and related variables/structures, and change the lookup table if they need.
(If they have a good c-style parameter parser, the maintenance cost
can be reduced...)

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

