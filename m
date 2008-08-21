Return-Path: <linux-kernel-owner+w=401wt.eu-S1755944AbYHUUBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755944AbYHUUBR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 16:01:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752760AbYHUUBB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 16:01:01 -0400
Received: from gv-out-0910.google.com ([216.239.58.186]:62854 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101AbYHUUA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 16:00:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:references;
        b=fEo3lHCpMGQPzVQLvsTcn5z8POWm0dkRHomzcmrmBYZIvB9kodDxX8HamCZcyGlJim
         GbrjWAVzcnElbJPSOSIrj/+uXxdsW+w6EZ+9TumNrkb+51jGY2gG9YXFiJ6YJdhzuZ5A
         nIIVEWjFNyjmfPDieid22QrdZhOErRgqzAW4k=
Message-ID: <520f0cf10808211300h3de65655x9cd86360efa1348f@mail.gmail.com>
Date: Thu, 21 Aug 2008 22:00:58 +0200
From: "John Kacur" <jkacur@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: 2.6.26.3-rt2
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Chirag Jog" <chirag@linux.vnet.ibm.com>,
       "Peter Zijlstra" <peterz@infradead.org>
In-Reply-To: <520f0cf10808211233g1da3f06pf422c26accb70bf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_60688_22027650.1219348858126"
References: <1219339082.22710.16.camel@localhost.localdomain>
	 <520f0cf10808211233g1da3f06pf422c26accb70bf@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_60688_22027650.1219348858126
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Thu, Aug 21, 2008 at 9:33 PM, John Kacur <jkacur@gmail.com> wrote:
> On Thu, Aug 21, 2008 at 7:18 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>> We are pleased to announce the 2.6.26.3-rt2 tree, which can be
>> downloaded from the location:
>>
>>  http://rt.et.redhat.com/download/
>>
>> Information on the RT patch can be found at:
>>
>>  http://rt.wiki.kernel.org/index.php/Main_Page
>>
>> Changes since 2.6.26-rt1
>>
>>  - ported to 2.6.26.3
>>
>>  - basic compile fixes (Steven Rostedt)
>>
>>  - basic raw lock conversions (Steven Rostedt)
>>
>>  - powerpc: irq radix tree updates (Sebastien Dugue)
>>
>>  - call_rcu_sched (Paul E. McKenney)
>>
>>  - rcu trace preemption fixes (Paul E. Mckenney)
>>
>>  - remove lock in pm_qos_requirement (John Kacur)
>>
>>  - rcu_process_callbacks (Paul E. McKenney)
>>
>>  - rcu memory barriers update (Paul E. McKenney)
>>
>>  - shorten posix_cpu_timers thread names (Arnaldo Carvalho de Melo)
>>
>>  - account IRQ and RT load in SCHED_OTHER (Peter Zijlstra)
>>
>>  - seq_lock updates/fixes (Gregory Haskins)
>>
>> to build a 2.6.26.3-rt2 tree, the following patches should be applied:
>>
>>  http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.26.tar.bz2
>>  http://kernel.org/pub/linux/kernel/v2.6/patch-2.6.26.3.bz2
>>  http://rt.et.redhat.com/download/patch-2.6.26.3-rt2.bz2
>>
>>
>>
>> And like always, my RT version of Matt Mackall's ketchup will get this
>> for you nicely:
>>
>>  http://people.redhat.com/srostedt/rt/tools/ketchup-0.9.8-rt3
>>
>>
>> The broken out patches are also available.
>>
>
> Hi Steve
>
> Probably one of the most important patches that was missed is the one
> from Chirag. I've taken it and updated it against 2.6.26.3-rt2 for
> you, in case that will speed up -rt3 (see attached). (two hunks were
> rejected because another applied fix fixed the same thing as part of
> Chirag's patch.
>
> I've compiled and done some limited testing, and among other things it
> removes this kind of message.
> BUG: sleeping function called from invalid context hald-runner(12244)
> at kernel/rtmutex.c:743
> in_atomic():1 [00000001], irqs_disabled():0
> Pid: 12244, comm: hald-runner Tainted: G        W 2.6.26.3-rt2 #1
>
> Call Trace:
>  [<ffffffff802d3cda>] ? mnt_want_write+0x19/0xbc
>  [<ffffffff802307b6>] __might_sleep+0x12d/0x132
>  [<ffffffff8046d3de>] __rt_spin_lock+0x34/0x7d
>  [<ffffffff8046d435>] rt_spin_lock+0xe/0x10
>  [<ffffffff802d3cfc>] mnt_want_write+0x3b/0xbc
>  [<ffffffff802cea88>] touch_atime+0x1c/0x101
>  [<ffffffff802c426c>] __link_path_walk+0x484/0xf24
>  [<ffffffff802c4d72>] path_walk+0x66/0xc9
>  [<ffffffff802c51bf>] do_path_lookup+0x209/0x264
>  [<ffffffff802c5509>] __path_lookup_intent_open+0x61/0xa4
>  [<ffffffff802c555d>] path_lookup_open+0x11/0x13
>  [<ffffffff802c61f1>] do_filp_open+0xb6/0x8f5
>  [<ffffffff8046d3de>] ? __rt_spin_lock+0x34/0x7d
>  [<ffffffff802b897d>] ? get_unused_fd_flags+0x119/0x12a
>  [<ffffffff802b89e4>] do_sys_open+0x56/0xd6
>  [<ffffffff8020c374>] ? system_call_after_swapgs+0xc4/0x168
>  [<ffffffff802b8a97>] sys_open+0x20/0x22
>  [<ffffffff8020c3ab>] system_call_after_swapgs+0xfb/0x168
>
> ---------------------------
> | preempt count: 00000001 ]
> | 1-level deep critical section nesting:
> ----------------------------------------
> .. [<ffffffff802d3cda>] .... mnt_want_write+0x19/0xbc
> .....[<ffffffff802cea88>] ..   ( <= touch_atime+0x1c/0x101)
>

Another patch that should be included in -rt3 was discussed here.
http://marc.info/?l=linux-rt-users&m=121751295105462&w=2

After some attempts at fixing this myself, Peter Zijlstra offered the
above solution (in the link) which I've been running with ever since,
no changes required, and it solved the problem.
I'm attaching the patch again, I think it would be optimal to get
Peter's Signed-off-by: on it as he is the author of the patch.
No changes or refreshing were required against 2.6.26.3-rt2

------=_Part_60688_22027650.1219348858126
Content-Type: text/x-patch; name=sock_prot_inuse_add-fix.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fk5ss9vo1
Content-Disposition: attachment; filename=sock_prot_inuse_add-fix.patch

VGhpcyBwYXRjaCBkaXNhYmxlcyBwcmVlbXB0aW9uIGZvciBhIHZlcnkgc2hvcnQgdGltZSwgc28g
aXQgZG9lc24ndCBodXJ0CnByZWVtcHQtbGF0ZW5jeS4gVGhlIGF1dGhvciBvZiB0aGlzIHNvbHV0
aW9uIHdhcyBQZXRlciBaaWpsc3RyYS4KClNpZ25lZC1vZmYtYnk6IEpvaG4gS2FjdXIgPGprYWN1
ciBhdCBnbWFpbCBkb3QgY29tPgpJbmRleDogbGludXgtMi42LjI2LjItcnQxLWprL25ldC9jb3Jl
L3NvY2suYwo9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09Ci0tLSBsaW51eC0yLjYuMjYuMi1ydDEtamsub3JpZy9uZXQvY29y
ZS9zb2NrLmMKKysrIGxpbnV4LTIuNi4yNi4yLXJ0MS1qay9uZXQvY29yZS9zb2NrLmMKQEAgLTE5
NDMsOCArMTk0Myw5IEBAIHN0YXRpYyBERUNMQVJFX0JJVE1BUChwcm90b19pbnVzZV9pZHgsIFAK
ICNpZmRlZiBDT05GSUdfTkVUX05TCiB2b2lkIHNvY2tfcHJvdF9pbnVzZV9hZGQoc3RydWN0IG5l
dCAqbmV0LCBzdHJ1Y3QgcHJvdG8gKnByb3QsIGludCB2YWwpCiB7Ci0JaW50IGNwdSA9IHNtcF9w
cm9jZXNzb3JfaWQoKTsKKwlpbnQgY3B1ID0gZ2V0X2NwdSgpOwogCXBlcl9jcHVfcHRyKG5ldC0+
Y29yZS5pbnVzZSwgY3B1KS0+dmFsW3Byb3QtPmludXNlX2lkeF0gKz0gdmFsOworCXB1dF9jcHUo
KTsKIH0KIEVYUE9SVF9TWU1CT0xfR1BMKHNvY2tfcHJvdF9pbnVzZV9hZGQpOwogCkBAIC0xOTkw
LDcgKzE5OTEsOSBAQCBzdGF0aWMgREVGSU5FX1BFUl9DUFUoc3RydWN0IHByb3RfaW51c2UsCiAK
IHZvaWQgc29ja19wcm90X2ludXNlX2FkZChzdHJ1Y3QgbmV0ICpuZXQsIHN0cnVjdCBwcm90byAq
cHJvdCwgaW50IHZhbCkKIHsKLQlfX2dldF9jcHVfdmFyKHByb3RfaW51c2UpLnZhbFtwcm90LT5p
bnVzZV9pZHhdICs9IHZhbDsKKwlpbnQgY3B1ID0gZ2V0X2NwdSgpOworCXBlcl9jcHUocHJvdF9p
bnVzZSwgY3B1KS52YWxbcHJvdC0+aW51c2VfaWR4XSArPSB2YWw7CisJcHV0X2NwdSgpOwogfQog
RVhQT1JUX1NZTUJPTF9HUEwoc29ja19wcm90X2ludXNlX2FkZCk7CiAK
------=_Part_60688_22027650.1219348858126--
