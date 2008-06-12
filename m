Return-Path: <linux-kernel-owner+w=401wt.eu-S1757757AbYFLG40@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757757AbYFLG40 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 02:56:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756686AbYFLG4C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 02:56:02 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:15104 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756597AbYFLGz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 02:55:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:references;
        b=u+UHB14kXOq7MQgdLa6plu0GclfeB2/cv6A7oHUqu3loIKV5zlshBvTEJFqx4XKLx+
         X2sQECd+qF0MhhPBdjdBLt5Axycsmr18u3wCxaMuq5/D/j6Mu4c+QHFzOGnzzcLvocpI
         QgHbFOhdC0722n1qscSnI7bm9S3vgfNWo4gJk=
Message-ID: <19f34abd0806112355v7330ccd4x41e66151f333c144@mail.gmail.com>
Date: Thu, 12 Jun 2008 08:55:59 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Alessandro Suardi" <alessandro.suardi@gmail.com>,
       "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: [2.6.26-rc5-git2] WARNING: at kernel/lockdep.c:2658 check_flags+0x4c/0x128()
Cc: LKML <linux-kernel@vger.kernel.org>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>
In-Reply-To: <5a4c581d0806111506m31412b21lee7bb851dabe6576@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_10445_32843025.1213253759224"
References: <5a4c581d0806111506m31412b21lee7bb851dabe6576@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_10445_32843025.1213253759224
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

Thanks for reporting!

On Thu, Jun 12, 2008 at 12:06 AM, Alessandro Suardi
<alessandro.suardi@gmail.com> wrote:
> Recently upgraded my FC6 desktop to Fedora 9; with the
>  latest nautilus RPM updates my VNC session went nuts
>  with nautilus pegging the CPU for everything that breathed.
>
> I now reverted to an earlier nautilus package, but during
>  the peak CPU period my kernel spat this:
>
> [314185.623294] ------------[ cut here ]------------
> [314185.623414] WARNING: at kernel/lockdep.c:2658 check_flags+0x4c/0x128()
> [314185.623514] Modules linked in: iptable_filter ip_tables x_tables
> sunrpc ipv6 fuse snd_via82xx snd_ac97_codec ac97_bus snd_mpu401_uart
> snd_rawmidi via686a hwmon parport_pc sg parport uhci_hcd ehci_hcd
> [314185.623924] Pid: 12314, comm: nautilus Not tainted 2.6.26-rc5-git2 #4
> [314185.624021]  [<c0115b95>] warn_on_slowpath+0x41/0x7b
> [314185.624021]  [<c010de70>] ? do_page_fault+0x2c1/0x5fd
> [314185.624021]  [<c0128396>] ? up_read+0x16/0x28
> [314185.624021]  [<c010de70>] ? do_page_fault+0x2c1/0x5fd
> [314185.624021]  [<c012fa33>] ? __lock_acquire+0xbb4/0xbc3
> [314185.624021]  [<c012d0a0>] check_flags+0x4c/0x128
> [314185.624021]  [<c012fa73>] lock_acquire+0x31/0x7d
> [314185.624021]  [<c0128cf6>] __atomic_notifier_call_chain+0x30/0x80
> [314185.624021]  [<c0128cc6>] ? __atomic_notifier_call_chain+0x0/0x80
> [314185.624021]  [<c0128d52>] atomic_notifier_call_chain+0xc/0xe
> [314185.624021]  [<c0128d81>] notify_die+0x2d/0x2f
> [314185.624021]  [<c01043b0>] do_int3+0x1f/0x4d
> [314185.624021]  [<c02f2d3b>] int3+0x27/0x2c
> [314185.624021]  =======================
> [314185.624021] ---[ end trace 1923f65a2d7bb246 ]---
> [314185.624021] possible reason: unannotated irqs-off.
> [314185.624021] irq event stamp: 488879
> [314185.624021] hardirqs last  enabled at (488879): [<c0102d67>]
> restore_nocheck+0x12/0x15
> [314185.624021] hardirqs last disabled at (488878): [<c0102dca>]
> work_resched+0x19/0x30
> [314185.624021] softirqs last  enabled at (488876): [<c011a1ba>]
> __do_softirq+0xa6/0xac
> [314185.624021] softirqs last disabled at (488865): [<c010476e>]
> do_softirq+0x57/0xa6
>
> I didn't seem to find it with some googling, so here it is.
>
> I was incidentally ltracing that process to try and find out
>  what was gulping down that much CPU (sorry, no idea
>  whether ltrace and the WARNING happened at the same
>  time or which came first) and:

Yeah, this is extremely likely to be the source of the warning.

The warning should be harmless, however.

> Box is my trusty noname K7-800, 512MB RAM; if there's
>  anything else useful I might be able to provide, just ask.

It would be interesting to see where the int3 comes from.  Too bad,
lockdep doesn't provide the register dump. The stacktrace also doesn't
go further than the int3(), I wonder if this int3 came from userspace?
The ltrace readme says "software breakpoints, like gdb", so I guess
this is the case. Yep, seems like it.

