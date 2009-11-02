Return-Path: <linux-kernel-owner+w=401wt.eu-S932172AbZKBTqJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932172AbZKBTqJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 14:46:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755199AbZKBTqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 14:46:08 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:53104 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754113AbZKBTqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 14:46:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=d9n8q5966WFZW4q/BXq1hiiYSnyZWRB/PBdmhogVlYkP7lKePPRuf9/vyqqEYfSxlT
         ct/64euW3J+TPJdx3GiZBBqceQDPcgojALpzeAZL5J0T8O2H+FxlDEanZKjhbKwG0cO7
         B4ZxMChKRbiTtZGbTA1597wea3O7Bx0Z6vtVc=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0911021620580.12138@localhost.localdomain>
References: <alpine.LFD.2.00.0910230007030.3737@localhost.localdomain>
	 <alpine.LFD.2.00.0911021620580.12138@localhost.localdomain>
Date: Mon, 2 Nov 2009 20:46:11 +0100
X-Google-Sender-Auth: 5f39f071ccb9d7a6
Message-ID: <520f0cf10911021146i136af7bfg370a217185b5154c@mail.gmail.com>
Subject: Re: [PATCH -rt] Updates-from-Jon-Masters-for-hwlat_detector.c.patch
From: John Kacur <jkacur@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Jon Masters <jcm@redhat.com>,
       linux-rt-users@vger.kernel.org, Clark Williams <williams@redhat.com>
Content-Type: multipart/mixed; boundary=0016e6d648612bc72a047768a1ab
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016e6d648612bc72a047768a1ab
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 2, 2009 at 4:43 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> Hi,
>
> On Fri, 23 Oct 2009, John Kacur wrote:
>> I took Jon Masters' latest hwlat_detector patch for upstream, and grabbe=
d
>> the bits that aren't currently in -rt. The patch is fairly small.
>>
>> Please consider it for the next -rt release.
>
> Not really.
>
>> diff --git a/drivers/misc/hwlat_detector.c b/drivers/misc/hwlat_detector=
.c
>> index be6553f..7191e17 100644
>> --- a/drivers/misc/hwlat_detector.c
>> +++ b/drivers/misc/hwlat_detector.c
>> @@ -262,6 +262,8 @@ static int get_sample(void *unused)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Keep a running maximum ever recorded hard=
ware latency */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (sample > data.max_sample)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 data.max_sample =3D sample;
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 wake_up(&data.wq); /* wake up reader(s) */
>> =A0 =A0 =A0 }
>>
>> =A0 =A0 =A0 ret =3D 0;
>> @@ -299,8 +301,6 @@ static int kthread_fn(void *unused)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto err_out;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>>
>> - =A0 =A0 =A0 =A0 =A0 =A0 wake_up(&data.wq); /* wake up reader(s) */
>> -
>
> This reverts -rt commit 5fc485f6341c177e9d5f641c6fb9e33ca465aa84.
>
> CONFIG_DEBUG_SPINLOCK_SLEEP resp. CONFIG_DEBUG_PREEMPT will tell you
> why this is a bad idea on -rt :)
>
> Thanks,
>
> =A0 =A0 =A0 =A0tglx
> --

Ugh. Thanks for catching that. To be honest not sure how it happened,
so it must be my fault. :)

Updated patch just adds the error checking from Jon Masters then,
patched against -rt.

--0016e6d648612bc72a047768a1ab
Content-Type: text/x-diff; charset=US-ASCII; 
	name="0001-Updates-from-Jon-Masters-for-hwlat_detector.c.patch"
Content-Disposition: attachment; 
	filename="0001-Updates-from-Jon-Masters-for-hwlat_detector.c.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g1jn335r0

