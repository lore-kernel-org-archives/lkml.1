Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060Ab0CNCHa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 21:07:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54072 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751155Ab0CNCH2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 21:07:28 -0500
Message-ID: <4B9C446A.9020208@redhat.com>
Date: Sat, 13 Mar 2010 21:05:30 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc11 Thunderbird/3.0.3
MIME-Version: 1.0
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
CC: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Dieter Ries <mail@dieterries.net>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: Re: [PATCH -tip 1/3] kprobes: Hide CONFIG_OPTPROBES and set if arch
 support optimized kprobes
References: <20100312232208.2017.55337.stgit@localhost6.localdomain6> <87k4tfyd08.fsf@devron.myhome.or.jp>
In-Reply-To: <87k4tfyd08.fsf@devron.myhome.or.jp>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OGAWA Hirofumi wrote:
> Masami Hiramatsu <mhiramat@redhat.com> writes:
> 
>> Hide CONFIG_OPTPROBES and set if arch support optimized kprobes, since
>> this option doesn't change the behavior of kprobes, but just reduces
>> the overhead.
> 
> I don't so care whether this is configurable or not, but this confuses
> me now. The following seems to say it's changed, but now this comment
> says it wasn't changed. The following docs was obsoleted?
> 
> Thanks.
> 
> NOTE for geeks:
> The jump optimization changes the kprobe's pre_handler behavior.
> Without optimization, the pre_handler can change the kernel's execution
> path by changing regs->ip and returning 1.  However, when the probe
> is optimized, that modification is ignored.  Thus, if you want to
> tweak the kernel's execution path, you need to suppress optimization,
> using one of the following techniques:

Ah, good point. This is only one point of changing the behavior.
So if someone makes an out of tree module for changing the ip
address by using kprobes, e.g. live code patching or something
like that, it will be affected by this change.
However, I think using kprobes for this way is not obviously
documented, moreover, some workarounds for that are documented
as above. So I don't worried about it.

Anyway, indeed, the patch comment is wrong. I need to say "this option
doesn't change the major behavior of kprobes, and workarounds for minor
change are documented." :)

Thank you for pointing it out!


-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com