This looks relevant, so I'm adding a Cc here as well:

commit fb1dac909d94ff807cd833d340c6827c3a957159
Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date:   Wed Jan 16 09:51:59 2008 +0100

    lockdep: more hardirq annotations for notify_die()

I'm attaching a similarly-looking patch for this case (DO_VM86_ERROR),
though I suspect it might be missing for the other cases
(DO_ERROR/DO_ERROR_INFO) as well.

Does this look like the right fix?

(The patch is also inlined, but expect whitespace breakage.)


Vegard


From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Thu, 12 Jun 2008 08:49:18 +0200
Subject: [PATCH] x86: more hardirq annotations for notify_die()

Reported-by: Alessandro Suardi <alessandro.suardi@gmail.com>
Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 arch/x86/kernel/traps_32.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/traps_32.c b/arch/x86/kernel/traps_32.c
index bde6f63..be9ecae 100644
--- a/arch/x86/kernel/traps_32.c
+++ b/arch/x86/kernel/traps_32.c
@@ -569,6 +569,7 @@ void do_##name(struct pt_regs *regs, long error_code)			\
 #define DO_VM86_ERROR(trapnr, signr, str, name)				\
 void do_##name(struct pt_regs *regs, long error_code)			\
 {									\
+	trace_hardirqs_fixup();						\
 	if (notify_die(DIE_TRAP, str, regs, error_code, trapnr, signr)	\
 						== NOTIFY_STOP)		\
 		return;							\
-- 
1.5.4.1

------=_Part_10445_32843025.1213253759224
Content-Type: text/x-patch;
 name=0001-x86-more-hardirq-annotations-for-notify_die.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fhczw6xr0
Content-Disposition: attachment;
 filename=0001-x86-more-hardirq-annotations-for-notify_die.patch

RnJvbSBmMzIzZjQxZDdmMDk2ODM4MWU4NzE2NzNmNjM0MzA2Y2U0YjA3ZmY1IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBWZWdhcmQgTm9zc3VtIDx2ZWdhcmQubm9zc3VtQGdtYWlsLmNv
bT4KRGF0ZTogVGh1LCAxMiBKdW4gMjAwOCAwODo0OToxOCArMDIwMApTdWJqZWN0OiBbUEFUQ0hd
IHg4NjogbW9yZSBoYXJkaXJxIGFubm90YXRpb25zIGZvciBub3RpZnlfZGllKCkKClJlcG9ydGVk
LWJ5OiBBbGVzc2FuZHJvIFN1YXJkaSA8YWxlc3NhbmRyby5zdWFyZGlAZ21haWwuY29tPgpTaWdu
ZWQtb2ZmLWJ5OiBWZWdhcmQgTm9zc3VtIDx2ZWdhcmQubm9zc3VtQGdtYWlsLmNvbT4KLS0tCiBh
cmNoL3g4Ni9rZXJuZWwvdHJhcHNfMzIuYyB8ICAgIDEgKwogMSBmaWxlcyBjaGFuZ2VkLCAxIGlu
c2VydGlvbnMoKyksIDAgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvYXJjaC94ODYva2VybmVs
L3RyYXBzXzMyLmMgYi9hcmNoL3g4Ni9rZXJuZWwvdHJhcHNfMzIuYwppbmRleCBiZGU2ZjYzLi5i
ZTllY2FlIDEwMDY0NAotLS0gYS9hcmNoL3g4Ni9rZXJuZWwvdHJhcHNfMzIuYworKysgYi9hcmNo
L3g4Ni9rZXJuZWwvdHJhcHNfMzIuYwpAQCAtNTY5LDYgKzU2OSw3IEBAIHZvaWQgZG9fIyNuYW1l
KHN0cnVjdCBwdF9yZWdzICpyZWdzLCBsb25nIGVycm9yX2NvZGUpCQkJXAogI2RlZmluZSBET19W
TTg2X0VSUk9SKHRyYXBuciwgc2lnbnIsIHN0ciwgbmFtZSkJCQkJXAogdm9pZCBkb18jI25hbWUo
c3RydWN0IHB0X3JlZ3MgKnJlZ3MsIGxvbmcgZXJyb3JfY29kZSkJCQlcCiB7CQkJCQkJCQkJXAor
CXRyYWNlX2hhcmRpcnFzX2ZpeHVwKCk7CQkJCQkJXAogCWlmIChub3RpZnlfZGllKERJRV9UUkFQ
LCBzdHIsIHJlZ3MsIGVycm9yX2NvZGUsIHRyYXBuciwgc2lnbnIpCVwKIAkJCQkJCT09IE5PVElG
WV9TVE9QKQkJXAogCQlyZXR1cm47CQkJCQkJCVwKLS0gCjEuNS40LjEKCg==
------=_Part_10445_32843025.1213253759224--
