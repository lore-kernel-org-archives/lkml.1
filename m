Return-Path: <linux-kernel-owner+w=401wt.eu-S1761230AbYHUTdq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761230AbYHUTdq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 15:33:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756159AbYHUTdh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 15:33:37 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:4258 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754052AbYHUTdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 15:33:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:references;
        b=f1FcuGXz1Oq3sch0P6ISLg6o0GUghx0UiA8FC70Kw21Vtysa/JMik28/FiopM3SJ5M
         s6yKutV1Cfs7iW46XTg6SDlzA7BQwvHgeLiXBcMAHWypBRyQJT/jKBv3o4HgDctskzhj
         8o7nurkcbJhAM2DUy23aTmQxWA4zedr9e37Ps=
Message-ID: <520f0cf10808211233g1da3f06pf422c26accb70bf@mail.gmail.com>
Date: Thu, 21 Aug 2008 21:33:33 +0200
From: "John Kacur" <jkacur@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: 2.6.26.3-rt2
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Chirag Jog" <chirag@linux.vnet.ibm.com>
In-Reply-To: <1219339082.22710.16.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_60447_28598297.1219347213989"
References: <1219339082.22710.16.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_60447_28598297.1219347213989
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Thu, Aug 21, 2008 at 7:18 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> We are pleased to announce the 2.6.26.3-rt2 tree, which can be
> downloaded from the location:
>
>  http://rt.et.redhat.com/download/
>
> Information on the RT patch can be found at:
>
>  http://rt.wiki.kernel.org/index.php/Main_Page
>
> Changes since 2.6.26-rt1
>
>  - ported to 2.6.26.3
>
>  - basic compile fixes (Steven Rostedt)
>
>  - basic raw lock conversions (Steven Rostedt)
>
>  - powerpc: irq radix tree updates (Sebastien Dugue)
>
>  - call_rcu_sched (Paul E. McKenney)
>
>  - rcu trace preemption fixes (Paul E. Mckenney)
>
>  - remove lock in pm_qos_requirement (John Kacur)
>
>  - rcu_process_callbacks (Paul E. McKenney)
>
>  - rcu memory barriers update (Paul E. McKenney)
>
>  - shorten posix_cpu_timers thread names (Arnaldo Carvalho de Melo)
>
>  - account IRQ and RT load in SCHED_OTHER (Peter Zijlstra)
>
>  - seq_lock updates/fixes (Gregory Haskins)
>
> to build a 2.6.26.3-rt2 tree, the following patches should be applied:
>
>  http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.26.tar.bz2
>  http://kernel.org/pub/linux/kernel/v2.6/patch-2.6.26.3.bz2
>  http://rt.et.redhat.com/download/patch-2.6.26.3-rt2.bz2
>
>
>
> And like always, my RT version of Matt Mackall's ketchup will get this
> for you nicely:
>
>  http://people.redhat.com/srostedt/rt/tools/ketchup-0.9.8-rt3
>
>
> The broken out patches are also available.
>

Hi Steve

