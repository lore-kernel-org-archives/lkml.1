Return-Path: <linux-kernel-owner+w=401wt.eu-S1761650AbXLMKnb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761650AbXLMKnb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 05:43:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750940AbXLMKnW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 05:43:22 -0500
Received: from py-out-1112.google.com ([64.233.166.179]:41157 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850AbXLMKnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 05:43:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:references:x-google-sender-auth;
        b=vb/nRVTc5h78PjVhgeV38oq9O2jLa+5rWre9aW9vnF3nKHrWu6qlKP3fO+jTGuKgJVBxbs01ndTcOXZlA5T/J/vbyYO1ZlTt+g5so78Xo0GvMn4RE3AA0Wkla2qfcoXLlZ6Avz7cMVsxI5A7Cm0e/P5VghCpDOy09CG7NZo4ews=
Message-ID: <3efb10970712130243t2172907cm31c5d3af29383c8b@mail.gmail.com>
Date: Thu, 13 Dec 2007 11:43:16 +0100
From: "Remy Bohmer" <linux@bohmer.net>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: 2.6.23.9-rt13
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <1197524036.15001.15.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_10318_2788266.1197542596608"
References: <1197524036.15001.15.camel@localhost.localdomain>
X-Google-Sender-Auth: 31eb34128fe6933f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_10318_2788266.1197542596608
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello Steven,

If I compile -rt13 I get some compile warnings on ARM (AT91):
1) This one did not exist in rt1:
In file included from kernel/sched.c:911:
kernel/sched_rt.c: In function 'dec_rt_tasks':
kernel/sched_rt.c:88: warning: unused variable 'highest_prio'
2)  This one is there already for a much longer time:
CC      kernel/rcupreempt.o
kernel/rcupreempt.c:1001: warning: 'per_cpu__rcu_dyntick_snapshot'
defined but not used

Both warnings are fixed by the attached patch, but warning 2 needs some review.
This var is defined twice in this file, 1 in the NO_HZ ifdef, and 1
which seems to be not used.

Kind Regards,

Remy


2007/12/13, Steven Rostedt <rostedt@goodmis.org>:
> We are pleased to announce the 2.6.23.9-rt13 tree, which can be
> downloaded from the location:
>
>  http://www.kernel.org/pub/linux/kernel/projects/rt/
>
> Changes since 2.6.23.9-rt12
>
>   - Backported the new RT Balancing code from sched-devel
>        New changes by Steven Rostedt, Gregory Haskins,
>         Ingo Molnar, and Dmitry Adamushko
>
>   - 2 dimension CPU Prio RT balancing search (Gregory Haskins)
>
>   - ARM compile fix (Kevin Hilman)
>
>   - Disable HPET legacy replacement for kdump (OGAWA Hirofumi)
>
>   - disable HPET on shutdown (OGAWA Hirofumi)
>
>   - fix for futex_wait signal stack corruption (Steven Rostedt)
>
>   - Handle IRQ_PENDING for simple irq thread (Steven Rostedt)
>
>   - latency tracer updates (Daniel Walker)
>
>   - Remove warning in local_bh_enable (Kevin Hilman)
>
>   - use real time pcp locking for page draining during cpu (Andi Kleen)
>
>   - Revert lazy disable irq from simple irq handler (Steven Rostedt)
>
>   - AT91 switch to edge from simple irq (Remy Bohmer)
>
>
> to build a 2.6.23.9-rt13 tree, the following patches should be applied:
>
>   http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.23.9.tar.bz2
>   http://www.kernel.org/pub/linux/kernel/projects/rt/patch-2.6.23.9-rt13.bz2
>
> And like always, my RT version of Matt Mackall's ketchup will get this
> for you nicely:
>
>   http://people.redhat.com/srostedt/rt/tools/ketchup-0.9.8-rt2
>
>
> The broken out patches are also available.
>
> -- Steve
>
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-rt-users" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

------=_Part_10318_2788266.1197542596608
Content-Type: text/x-patch; name=remove_unused_var_warning.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fa55s3i4
Content-Disposition: attachment; filename=remove_unused_var_warning.patch

Rml4IGEgY29tcGlsZSB3YXJuaW5nIG9uIC1ydDEzLCBhbmQgVVAgKEFSTSBBVDkxcm05MjAwKQoK
U2lnbmVkLW9mZi1ieTogUmVteSBCb2htZXIgPGxpbnV4QGJvaG1lci5uZXQ+CgotLS0KIGtlcm5l
bC9yY3VwcmVlbXB0LmMgfCAgICAyIC0tCiBrZXJuZWwvc2NoZWRfcnQuYyAgIHwgICAgMyArKy0K
IDIgZmlsZXMgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAzIGRlbGV0aW9ucygtKQoKSW5kZXg6
IGxpbnV4LTIuNi4yMy9rZXJuZWwvc2NoZWRfcnQuYwo9PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09Ci0tLSBsaW51eC0yLjYu
MjMub3JpZy9rZXJuZWwvc2NoZWRfcnQuYwkyMDA3LTEyLTEzIDEwOjU5OjU0LjAwMDAwMDAwMCAr
MDEwMAorKysgbGludXgtMi42LjIzL2tlcm5lbC9zY2hlZF9ydC5jCTIwMDctMTItMTMgMTE6MDY6
NDEuMDAwMDAwMDAwICswMTAwCkBAIC04NSw4ICs4NSw5IEBAIHN0YXRpYyBpbmxpbmUgdm9pZCBp
bmNfcnRfdGFza3Moc3RydWN0IHQKIAogc3RhdGljIGlubGluZSB2b2lkIGRlY19ydF90YXNrcyhz
dHJ1Y3QgdGFza19zdHJ1Y3QgKnAsIHN0cnVjdCBycSAqcnEpCiB7CisjaWZkZWYgQ09ORklHX1NN
UAogCWludCBoaWdoZXN0X3ByaW8gPSBycS0+cnQuaGlnaGVzdF9wcmlvOwotCisjZW5kaWYKIAlX
QVJOX09OKCFydF90YXNrKHApKTsKIAlXQVJOX09OKCFycS0+cnQucnRfbnJfcnVubmluZyk7CiAJ
cnEtPnJ0LnJ0X25yX3J1bm5pbmctLTsKSW5kZXg6IGxpbnV4LTIuNi4yMy9rZXJuZWwvcmN1cHJl
ZW1wdC5jCj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT0KLS0tIGxpbnV4LTIuNi4yMy5vcmlnL2tlcm5lbC9yY3VwcmVlbXB0
LmMJMjAwNy0xMi0xMyAxMDo1OTo1NC4wMDAwMDAwMDAgKzAxMDAKKysrIGxpbnV4LTIuNi4yMy9r
ZXJuZWwvcmN1cHJlZW1wdC5jCTIwMDctMTItMTMgMTE6Mzg6MjguMDAwMDAwMDAwICswMTAwCkBA
IC05OTgsOCArOTk4LDYgQEAgdm9pZCBfX2luaXQgcmN1X2luaXRfcnQodm9pZCkKIAlyY3VfcHJl
ZW1wdF9ib29zdF9pbml0KCk7CiB9CiAKLXN0YXRpYyBERUZJTkVfUEVSX0NQVShsb25nLCByY3Vf
ZHludGlja19zbmFwc2hvdCk7Ci0KIC8qCiAgKiBEZXByZWNhdGVkLCB1c2Ugc3luY2hyb25pemVf
cmN1KCkgb3Igc3luY2hyb25pemVfc2NoZWQoKSBpbnN0ZWFkLgogICovCg==
------=_Part_10318_2788266.1197542596608--
