Return-Path: <linux-kernel-owner+w=401wt.eu-S1751926Ab0AKVnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751926Ab0AKVnU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 16:43:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751203Ab0AKVnT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 16:43:19 -0500
Received: from mail-pz0-f188.google.com ([209.85.222.188]:37635 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940Ab0AKVnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 16:43:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=md79rDdD29wttNj1GXUzRR4kSQKm7et3pqBwSFHXtpgnmNUjCZkNxn9EqWW+4gd7D/
         YhuRE6pxBFk60n6gQVEA2K8Ppq4RYf0CatC5QAyBmnJhK0YklGXjc54s86BMoyR3N1Ng
         8Xl/cUcgtm9ZADgmzHIoV6E5sbnLc+lPn7QJg=
MIME-Version: 1.0
In-Reply-To: <20100110102638.GA7838@elte.hu>
References: <20100109101038.GA17555@in.ibm.com>
	 <86802c441001091313y1f64f011t616f08cd282a7123@mail.gmail.com>
	 <20100110023015.GA2253@in.ibm.com>
	 <86802c441001092235j79092e6fse18b61e3d7b0ac6@mail.gmail.com>
	 <20100110102638.GA7838@elte.hu>
Date: Mon, 11 Jan 2010 13:43:17 -0800
X-Google-Sender-Auth: 7216e0b76aafbab5
Message-ID: <86802c441001111343p2afaafb7o702884e632260bf7@mail.gmail.com>
Subject: Re: [PATCH] Make Intel 8-way Xeons boot again
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: ananth@in.ibm.com, suresh.b.siddha@intel.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, stable@kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Content-Type: multipart/mixed; boundary=00504502af5be5c080047cea6c45
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00504502af5be5c080047cea6c45
Content-Type: text/plain; charset=ISO-8859-1

On Sun, Jan 10, 2010 at 2:26 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Yinghai Lu <yinghai@kernel.org> wrote:
>
>> On Sat, Jan 9, 2010 at 6:30 PM, Ananth N Mavinakayanahalli
>> <ananth@in.ibm.com> wrote:
>> > On Sat, Jan 09, 2010 at 01:13:39PM -0800, Yinghai Lu wrote:
>> >> On Sat, Jan 9, 2010 at 2:10 AM, Ananth N Mavinakayanahalli
>> >> <ananth@in.ibm.com> wrote:
>> >> > On an 8-way system with Intel Xeon X7350 CPUs, booting 2.6.32 or newer
>> >> > kernels fails at:
>> >> >
>> >> > ...
>> >> > CPU0: Intel(R) Xeon(R) CPU ? ? ? ? ? X7350 ?@ 2.93GHz stepping 0b
>> >> > Booting Node ? 0, Processors ?#1 #2 #3 #4 #5 #6 #7 Ok.
>> >> > Brought up 8 CPUs
>> >> > Total of 8 processors activated (46906.05 BogoMIPS).
>> >> >
>> >> > Git bisect showed 2fbd07a5f as the offending commit.
>> >> >
>> >> > With the patch below, I am able to boot the latest Linus' git tree on
>> >> > the machine. If this patch is correct, it needs to get into the stable
>> >> > tree too.
>> >> >
>> >> > Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
>> >> > ---
>> >> > Index: linux-2.6/arch/x86/kernel/apic/probe_64.c
>> >> > ===================================================================
>> >> > --- linux-2.6.orig/arch/x86/kernel/apic/probe_64.c ? ? ?2010-01-09 14:54:29.000000000 +0530
>> >> > +++ linux-2.6/arch/x86/kernel/apic/probe_64.c ? 2010-01-09 14:57:53.000000000 +0530
>> >> > @@ -70,7 +70,7 @@
>> >> > ? ? ? ?if (apic == &apic_flat) {
>> >> > ? ? ? ? ? ? ? ?switch (boot_cpu_data.x86_vendor) {
>> >> > ? ? ? ? ? ? ? ?case X86_VENDOR_INTEL:
>> >> > - ? ? ? ? ? ? ? ? ? ? ? if (num_processors > 8)
>> >> > + ? ? ? ? ? ? ? ? ? ? ? if (num_processors >= 8)
>> >> > ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ?apic = &apic_physflat;
>> >> > ? ? ? ? ? ? ? ? ? ? ? ?break;
>> >> > ? ? ? ? ? ? ? ?case X86_VENDOR_AMD:
>> >>
>> >> can you send out whole bootlog with apic=debug?
>> >
>> > Here it is:
>> > ACPI: LAPIC (acpi_id[0x00] lapic_id[0x0c] enabled)
>> > ACPI: LAPIC (acpi_id[0x01] lapic_id[0x10] enabled)
>> > ACPI: LAPIC (acpi_id[0x02] lapic_id[0x0d] enabled)
>> > ACPI: LAPIC (acpi_id[0x03] lapic_id[0x11] enabled)
>> > ACPI: LAPIC (acpi_id[0x04] lapic_id[0x0e] enabled)
>> > ACPI: LAPIC (acpi_id[0x05] lapic_id[0x12] enabled)
>> > ACPI: LAPIC (acpi_id[0x06] lapic_id[0x0f] enabled)
>> > ACPI: LAPIC (acpi_id[0x07] lapic_id[0x13] enabled)
>> ...
>> > Setting APIC routing to flat
>> > Getting VERSION: 50014
>> > Getting VERSION: 50014
>> > Getting ID: c000000
>> > Getting ID: f3000000
>> > Getting LVT0: 700
>> > Getting LVT1: 400
>> > enabled ExtINT on CPU#0
>> > ESR value before enabling vector: 0x00000040 ?after: 0x00000000
>> > ENABLING IO-APIC IRQs
>> > ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
>> > CPU0: Intel(R) Xeon(R) CPU ? ? ? ? ? X7350 ?@ 2.93GHz stepping 0b
>> ...
>>
>> the BSP's physical apic id is 0x0c instead of 0.
>>
>> not sure Suresh test that or not.
>
> In any case this commit needs to be reverted as the assumption that it's safe
> to do this optimization is evidently not true.
>

use attached debug patch on one of my intel system and with nr_cpus=8,
it seems logical flat works.
that system BSP apic id is 0x20.

YH

--00504502af5be5c080047cea6c45
Content-Type: text/x-diff; charset=US-ASCII; name="hard_maxcpus.patch"
Content-Disposition: attachment; filename="hard_maxcpus.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g4bryp860

W1BBVENIXSB1c2UgbnJfY3B1cz0gdG8gc2V0IG5yX2NwdV9pZHMgZWFybHkKCmFkZCBucl9jcHVz
PSB0byBzZXQgbnJfY3B1X2lkcy4gc28gd2UgY2FuIHNpbXVsYXRlIGNwdXMgPD04IG9uIG5vcm1h
bCBjb25maWcuCmluc3RlYWQgb2YgY2hhbmdlIE5SX0NQVVMgZGlyZWN0bHkuCgpTaWduZWQtb2Zm
LWJ5OiBZaW5naGFpIEx1IDx5aW5naGFpQGtlcm5lbC5vcmc+CgotLS0KIGFyY2gvaWE2NC9rZXJu
ZWwvYWNwaS5jICAgfCAgICA0ICsrLS0KIGFyY2gveDg2L2tlcm5lbC9zbXBib290LmMgfCAgICA3
ICsrKystLS0KIGluaXQvbWFpbi5jICAgICAgICAgICAgICAgfCAgIDE0ICsrKysrKysrKysrKysr
CiAzIGZpbGVzIGNoYW5nZWQsIDIwIGluc2VydGlvbnMoKyksIDUgZGVsZXRpb25zKC0pCgpJbmRl
eDogbGludXgtMi42L2luaXQvbWFpbi5jCj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0KLS0tIGxpbnV4LTIuNi5vcmlnL2lu
aXQvbWFpbi5jCisrKyBsaW51eC0yLjYvaW5pdC9tYWluLmMKQEAgLTE0OSw2ICsxNDksMjAgQEAg
c3RhdGljIGludCBfX2luaXQgbm9zbXAoY2hhciAqc3RyKQogCiBlYXJseV9wYXJhbSgibm9zbXAi
LCBub3NtcCk7CiAKKy8qIHRoaXMgaXMgaGFyZCBsaW1pdCAqLworc3RhdGljIGludCBfX2luaXQg
bnJjcHVzKGNoYXIgKnN0cikKK3sKKwlpbnQgbnJfY3B1czsKKworCWdldF9vcHRpb24oJnN0ciwg
Jm5yX2NwdXMpOworCWlmIChucl9jcHVzID4gMCAmJiBucl9jcHVzIDwgbnJfY3B1X2lkcykKKwkJ
bnJfY3B1X2lkcyA9IG5yX2NwdXM7CisKKwlyZXR1cm4gMDsKK30KKworZWFybHlfcGFyYW0oIm5y
X2NwdXMiLCBucmNwdXMpOworCiBzdGF0aWMgaW50IF9faW5pdCBtYXhjcHVzKGNoYXIgKnN0cikK
IHsKIAlnZXRfb3B0aW9uKCZzdHIsICZzZXR1cF9tYXhfY3B1cyk7CkluZGV4OiBsaW51eC0yLjYv
YXJjaC9pYTY0L2tlcm5lbC9hY3BpLmMKPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQotLS0gbGludXgtMi42Lm9yaWcvYXJj
aC9pYTY0L2tlcm5lbC9hY3BpLmMKKysrIGxpbnV4LTIuNi9hcmNoL2lhNjQva2VybmVsL2FjcGku
YwpAQCAtODgzLDggKzg4Myw4IEBAIF9faW5pdCB2b2lkIHByZWZpbGxfcG9zc2libGVfbWFwKHZv
aWQpCiAKIAlwb3NzaWJsZSA9IGF2YWlsYWJsZV9jcHVzICsgYWRkaXRpb25hbF9jcHVzOwogCi0J
aWYgKHBvc3NpYmxlID4gTlJfQ1BVUykKLQkJcG9zc2libGUgPSBOUl9DUFVTOworCWlmIChwb3Nz
aWJsZSA+IG5yX2NwdV9pZHMpCisJCXBvc3NpYmxlID0gbnJfY3B1X2lkczsKIAogCXByaW50ayhL
RVJOX0lORk8gIlNNUDogQWxsb3dpbmcgJWQgQ1BVcywgJWQgaG90cGx1ZyBDUFVzXG4iLAogCQlw
b3NzaWJsZSwgbWF4KChwb3NzaWJsZSAtIGF2YWlsYWJsZV9jcHVzKSwgMCkpOwpJbmRleDogbGlu
dXgtMi42L2FyY2gveDg2L2tlcm5lbC9zbXBib290LmMKPT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQotLS0gbGludXgtMi42
Lm9yaWcvYXJjaC94ODYva2VybmVsL3NtcGJvb3QuYworKysgbGludXgtMi42L2FyY2gveDg2L2tl
cm5lbC9zbXBib290LmMKQEAgLTEyMTMsMTEgKzEyMTMsMTIgQEAgX19pbml0IHZvaWQgcHJlZmls
bF9wb3NzaWJsZV9tYXAodm9pZCkKIAogCXRvdGFsX2NwdXMgPSBtYXhfdChpbnQsIHBvc3NpYmxl
LCBudW1fcHJvY2Vzc29ycyArIGRpc2FibGVkX2NwdXMpOwogCi0JaWYgKHBvc3NpYmxlID4gQ09O
RklHX05SX0NQVVMpIHsKKwkvKiBucl9jcHVfaWRzIGNvdWxkIGJlIHJlZHVjZWQgdmlhIG5yX2Nw
dXM9ICovCisJaWYgKHBvc3NpYmxlID4gbnJfY3B1X2lkcykgewogCQlwcmludGsoS0VSTl9XQVJO
SU5HCiAJCQkiJWQgUHJvY2Vzc29ycyBleGNlZWRzIE5SX0NQVVMgbGltaXQgb2YgJWRcbiIsCi0J
CQlwb3NzaWJsZSwgQ09ORklHX05SX0NQVVMpOwotCQlwb3NzaWJsZSA9IENPTkZJR19OUl9DUFVT
OworCQkJcG9zc2libGUsIG5yX2NwdV9pZHMpOworCQlwb3NzaWJsZSA9IG5yX2NwdV9pZHM7CiAJ
fQogCiAJcHJpbnRrKEtFUk5fSU5GTyAiU01QOiBBbGxvd2luZyAlZCBDUFVzLCAlZCBob3RwbHVn
IENQVXNcbiIsCg==
--00504502af5be5c080047cea6c45--
