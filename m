Return-Path: <linux-kernel-owner+w=401wt.eu-S1760953AbYGOCCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760953AbYGOCCU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 22:02:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754692AbYGOCCM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 22:02:12 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:57646 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754236AbYGOCCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 22:02:12 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Elias Oltmanns <eo@nebensachen.de>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Clark Williams <clark.williams@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jon Masters <jonathan@jonmasters.org>
References: <Pine.LNX.4.58.0807101242070.3740@gandalf.stny.rr.com>
	<87zlop7bp6.fsf@denkblock.local>
	<20080710132832.38cc5048.randy.dunlap@oracle.com>
	<Pine.LNX.4.58.0807101956120.7719@gandalf.stny.rr.com>
	<Pine.LNX.4.58.0807102035550.7719@gandalf.stny.rr.com>
	<20080711121655.05810822.akpm@linux-foundation.org>
	<Pine.LNX.4.58.0807111546560.25977@gandalf.stny.rr.com>
	<20080711153740.b86acadd.akpm@linux-foundation.org>
	<m13amg9fl0.fsf@frodo.ebiederm.org>
	<Pine.LNX.4.58.0807142105390.2955@gandalf.stny.rr.com>
	<m1r69wj5t8.fsf@frodo.ebiederm.org>
	<Pine.LNX.4.58.0807142142070.4223@gandalf.stny.rr.com>
Date: Mon, 14 Jul 2008 18:59:05 -0700
In-Reply-To: <Pine.LNX.4.58.0807142142070.4223@gandalf.stny.rr.com> (Steven
	Rostedt's message of "Mon, 14 Jul 2008 21:43:46 -0400 (EDT)")
Message-ID: <m13ambkivq.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Steven Rostedt <rostedt@goodmis.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.2 BAYES_40 BODY: Bayesian spam probability is 20 to 40%
	*      [score: 0.3609]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH -v2] ftrace: Documentation
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt <rostedt@goodmis.org> writes:

> On Mon, 14 Jul 2008, Eric W. Biederman wrote:
>
>>
>> Steven Rostedt <rostedt@goodmis.org> writes:
>>
>> > Actually it is a /debug (or /sys/mount/debug if you prefer) file.
>>
>> Got it.  I haven't ever actually seen anyone use debugfs.
>>
>> > I'd be interested in knowing who would want namespaces in traces. I've
>> > basically only used tracing to see "what's happening in the kernel here?".
>> > Where I only use the pid to differentiate between the tasks I know are
>> > running.
>>
>> > Hence, tracing is much like printk. Does it really matter with these
>> > outputs. But ftrace is pluggable, pid namespaces may matter in future
>> > plugins.
>
> Bare with me, I'm new to the namespace concept of pids.

Sure.  Just bare with me as I am new to the concept of ftrace.

>> So it would not be hard to capture the pid namespace in mount or
>> even look at current to get it (although the last is a little odd).
>
>>From userspace or from with the kernel (doing the trace)
>
>>
>> I'm not at all certain if it makes sense.  If this is something
>> an ordinary user could use then we definitely want to do something.
>>
>> Is tracing possible without inserting kernel modules?
>
> The tracer is built into the kernel (no module needed).

Ok.  So this is something simpler to use then SystemTap.  Yeah.

It sounds like it is reasonable or at least semi reasonable to use
this as an unprivileged user.

The easiest model to think of this in is a chroot that does pids as
well as the filesystem.  In which case if you are inside one and
you use the tracer.  You want pids that are meaningful in your
subset of userspace, and not the global ones.

Eric

