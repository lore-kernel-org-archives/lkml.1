Return-Path: <linux-kernel-owner+w=401wt.eu-S1754288AbYGaNtX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754288AbYGaNtX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 09:49:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752466AbYGaNtM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 09:49:12 -0400
Received: from ik-out-1112.google.com ([66.249.90.181]:19745 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426AbYGaNtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 09:49:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:references;
        b=ju5QvCkZU68+xpHKqeNv1cSN9KTPzJQVDFsOV0Vv1kA/75qHk8hU8aL8kDpkQ9pfIt
         rJmX3y6bQ9sc1Bx49YqgudGlDeNDdL9W8I/l1RIFhuP1t1M6ZPFB253R9s86gNtJZ98w
         zWAlcmEgYpSIONUKlsh2LCNsbDDChXgDW2014=
Message-ID: <520f0cf10807310649l1083e29bmf0f704e13dee96c@mail.gmail.com>
Date: Thu, 31 Jul 2008 15:49:07 +0200
From: "John Kacur" <jkacur@gmail.com>
To: "Sebastien Dugue" <sebastien.dugue@bull.net>
Subject: Re: [PATCH] Fix Bug messages
Cc: "Chirag Jog" <chirag@linux.vnet.ibm.com>,
       "J?rgen Mell" <j.mell@t-online.de>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       "Steven Rostedt" <rostedt@goodmis.org>,
       "Clark Williams" <williams@redhat.com>,
       "Peter Zijlstra" <peterz@infradead.org>,
       "Josh Triplett" <josht@linux.vnet.ibm.com>,
       "Timothy R. Chavez" <tim.chavez@linux.vnet.ibm.com>
In-Reply-To: <20080731132336.362bd487@bull.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_5274_29801815.1217512147331"
References: <alpine.LFD.1.10.0807252141420.574@apollo.tec.linutronix.de>
	 <alpine.LFD.1.10.0807291440240.14925@apollo.tec.linutronix.de>
	 <alpine.LFD.1.10.0807300006180.14925@apollo.tec.linutronix.de>
	 <200807301101.32417.j.mell@t-online.de>
	 <20080730171842.GB3420@linux.vnet.ibm.com>
	 <20080731100023.0221ec2b@bull.net>
	 <520f0cf10807310313q45599221q3db1b6fd7e7c722f@mail.gmail.com>
	 <20080731132336.362bd487@bull.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_5274_29801815.1217512147331
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Thu, Jul 31, 2008 at 1:23 PM, Sebastien Dugue
<sebastien.dugue@bull.net> wrote:
>  Hi John,
>
> On Thu, 31 Jul 2008 12:13:24 +0200 "John Kacur" <jkacur@gmail.com> wrote:
>
>> On Thu, Jul 31, 2008 at 10:00 AM, Sebastien Dugue
>> <sebastien.dugue@bull.net> wrote:
>> > On Wed, 30 Jul 2008 22:48:42 +0530 Chirag Jog <chirag@linux.vnet.ibm.c=
om> wrote:
>> >
>> >> * J?rgen Mell <j.mell@t-online.de> [2008-07-30 11:01:32]:
>> >>
>> >> > Hello Thomas,
>> >> >
>> >> > On Wednesday, 30. July 2008, Thomas Gleixner wrote:
>> >> > > We are pleased to announce the 2.6.26-rt1 tree, which can be
>> >> > > downloaded from the location:
>> >> >
>> >> > I have tried the new kernel and have some good news and some bad ne=
ws:
>> >> >
>> >> > The good news: The machine boots and seems to run without major pro=
blems.
>> >> >
>> >> > The bad news: It produces continuously lots of bug messages in the =
error
>> >> > logs (cf. attached dmesg.tgz). The error at rtmutex.c:743 was alrea=
dy
>> >> > present in 2.6.25-rt* when ACPI was enabled. The 'using smp_process=
or_id
>> >> > ()  in preemptible code' is new here with 2.6.26.
>> >> >
>> >> > Machine is an old Athlon XP (single core) on an EPOX mainboard with=
 VIA
>> >> > chipset.
>> >> >
>> >> > If I can help with testing, please let me know.
>> >> >
>> >> > Bye,
>> >> >          J=FCrgen
>> >> >
>> >> >
>> >> This patch should solve some of the bug messages.
>> >> It does two things:
>> >> 1. Change rt_runtime_lock to be a raw spinlock as the comment above i=
t
>> >> says: it is nested inside the rq lock.
>> >>
>> >> 2. Change mnt_writers to be a per_cpu locked variable.
>> >> This eliminates the need for the codepath to disable preemption and
>> >> then potentially sleep, leading to the BUG messages
>> >>
>> >> Signed-Off-By: Chirag <chirag@linux.vnet.ibm.com>
>> >
>> >  Neat, the only remaining BUGs I see are from sock_prot_inuse_add()
>> >
>> > BUG: using smp_processor_id() in preemptible [00000000] code: arping/1=
916
>> > caller is .sock_prot_inuse_add+0x30/0x80
>> > Call Trace:
>> > [c0000000eed2f910] [c000000000010304] .show_stack+0x70/0x1bc (unreliab=
le)
>> > [c0000000eed2f9c0] [c0000000001a2340] .debug_smp_processor_id+0x138/0x=
168
>> > [c0000000eed2fa70] [c0000000002181f4] .sock_prot_inuse_add+0x30/0x80
>> > [c0000000eed2fb10] [c00000000026d96c] .udp_lib_get_port+0x2a8/0x320
>> > [c0000000eed2fbc0] [c000000000275b30] .inet_bind+0x168/0x248
>> > [c0000000eed2fc60] [c000000000215024] .sys_bind+0x98/0xdc
>> > [c0000000eed2fd90] [c0000000002370bc] .compat_sys_socketcall+0xcc/0x21=
4
>> > [c0000000eed2fe30] [c0000000000086ac] syscall_exit+0x0/0x40
>> > BUG: arping:1916 task might have lost a preemption check!
>> > Call Trace:
>> > [c0000000eed2f890] [c000000000010304] .show_stack+0x70/0x1bc (unreliab=
le)
>> > [c0000000eed2f940] [c00000000004e298] .preempt_enable_no_resched+0x60/=
0x78
>> > [c0000000eed2f9c0] [c0000000001a2348] .debug_smp_processor_id+0x140/0x=
168
>> > [c0000000eed2fa70] [c0000000002181f4] .sock_prot_inuse_add+0x30/0x80
>> > [c0000000eed2fb10] [c00000000026d96c] .udp_lib_get_port+0x2a8/0x320
>> > [c0000000eed2fbc0] [c000000000275b30] .inet_bind+0x168/0x248
>> > [c0000000eed2fc60] [c000000000215024] .sys_bind+0x98/0xdc
>> > [c0000000eed2fd90] [c0000000002370bc] .compat_sys_socketcall+0xcc/0x21=
4
>> > [c0000000eed2fe30] [c0000000000086ac] syscall_exit+0x0/0x40
>> >
>>
>> Does this simple fix do the trick for you?
>>
>>Signed-off-by: John Kacur <jkacur@gmail.com>
>>
>>Index: linux-2.6.26-rt1/net/core/sock.c
>>=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>--- linux-2.6.26-rt1.orig/net/core/sock.c
>>+++ linux-2.6.26-rt1/net/core/sock.c
>>@@ -1943,7 +1943,7 @@ static DECLARE_BITMAP(proto_inuse_idx, P
>> #ifdef CONFIG_NET_NS
>> void sock_prot_inuse_add(struct net *net, struct proto *prot, int val)
>> {
>>-      int cpu =3D smp_processor_id();
>>+      int cpu =3D raw_smp_processor_id();
>>       per_cpu_ptr(net->core.inuse, cpu)->val[prot->inuse_idx] +=3D val;
>> }
>> EXPORT_SYMBOL_GPL(sock_prot_inuse_add);
>
>  Nope, still the same BUGs, I do not have the net namespaces configured, =
so the
> version of sock_prot_inuse_add() which is used is defined a few lines bel=
ow:
>
> static DEFINE_PER_CPU(struct prot_inuse, prot_inuse);
>
> void sock_prot_inuse_add(struct net *net, struct proto *prot, int val)
> {
>        __get_cpu_var(prot_inuse).val[prot->inuse_idx] +=3D val;
> }
> EXPORT_SYMBOL_GPL(sock_prot_inuse_add);
>
>  Looks like another case of percpu variables Chirag has benn fixing.
>
>  Sebastien.
>

Pls withdraw my last patch. Ok, please use with caution, I'm still
testing, but trying to follow Chirag's example, does this patch help
you?
(Let's consider this patch as for review)

------=_Part_5274_29801815.1217512147331
Content-Type: text/x-patch; name=sock_prot_inuse_add-fix.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fjbef83b0
Content-Disposition: attachment; filename=sock_prot_inuse_add-fix.patch

U2lnbmVkLW9mZi1ieTogSm9obiBLYWN1ciA8amthY3VyQGdtYWlsLmNvbT4KSW5kZXg6IGxpbnV4
LTIuNi4yNi1ydDEvbmV0L2NvcmUvc29jay5jCj09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0KLS0tIGxpbnV4LTIuNi4yNi1y
dDEub3JpZy9uZXQvY29yZS9zb2NrLmMKKysrIGxpbnV4LTIuNi4yNi1ydDEvbmV0L2NvcmUvc29j
ay5jCkBAIC0xOTg2LDExICsxOTg2LDEyIEBAIHN0YXRpYyBfX2luaXQgaW50IG5ldF9pbnVzZV9p
bml0KHZvaWQpCiAKIGNvcmVfaW5pdGNhbGwobmV0X2ludXNlX2luaXQpOwogI2Vsc2UKLXN0YXRp
YyBERUZJTkVfUEVSX0NQVShzdHJ1Y3QgcHJvdF9pbnVzZSwgcHJvdF9pbnVzZSk7CitzdGF0aWMg
REVGSU5FX1BFUl9DUFVfTE9DS0VEKHN0cnVjdCBwcm90X2ludXNlLCBwcm90X2ludXNlKTsKIAog
dm9pZCBzb2NrX3Byb3RfaW51c2VfYWRkKHN0cnVjdCBuZXQgKm5ldCwgc3RydWN0IHByb3RvICpw
cm90LCBpbnQgdmFsKQogewotCV9fZ2V0X2NwdV92YXIocHJvdF9pbnVzZSkudmFsW3Byb3QtPmlu
dXNlX2lkeF0gKz0gdmFsOworCWludCBjcHUgPSAwOworCV9fZ2V0X2NwdV92YXJfbG9ja2VkKHBy
b3RfaW51c2UsIGNwdSkudmFsW3Byb3QtPmludXNlX2lkeF0gKz0gdmFsOwogfQogRVhQT1JUX1NZ
TUJPTF9HUEwoc29ja19wcm90X2ludXNlX2FkZCk7CiAKQEAgLTIwMDAsNyArMjAwMSw3IEBAIGlu
dCBzb2NrX3Byb3RfaW51c2VfZ2V0KHN0cnVjdCBuZXQgKm5ldCwKIAlpbnQgcmVzID0gMDsKIAog
CWZvcl9lYWNoX3Bvc3NpYmxlX2NwdShjcHUpCi0JCXJlcyArPSBwZXJfY3B1KHByb3RfaW51c2Us
IGNwdSkudmFsW2lkeF07CisJCXJlcyArPSBwZXJfY3B1X3Zhcl9sb2NrZWQocHJvdF9pbnVzZSwg
Y3B1KS52YWxbaWR4XTsKIAogCXJldHVybiByZXMgPj0gMCA/IHJlcyA6IDA7CiB9Cg==
------=_Part_5274_29801815.1217512147331--
