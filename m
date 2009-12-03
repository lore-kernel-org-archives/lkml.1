Return-Path: <linux-kernel-owner+w=401wt.eu-S1754554AbZLCLaT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554AbZLCLaT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 06:30:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753787AbZLCLaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 06:30:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53608 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753511AbZLCLaR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 06:30:17 -0500
Message-ID: <4B17A1CD.8060706@redhat.com>
Date: Thu, 03 Dec 2009 06:32:29 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Thunderbird/3.0b4
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
References: <4B128ECF.9020906@redhat.com> <20091202204637.25408.41195.stgit@dhcp-100-2-132.bos.redhat.com> <20091203103935.GA7628@elte.hu>
In-Reply-To: <20091203103935.GA7628@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> 
> * Masami Hiramatsu <mhiramat@redhat.com> wrote:
> 
>> Add signal coredump tracepoint which shows signal number, mm->flags, 
>> limits, pointer to file structure and core file name.
> 
> Why is the kernel pointer to the file structure logged? User-space has 
> no use for it and the analysis value is low.

Ah, if open() or opening pipe fails, it becomes 0 or -ERRNO,
so we can check if there is an error.

Perhaps, we can do below in trace_printk for trace users.
"open %s", (!file || IS_ERR((void *)file)) ? "failed" : "succeeded"

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