RnJvbSAwNjIxOTE3OGM2MzJkOWE5NDkwMjlhZGUxYTg1MDMzNjI5MzY1ZGJmIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBKb24gTWFzdGVycyA8amNtQGpvbm1hc3RlcnMub3JnPgpEYXRl
OiBUaHUsIDIyIE9jdCAyMDA5IDE5OjMzOjU2ICswMjAwClN1YmplY3Q6IFtQQVRDSF0gVXBkYXRl
cyBmcm9tIEpvbiBNYXN0ZXJzIGZvciBod2xhdF9kZXRlY3Rvci5jCgpTaWduZWQtb2ZmLWJ5OiBK
b24gTWFzdGVycyA8amNtQGpvbm1hc3RlcnMub3JnPgpTaWduZWQtb2ZmLWJ5OiBKb2huIEthY3Vy
IDxqa2FjdXJAcmVkaGF0LmNvbT4KLS0tCiBkcml2ZXJzL21pc2MvS2NvbmZpZyAgICAgICAgICB8
ICAgIDIgKy0KIGRyaXZlcnMvbWlzYy9od2xhdF9kZXRlY3Rvci5jIHwgICAxMiArKysrKysrKysr
LS0KIDIgZmlsZXMgY2hhbmdlZCwgMTEgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkKCmRp
ZmYgLS1naXQgYS9kcml2ZXJzL21pc2MvS2NvbmZpZyBiL2RyaXZlcnMvbWlzYy9LY29uZmlnCmlu
ZGV4IDE1Y2Q2YmMuLjM1ZjQ0MWMgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvbWlzYy9LY29uZmlnCisr
KyBiL2RyaXZlcnMvbWlzYy9LY29uZmlnCkBAIC05NSw3ICs5NSw3IEBAIGNvbmZpZyBJQk1fQVNN
CiBjb25maWcgSFdMQVRfREVURUNUT1IKIAl0cmlzdGF0ZSAiVGVzdGluZyBtb2R1bGUgdG8gZGV0
ZWN0IGhhcmR3YXJlLWluZHVjZWQgbGF0ZW5jaWVzIgogCWRlcGVuZHMgb24gREVCVUdfRlMKLQlz
ZWxlY3QgUklOR19CVUZGRVIKKwlkZXBlbmRzIG9uIFJJTkdfQlVGRkVSCiAJZGVmYXVsdCBtCiAJ
LS0taGVscC0tLQogCSAgQSBzaW1wbGUgaGFyZHdhcmUgbGF0ZW5jeSBkZXRlY3Rvci4gVXNlIHRo
aXMgbW9kdWxlIHRvIGRldGVjdApkaWZmIC0tZ2l0IGEvZHJpdmVycy9taXNjL2h3bGF0X2RldGVj
dG9yLmMgYi9kcml2ZXJzL21pc2MvaHdsYXRfZGV0ZWN0b3IuYwppbmRleCBiZTY1NTNmLi4wZmZi
NDNhIDEwMDY0NAotLS0gYS9kcml2ZXJzL21pc2MvaHdsYXRfZGV0ZWN0b3IuYworKysgYi9kcml2
ZXJzL21pc2MvaHdsYXRfZGV0ZWN0b3IuYwpAQCAtNjA3LDcgKzYwNywxMSBAQCBzdGF0aWMgc3Np
emVfdCAgZGVidWdfZW5hYmxlX2Z3cml0ZShzdHJ1Y3QgZmlsZSAqZmlscCwKIAkJaWYgKCFlbmFi
bGVkKQogCQkJZ290byB1bmxvY2s7CiAJCWVuYWJsZWQgPSAwOwotCQlzdG9wX2t0aHJlYWQoKTsK
KwkJZXJyID0gc3RvcF9rdGhyZWFkKCk7CisJCWlmICgwICE9IGVycikgeworCQkJcHJpbnRrKEtF
Uk5fRVJSIEJBTk5FUiAiY2Fubm90IHN0b3Aga3RocmVhZFxuIik7CisJCQlyZXR1cm4gLUVGQVVM
VDsKKwkJfQogCQl3YWtlX3VwKCZkYXRhLndxKTsJCS8qIHJlYWRlcihzKSBzaG91bGQgcmV0dXJu
ICovCiAJfQogdW5sb2NrOgpAQCAtMTE5NCw5ICsxMTk4LDEzIEBAIG91dDoKICAqLwogc3RhdGlj
IHZvaWQgZGV0ZWN0b3JfZXhpdCh2b2lkKQogeworCWludCBlcnI7CisKIAlpZiAoZW5hYmxlZCkg
ewogCQllbmFibGVkID0gMDsKLQkJc3RvcF9rdGhyZWFkKCk7CisJCWVyciA9IHN0b3Bfa3RocmVh
ZCgpOworCQlpZiAoMCAhPSBlcnIpCisJCQlwcmludGsoS0VSTl9FUlIgQkFOTkVSICJjYW5ub3Qg
c3RvcCBrdGhyZWFkXG4iKTsKIAl9CiAKIAlmcmVlX2RlYnVnZnMoKTsKLS0gCjEuNi4wLjYKCg==
--0016e6d648612bc72a047768a1ab--
