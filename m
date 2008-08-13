Return-Path: <linux-kernel-owner+w=401wt.eu-S1752430AbYHMSdY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752430AbYHMSdY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 14:33:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752582AbYHMSdP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 14:33:15 -0400
Received: from wr-out-0506.google.com ([64.233.184.225]:34705 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412AbYHMSdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 14:33:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:references;
        b=Q9Kl5pn3fFdvdEmpaDQyBqO1TBsg/+S3hgE+v0uKWPQmYXhIcXktSUnzHLaQdwY2rc
         dFbW1u0BwaIGtsLYMgYxWDxlO1+1eeYaTp+xw741hkCSqVvB3ZEqV2qJvDt8ppItp8D+
         psOa/WT6o1TTmdVJyRie1SgM/HOFZYFSWGPlg=
Message-ID: <86802c440808131133o133e1dfftdfcc076a1100afb6@mail.gmail.com>
Date: Wed, 13 Aug 2008 11:33:12 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Jeff Chua" <jeff.chua.linux@gmail.com>
Subject: Re: 2.6.27rc1 cannot boot more than 8CPUs
Cc: "David Miller" <davem@davemloft.net>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <86802c440808131046s4df84ba9va12d45897cf6affa@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_101344_28503664.1218652392735"
References: <Pine.LNX.4.64.0808061908100.12476@boston.corp.fedex.com>
	 <20080813141629.GD19397@elte.hu>
	 <b6a2187b0808131010u7481f663n94d8e005b9dac2d1@mail.gmail.com>
	 <b6a2187b0808131033m25a7e147x98235a48abd3eb3c@mail.gmail.com>
	 <20080813173940.GA32214@elte.hu>
	 <86802c440808131046s4df84ba9va12d45897cf6affa@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_101344_28503664.1218652392735
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Wed, Aug 13, 2008 at 10:46 AM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> On Wed, Aug 13, 2008 at 10:39 AM, Ingo Molnar <mingo@elte.hu> wrote:
>>
>> * Jeff Chua <jeff.chua.linux@gmail.com> wrote:
>>
>>> On Thu, Aug 14, 2008 at 1:10 AM, Jeff Chua <jeff.chua.linux@gmail.com> wrote:
>>> > On Wed, Aug 13, 2008 at 10:16 PM, Ingo Molnar <mingo@elte.hu> wrote:
>>> >
>>> >> btw., could you please check that v2.6.27-rc3 (or later) kernels boot
>>> >> fine (with about 8 cpus) even if you have genericarch/bigsmp disabled,
>>> >> and do not silently hang as it happened on your box before?
>>> >
>>> > With 16 CPUs, it still hangs, but now the console is showing the
>>> > errors as intended.
>>> > ... but it is supposed to hang?
>>>
>>> I tried with just CONFIG_NR_CPUS=8 and this time it booted, but stange
>>> thing is I only see 2 CPUs! To be more precise, it's without both
>>> CONFIG_X86_GENERICARCH and CONFIG_X86_BIGSMP.
>>>
>>> And when I tried to enable the CPUs, it complained about:
>>>
>>> # cat cpu6/online
>>> 0
>>> # echo 1 > cpu6/online
>>> More than 8 CPUs detected - skipping them.
>>> Use CONFIG_X86_GENERICARCH and CONFIG_X86_BIGSMP.
>>> -bash: echo: write error: Input/output error
>>>
>>> Prior to the patch, the system booted with all 8 CPUs.
>
> that is new regression...

jeff,

please check the attached patch. it should fix the new regression and
will not hang.

YH

------=_Part_101344_28503664.1218652392735
Content-Type: text/x-patch; name=big_smp_check.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fjua3t9v0
Content-Disposition: attachment; filename=big_smp_check.patch

W1BBVENIXSB4ODY6IGNoZWNrIGJpZ3NtcCBpbiBzbXBfc2FuaXR5X2NoZWNrIGluc3RlYWQgb2Yg
Y3B1X3VwCgpjbGVhciBiaXRzIGZvciBjcHUgbnIgPiA4CgpTaWduZWQtb2ZmLWJ5OiBZaW5naGFp
IEx1IDx5aGx1Lmtlcm5lbEBnbWFpbC5jb20+CgotLS0KIGFyY2gveDg2L2tlcm5lbC9zbXBib290
LmMgfCAgIDM4ICsrKysrKysrKysrKysrKysrKysrKysrKysrKystLS0tLS0tLS0tCiAxIGZpbGUg
Y2hhbmdlZCwgMjggaW5zZXJ0aW9ucygrKSwgMTAgZGVsZXRpb25zKC0pCgpJbmRleDogbGludXgt
Mi42L2FyY2gveDg2L2tlcm5lbC9zbXBib290LmMKPT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQotLS0gbGludXgtMi42Lm9y
aWcvYXJjaC94ODYva2VybmVsL3NtcGJvb3QuYworKysgbGludXgtMi42L2FyY2gveDg2L2tlcm5l
bC9zbXBib290LmMKQEAgLTk4NywxNyArOTg3LDcgQEAgaW50IF9fY3B1aW5pdCBuYXRpdmVfY3B1
X3VwKHVuc2lnbmVkIGludAogCWZsdXNoX3RsYl9hbGwoKTsKIAlsb3dfbWFwcGluZ3MgPSAxOwog
Ci0jaWZkZWYgQ09ORklHX1g4Nl9QQwotCWlmIChkZWZfdG9fYmlnc21wICYmIGFwaWNpZCA+IDgp
IHsKLQkJcHJpbnRrKEtFUk5fV0FSTklORwotCQkJIk1vcmUgdGhhbiA4IENQVXMgZGV0ZWN0ZWQg
LSBza2lwcGluZyB0aGVtLlxuIgotCQkJIlVzZSBDT05GSUdfWDg2X0dFTkVSSUNBUkNIIGFuZCBD
T05GSUdfWDg2X0JJR1NNUC5cbiIpOwotCQllcnIgPSAtMTsKLQl9IGVsc2UKLQkJZXJyID0gZG9f
Ym9vdF9jcHUoYXBpY2lkLCBjcHUpOwotI2Vsc2UKIAllcnIgPSBkb19ib290X2NwdShhcGljaWQs
IGNwdSk7Ci0jZW5kaWYKIAogCXphcF9sb3dfbWFwcGluZ3MoKTsKIAlsb3dfbWFwcGluZ3MgPSAw
OwpAQCAtMTA1MSw2ICsxMDQxLDM0IEBAIHN0YXRpYyBfX2luaXQgdm9pZCBkaXNhYmxlX3NtcCh2
b2lkKQogc3RhdGljIGludCBfX2luaXQgc21wX3Nhbml0eV9jaGVjayh1bnNpZ25lZCBtYXhfY3B1
cykKIHsKIAlwcmVlbXB0X2Rpc2FibGUoKTsKKworI2lmIGRlZmluZWQoQ09ORklHX1g4Nl9QQykg
JiYgZGVmaW5lZChDT05GSUdfWDg2XzMyKQorICAgICAgICBpZiAoZGVmX3RvX2JpZ3NtcCAmJiBu
cl9jcHVfaWRzID4gOCkgeworCQl1bnNpZ25lZCBpbnQgY3B1OworCQl1bnNpZ25lZCBucjsKKwor
ICAgICAgICAgICAgICAgIHByaW50ayhLRVJOX1dBUk5JTkcKKyAgICAgICAgICAgICAgICAgICAg
ICAgICJNb3JlIHRoYW4gOCBDUFVzIGRldGVjdGVkIC0gc2tpcHBpbmcgdGhlbS5cbiIKKyAgICAg
ICAgICAgICAgICAgICAgICAgICJVc2UgQ09ORklHX1g4Nl9HRU5FUklDQVJDSCBhbmQgQ09ORklH
X1g4Nl9CSUdTTVAuXG4iKTsKKworCQluciA9IDA7CisJCWZvcl9lYWNoX3ByZXNlbnRfY3B1KGNw
dSkgeworCQkJaWYgKG5yID49IDgpCisJCQkJY3B1X2NsZWFyKGNwdSwgY3B1X3ByZXNlbnRfbWFw
KTsKKwkJCW5yKys7CisJCX0KKworCQluciA9IDA7CisJCWZvcl9lYWNoX3Bvc3NpYmxlX2NwdShj
cHUpIHsKKwkJCWlmIChuciA+PSA4KQorCQkJCWNwdV9jbGVhcihjcHUsIGNwdV9wb3NzaWJsZV9t
YXApOworCQkJbnIrKzsKKwkJfQorCisJCW5yX2NwdV9pZHMgPSA4OworICAgICAgICB9CisjZW5k
aWYKKwogCWlmICghcGh5c2lkX2lzc2V0KGhhcmRfc21wX3Byb2Nlc3Nvcl9pZCgpLCBwaHlzX2Nw
dV9wcmVzZW50X21hcCkpIHsKIAkJcHJpbnRrKEtFUk5fV0FSTklORyAid2VpcmQsIGJvb3QgQ1BV
ICgjJWQpIG5vdCBsaXN0ZWQiCiAJCQkJICAgICJieSB0aGUgQklPUy5cbiIsIGhhcmRfc21wX3By
b2Nlc3Nvcl9pZCgpKTsK
------=_Part_101344_28503664.1218652392735--