Probably one of the most important patches that was missed is the one
from Chirag. I've taken it and updated it against 2.6.26.3-rt2 for
you, in case that will speed up -rt3 (see attached). (two hunks were
rejected because another applied fix fixed the same thing as part of
Chirag's patch.

I've compiled and done some limited testing, and among other things it
removes this kind of message.
BUG: sleeping function called from invalid context hald-runner(12244)
at kernel/rtmutex.c:743
in_atomic():1 [00000001], irqs_disabled():0
Pid: 12244, comm: hald-runner Tainted: G        W 2.6.26.3-rt2 #1

Call Trace:
 [<ffffffff802d3cda>] ? mnt_want_write+0x19/0xbc
 [<ffffffff802307b6>] __might_sleep+0x12d/0x132
 [<ffffffff8046d3de>] __rt_spin_lock+0x34/0x7d
 [<ffffffff8046d435>] rt_spin_lock+0xe/0x10
 [<ffffffff802d3cfc>] mnt_want_write+0x3b/0xbc
 [<ffffffff802cea88>] touch_atime+0x1c/0x101
 [<ffffffff802c426c>] __link_path_walk+0x484/0xf24
 [<ffffffff802c4d72>] path_walk+0x66/0xc9
 [<ffffffff802c51bf>] do_path_lookup+0x209/0x264
 [<ffffffff802c5509>] __path_lookup_intent_open+0x61/0xa4
 [<ffffffff802c555d>] path_lookup_open+0x11/0x13
 [<ffffffff802c61f1>] do_filp_open+0xb6/0x8f5
 [<ffffffff8046d3de>] ? __rt_spin_lock+0x34/0x7d
 [<ffffffff802b897d>] ? get_unused_fd_flags+0x119/0x12a
 [<ffffffff802b89e4>] do_sys_open+0x56/0xd6
 [<ffffffff8020c374>] ? system_call_after_swapgs+0xc4/0x168
 [<ffffffff802b8a97>] sys_open+0x20/0x22
 [<ffffffff8020c3ab>] system_call_after_swapgs+0xfb/0x168

---------------------------
| preempt count: 00000001 ]
| 1-level deep critical section nesting:
----------------------------------------
.. [<ffffffff802d3cda>] .... mnt_want_write+0x19/0xbc
.....[<ffffffff802cea88>] ..   ( <= touch_atime+0x1c/0x101)

------=_Part_60447_28598297.1219347213989
Content-Type: text/x-patch; name=fix-bug-messages.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fk5rru060
Content-Disposition: attachment; filename=fix-bug-messages.patch

