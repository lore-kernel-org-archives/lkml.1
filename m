Return-Path: <linux-kernel-owner+w=401wt.eu-S1754428AbYACVce@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428AbYACVce (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 16:32:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752769AbYACVc0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 16:32:26 -0500
Received: from mx1.redhat.com ([66.187.233.31]:58605 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752745AbYACVcZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 16:32:25 -0500
Message-ID: <477D5447.6090804@redhat.com>
Date: Thu, 03 Jan 2008 16:31:51 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Abhishek Sagar <sagar.abhishek@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Harvey Harrison <harvey.harrison@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, qbarnes@gmail.com,
       ananth@in.ibm.com, jkenisto@us.ibm.com
Subject: Re: [PATCH] x86: kprobes change kprobe_handler flow
References: <1198806265.6323.34.camel@brick> <4778E8B0.6010400@gmail.com>	 <20080101153558.GJ4434@elte.hu> <477A971A.8030006@gmail.com>	 <477BD366.1060504@redhat.com> <863e9df20801021131j3a4d655dgd00fa60e39a97ec@mail.gmail.com> <477C08A0.503@redhat.com> <477D184A.8090009@redhat.com>
In-Reply-To: <477D184A.8090009@redhat.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Abhishek,

Masami Hiramatsu wrote:
>> Hmm, I can not agree, because it is possible to insert a kprobe
>> into kprobe's instruction buffer. If it should be a bug, we must
>> check it when registering the kprobe.
> 
> I discussed it with other maintainers and knew that current kprobes
> does not allow user to insert a kprobe to another kprobe's instruction
> buffer, because register_kprobe ensures the insertion address is text.
> Now I changed my mind. I think that case (p && kprobe_running() &&
> kcb->kprobe_status==KPROBE_HIT_SS) is BUG(), even if (*p->ainsn.insn ==
> BREAKPOINT_INSTRUCTION).

I could understand what the original code did at last.
If a kprobe is inserted on a breakpoint which other debugger inserts,
it single step inline instead of out-of-line.(this is done in prepare_singlestep)
In this case, (p && kprobe_running() && kcb->kprobe_status==KPROBE_HIT_SS)
is true and we need pass the control to the debugger.
And if (*p->ainsn.insn != BREAKPOINT_INSTRUCTION) (or (p != kprobe_running())) in
that case, there may be some bugs.

Now I think your original suggestion is correct.
Please fix it in another patch.

Thank you very much,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com, masami.hiramatsu.pt@hitachi.com