RnJvbTogY2hpcmFnQGxpbnV4LnZuZXQuaWJtLmNvbSBDaGlyYWcgSm9nIApUbzogai5tZWxsQHQt
b25saW5lLmRlIEo/cmdlbiBNZWxsLCB0Z2x4QGxpbnV0cm9uaXguZGUgVGhvbWFzIEdsZWl4bmVy
IApEYXRlOiBXZWQsIDMwIEp1bCAyMDA4IDE5OjE4OjQyICswMjAwIApTdWJqZWN0OiBbUEFUQ0hd
IEZpeCBCdWcgbWVzc2FnZXMgCgpUaGlzIHBhdGNoIHNob3VsZCBzb2x2ZSBzb21lIG9mIHRoZSBi
dWcgbWVzc2FnZXMuCkl0IGRvZXMgdHdvIHRoaW5nczoKMS4gQ2hhbmdlIHJ0X3J1bnRpbWVfbG9j
ayB0byBiZSBhIHJhdyBzcGlubG9jayBhcyB0aGUgY29tbWVudCBhYm92ZSBpdApzYXlzOiBpdCBp
cyBuZXN0ZWQgaW5zaWRlIHRoZSBycSBsb2NrLgoKMi4gQ2hhbmdlIG1udF93cml0ZXJzIHRvIGJl
IGEgcGVyX2NwdSBsb2NrZWQgdmFyaWFibGUuClRoaXMgZWxpbWluYXRlcyB0aGUgbmVlZCBmb3Ig
dGhlIGNvZGVwYXRoIHRvIGRpc2FibGUgcHJlZW1wdGlvbiBhbmQKdGhlbiBwb3RlbnRpYWxseSBz
bGVlcCwgbGVhZGluZyB0byB0aGUgQlVHIG1lc3NhZ2VzCgpTaWduZWQtb2ZmLWJ5OiBDaGlyYWcg
PGNoaXJhZ0BsaW51eC52bmV0LmlibS5jb20+Clt1cGRhdGVkIENoaXJhZydzIHBhdGNoIGFnYWlu
c3QgMi42LjI2LjMtcnQzXQpTaWduZWQtb2ZmLWJ5OiBKb2huIEthY3VyIDxqa2FjdXIgYXQgZ21h
aWwgZG90IGNvbT4KCkluZGV4OiBsaW51eC0yLjYuMjYuMy9mcy9uYW1lc3BhY2UuYwo9PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09Ci0tLSBsaW51eC0yLjYuMjYuMy5vcmlnL2ZzL25hbWVzcGFjZS5jCisrKyBsaW51eC0yLjYu
MjYuMy9mcy9uYW1lc3BhY2UuYwpAQCAtMTc4LDEzICsxNzgsMTMgQEAgc3RydWN0IG1udF93cml0
ZXIgewogCXVuc2lnbmVkIGxvbmcgY291bnQ7CiAJc3RydWN0IHZmc21vdW50ICptbnQ7CiB9IF9f
X19jYWNoZWxpbmVfYWxpZ25lZF9pbl9zbXA7Ci1zdGF0aWMgREVGSU5FX1BFUl9DUFUoc3RydWN0
IG1udF93cml0ZXIsIG1udF93cml0ZXJzKTsKK3N0YXRpYyBERUZJTkVfUEVSX0NQVV9MT0NLRUQo
c3RydWN0IG1udF93cml0ZXIsIG1udF93cml0ZXJzKTsKIAogc3RhdGljIGludCBfX2luaXQgaW5p
dF9tbnRfd3JpdGVycyh2b2lkKQogewogCWludCBjcHU7CiAJZm9yX2VhY2hfcG9zc2libGVfY3B1
KGNwdSkgewotCQlzdHJ1Y3QgbW50X3dyaXRlciAqd3JpdGVyID0gJnBlcl9jcHUobW50X3dyaXRl
cnMsIGNwdSk7CisJCXN0cnVjdCBtbnRfd3JpdGVyICp3cml0ZXIgPSAmcGVyX2NwdV92YXJfbG9j
a2VkKG1udF93cml0ZXJzLCBjcHUpOwogCQlzcGluX2xvY2tfaW5pdCgmd3JpdGVyLT5sb2NrKTsK
IAkJbG9ja2RlcF9zZXRfY2xhc3MoJndyaXRlci0+bG9jaywgJndyaXRlci0+bG9ja19jbGFzcyk7
CiAJCXdyaXRlci0+Y291bnQgPSAwOwpAQCAtMTk5LDcgKzE5OSw3IEBAIHN0YXRpYyB2b2lkIHVu
bG9ja19tbnRfd3JpdGVycyh2b2lkKQogCXN0cnVjdCBtbnRfd3JpdGVyICpjcHVfd3JpdGVyOwog
CiAJZm9yX2VhY2hfcG9zc2libGVfY3B1KGNwdSkgewotCQljcHVfd3JpdGVyID0gJnBlcl9jcHUo
bW50X3dyaXRlcnMsIGNwdSk7CisJCWNwdV93cml0ZXIgPSAmcGVyX2NwdV92YXJfbG9ja2VkKG1u
dF93cml0ZXJzLCBjcHUpOwogCQlzcGluX3VubG9jaygmY3B1X3dyaXRlci0+bG9jayk7CiAJfQog
fQpAQCAtMjUxLDggKzI1MSw4IEBAIGludCBtbnRfd2FudF93cml0ZShzdHJ1Y3QgdmZzbW91bnQg
Km1udCkKIHsKIAlpbnQgcmV0ID0gMDsKIAlzdHJ1Y3QgbW50X3dyaXRlciAqY3B1X3dyaXRlcjsK
LQotCWNwdV93cml0ZXIgPSAmZ2V0X2NwdV92YXIobW50X3dyaXRlcnMpOworCWludCBjcHUgPSAw
OworCWNwdV93cml0ZXIgPSAmZ2V0X2NwdV92YXJfbG9ja2VkKG1udF93cml0ZXJzLCAmY3B1KTsK
IAlzcGluX2xvY2soJmNwdV93cml0ZXItPmxvY2spOwogCWlmIChfX21udF9pc19yZWFkb25seSht
bnQpKSB7CiAJCXJldCA9IC1FUk9GUzsKQEAgLTI2Miw3ICsyNjIsNyBAQCBpbnQgbW50X3dhbnRf
d3JpdGUoc3RydWN0IHZmc21vdW50ICptbnQpCiAJY3B1X3dyaXRlci0+Y291bnQrKzsKIG91dDoK
IAlzcGluX3VubG9jaygmY3B1X3dyaXRlci0+bG9jayk7Ci0JcHV0X2NwdV92YXIobW50X3dyaXRl
cnMpOworCXB1dF9jcHVfdmFyX2xvY2tlZChtbnRfd3JpdGVycywgY3B1KTsKIAlyZXR1cm4gcmV0
OwogfQogRVhQT1JUX1NZTUJPTF9HUEwobW50X3dhbnRfd3JpdGUpOwpAQCAtMjczLDcgKzI3Myw3
IEBAIHN0YXRpYyB2b2lkIGxvY2tfbW50X3dyaXRlcnModm9pZCkKIAlzdHJ1Y3QgbW50X3dyaXRl
ciAqY3B1X3dyaXRlcjsKIAogCWZvcl9lYWNoX3Bvc3NpYmxlX2NwdShjcHUpIHsKLQkJY3B1X3dy
aXRlciA9ICZwZXJfY3B1KG1udF93cml0ZXJzLCBjcHUpOworCQljcHVfd3JpdGVyID0gJnBlcl9j
cHVfdmFyX2xvY2tlZChtbnRfd3JpdGVycywgY3B1KTsKIAkJc3Bpbl9sb2NrKCZjcHVfd3JpdGVy
LT5sb2NrKTsKIAkJX19jbGVhcl9tbnRfY291bnQoY3B1X3dyaXRlcik7CiAJCWNwdV93cml0ZXIt
Pm1udCA9IE5VTEw7CkBAIC0zMzIsOCArMzMyLDggQEAgdm9pZCBtbnRfZHJvcF93cml0ZShzdHJ1
Y3QgdmZzbW91bnQgKm1udAogewogCWludCBtdXN0X2NoZWNrX3VuZGVyZmxvdyA9IDA7CiAJc3Ry
dWN0IG1udF93cml0ZXIgKmNwdV93cml0ZXI7Ci0KLQljcHVfd3JpdGVyID0gJmdldF9jcHVfdmFy
KG1udF93cml0ZXJzKTsKKwlpbnQgY3B1ID0gMDsKKwljcHVfd3JpdGVyID0gJmdldF9jcHVfdmFy
X2xvY2tlZChtbnRfd3JpdGVycywgJmNwdSk7CiAJc3Bpbl9sb2NrKCZjcHVfd3JpdGVyLT5sb2Nr
KTsKIAogCXVzZV9jcHVfd3JpdGVyX2Zvcl9tb3VudChjcHVfd3JpdGVyLCBtbnQpOwpAQCAtMzYw
LDcgKzM2MCw3IEBAIHZvaWQgbW50X2Ryb3Bfd3JpdGUoc3RydWN0IHZmc21vdW50ICptbnQKIAkg
KiBfX21udF93cml0ZXJzIGNhbiB1bmRlcmZsb3cuICBXaXRob3V0IGl0LAogCSAqIHdlIGNvdWxk
IHRoZW9yZXRpY2FsbHkgd3JhcCBfX21udF93cml0ZXJzLgogCSAqLwotCXB1dF9jcHVfdmFyKG1u
dF93cml0ZXJzKTsKKwlwdXRfY3B1X3Zhcl9sb2NrZWQobW50X3dyaXRlcnMsIGNwdSk7CiB9CiBF
WFBPUlRfU1lNQk9MX0dQTChtbnRfZHJvcF93cml0ZSk7CiAKQEAgLTYxMiw3ICs2MTIsNyBAQCBz
dGF0aWMgaW5saW5lIHZvaWQgX19tbnRwdXQoc3RydWN0IHZmc21vCiAJICogY2FuIGNvbWUgaW4u
CiAJICovCiAJZm9yX2VhY2hfcG9zc2libGVfY3B1KGNwdSkgewotCQlzdHJ1Y3QgbW50X3dyaXRl
ciAqY3B1X3dyaXRlciA9ICZwZXJfY3B1KG1udF93cml0ZXJzLCBjcHUpOworCQlzdHJ1Y3QgbW50
X3dyaXRlciAqY3B1X3dyaXRlciA9ICZwZXJfY3B1X3Zhcl9sb2NrZWQobW50X3dyaXRlcnMsIGNw
dSk7CiAJCWlmIChjcHVfd3JpdGVyLT5tbnQgIT0gbW50KQogCQkJY29udGludWU7CiAJCXNwaW5f
bG9jaygmY3B1X3dyaXRlci0+bG9jayk7Cg==
------=_Part_60447_28598297.1219347213989--
