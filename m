Return-Path: <linux-kernel-owner+w=401wt.eu-S1757810AbYFNI0y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757810AbYFNI0y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 04:26:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753683AbYFNI0o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 04:26:44 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:11869 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753625AbYFNI0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 04:26:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:references;
        b=H6lO95AF85vOxTMQRVpsmSxqN7pRJGa9J7A/SeIyyERkYYYaLE4kAIGsq3NII3z3rl
         Kvx0v+NhmOIAZhqRUs4Ow20D8ZcFfVkwjH1D+IsxoKALx36ciJerKMN36GJawuflLrqB
         EVnfP1jU1QsXnlqEFezFo5H1aHIusDea1SztU=
Message-ID: <86802c440806140126l7a949783of0fb08d11ae07bef@mail.gmail.com>
Date: Sat, 14 Jun 2008 01:26:41 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Alexey Starikovskiy" <aystarik@gmail.com>
Subject: Re: linux-next Regression: Unable to locate IOAPIC
Cc: webmaster@dragonslave.de, "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
       linux-acpi@vger.kernel.org, "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <48536E3B.4000703@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_8656_28695158.1213432001317"
References: <200806051100.12885.dex@dragonslave.de>
	 <200806102229.10512.dex@dragonslave.de> <4851AA24.7060906@gmail.com>
	 <200806131307.39807.dex@dragonslave.de> <48536E3B.4000703@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_8656_28695158.1213432001317
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Sat, Jun 14, 2008 at 12:07 AM, Alexey Starikovskiy
<aystarik@gmail.com> wrote:
> Hi Ingo, Yinghai,
>
> It looks like the code introduced by
> 2944e16b25e7fb8b5ee0dd9dc7197a0f9e523cfd
> is causing this problem. At least it is new between -rc5 (working) and
> linux-next (not working).
>
> Regards,
> Alex.
>
>
> Daniel Exner wrote:
>>
>> Hi all,
>>
>> Alexey Starikovskiy wrote:
>>
>>>
>>> Hi Daniel,
>>>
>>> Could you please provide full dmesg and acpidump outputs?
>>>
>>
>> I attached dmesg and config , both from working 2.6.26-rc5 with git-acpi
>> patch below and from linux-next snapshot 20080604.
>> I also attached acpidump that was done while using stock 2.6.25-fw5 from
>> my distro. (But I think that doesnt matter, at least it shouldn't ;)
>>
>>
>>>
>>> Daniel Exner wrote:
>>>
>>>>
>>>> Andrew Morton wrote:
>>>>
>>>>>
>>>>> On Fri, 6 Jun 2008 19:30:28 +0200 Daniel Exner <dex@dragonslave.de>
>>>>>
>>
>> wrote:
>>
>>>>>>
>>>>>> Andrew Morton wrote:
>>>>>>
>>>>>>>
>>>>>>> (cc linux-acpi)
>>>>>>>
>>>>>>> On Thu, 5 Jun 2008 11:00:12 +0200 Daniel Exner <dex@dragonslave.de>
>>>>>>>
>>>>
>>>> wrote:
>>>>
>>>>>>>>
>>>>>>>> Hi!
>>>>>>>>
>>>>>>>> (Added myself to CC, because I'm not subscribed)
>>>>>>>>
>>>>>>>> with linux-next snapshot 20080604 my Laptop morphes into sitting
>>>>>>>> duck
>>>>>>>> and I think this is due to this:
>>>>>>>>
>>>>>>>
>>>>>>> I assume 2.6.26-rc5 is OK?
>>>>>>>
>>>>>>
>>>>>> Indeed.. just tried it with (nearly) the same config: no unable to
>>>>>> locate IOAPIC
>>>>>>
>>>>>> Will try todays next snapshot above -rc5 now.
>>>>>>
>>>>>
>>>>> OK, thanks.
>>>>>
>>>>> It would be great if you could test 2.6.26-rc5 plus
>>>>> http://userweb.kernel.org/~akpm/git-acpi.patch.  That'll allow us to
>>>>> confirm that the regression is due to changes in the acpi tree.
>>>>>
>>>>
>>>> Sorry for the delay.. real-life you know ;)
>>>>
>>>> I guess you'd expect me to confirm the behavior on rc5 with this patch
>>>> aplied, but .. well this Kernel works!
>>>>
>>
>> To clarify myself:
>> 2.6.25.5:  --> relatively fast no IOAPIC Errors in dmesg
>> 2.6.26-rc5:   --> relatively  no IOAPIC Errors in dmesg
>> 2.6.26-rc5 + git-acpi Patch:   --> relatively  no IOAPIC Errors in dmesg
>> 2.6.26-rc5 +  linux-next snapshot 20080604 --> even slower than before my
>> ide Patch many "unable to locate IOAPIC" Errors
>>
>>
>> So I think the problem lies not in the acpi tree but somewhre else.
>>
>> Is it possible to tell git to explicitly _exclude_ a specific tree while
>> bisecting?

can you check if the attached patch fix the problem?
it will not check entries before MP_intsrc_info...

YH

------=_Part_8656_28695158.1213432001317
Content-Type: text/x-patch; name=enable_update_mptable.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fhfy1lwr0
Content-Disposition: attachment; filename=enable_update_mptable.patch

W1BBVENIXSB4ODY6IGtlZXAgTVBfaW50c3JjX2luZm8gdW50b3VjaGVkIGlmIG5vdCB1cGRhdGUg
bXB0YWJsZQoKdXNlIGVuYWJsZV91cGRhdGVfbXB0YWJsZSB0byBkZWNpZGUgaWYgbmVlZCBjaGVj
ayBiZWZvcmUgYWRkIG1wX2lycXMgYXJyYXkKClNpZ25lZC1vZmYtYnk6IFlpbmdoYWkgTHUgPHlo
bHUua2VybmVsQGdtYWlsLmNvbT4KCmRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rZXJuZWwvYWNwaS9i
b290LmMgYi9hcmNoL3g4Ni9rZXJuZWwvYWNwaS9ib290LmMKaW5kZXggZjFkMjRiZC4uZDJhNDc2
OCAxMDA2NDQKLS0tIGEvYXJjaC94ODYva2VybmVsL2FjcGkvYm9vdC5jCisrKyBiL2FyY2gveDg2
L2tlcm5lbC9hY3BpL2Jvb3QuYwpAQCAtMTE3MCw2ICsxMTcwLDkgQEAgaW50IG1wX2NvbmZpZ19h
Y3BpX2dzaSh1bnNpZ25lZCBjaGFyIG51bWJlciwgdW5zaWduZWQgaW50IGRldmZuLCB1OCBwaW4s
CiAJc3RydWN0IG1wY19jb25maWdfaW50c3JjIGludHNyYzsKIAlpbnQgaW9hcGljOwogCisJaWYg
KCFlbmFibGVfdXBkYXRlX21wdGFibGUpCisJCXJldHVybiAwOworCiAJLyogcHJpbnQgdGhlIGVu
dHJ5IHNob3VsZCBoYXBwZW4gb24gbXB0YWJsZSBpZGVudGljYWxseSAqLwogCWludHNyYy5tcGNf
dHlwZSA9IE1QX0lOVFNSQzsKIAlpbnRzcmMubXBjX2lycXR5cGUgPSBtcF9JTlQ7CmRpZmYgLS1n
aXQgYS9hcmNoL3g4Ni9rZXJuZWwvbXBwYXJzZS5jIGIvYXJjaC94ODYva2VybmVsL21wcGFyc2Uu
YwppbmRleCA3YWMxYjY4Li4xYjA0MWE1IDEwMDY0NAotLS0gYS9hcmNoL3g4Ni9rZXJuZWwvbXBw
YXJzZS5jCisrKyBiL2FyY2gveDg2L2tlcm5lbC9tcHBhcnNlLmMKQEAgLTM0LDYgKzM0LDggQEAK
ICNpbmNsdWRlIDxtYWNoX21wcGFyc2UuaD4KICNlbmRpZgogCitpbnQgZW5hYmxlX3VwZGF0ZV9t
cHRhYmxlOworCiAvKgogICogQ2hlY2tzdW0gYW4gTVAgY29uZmlndXJhdGlvbiBibG9jay4KICAq
LwpAQCAtMjk1LDEwICsyOTcsMTEgQEAgdm9pZCBNUF9pbnRzcmNfaW5mbyhzdHJ1Y3QgbXBjX2Nv
bmZpZ19pbnRzcmMgKm0pCiAKIAlwcmludF9NUF9pbnRzcmNfaW5mbyhtKTsKIAotCWZvciAoaSA9
IDA7IGkgPCBtcF9pcnFfZW50cmllczsgaSsrKSB7Ci0JCWlmICghbXBfaXJxX21wY19pbnRzcmNf
Y21wKCZtcF9pcnFzW2ldLCBtKSkKLQkJCXJldHVybjsKLQl9CisJaWYgKGVuYWJsZV91cGRhdGVf
bXB0YWJsZSkKKwkJZm9yIChpID0gMDsgaSA8IG1wX2lycV9lbnRyaWVzOyBpKyspIHsKKwkJCWlm
ICghbXBfaXJxX21wY19pbnRzcmNfY21wKCZtcF9pcnFzW2ldLCBtKSkKKwkJCQlyZXR1cm47CisJ
CX0KIAogCWFzc2lnbl90b19tcF9pcnEobSwgJm1wX2lycXNbbXBfaXJxX2VudHJpZXNdKTsKIAlp
ZiAoKyttcF9pcnFfZW50cmllcyA9PSBNQVhfSVJRX1NPVVJDRVMpCkBAIC0xMTE2LDggKzExMTks
NiBAQCBvdXQ6CiAJcmV0dXJuIDA7CiB9CiAKLWludCBfX2luaXRkYXRhIGVuYWJsZV91cGRhdGVf
bXB0YWJsZTsKLQogc3RhdGljIGludCBfX2luaXQgdXBkYXRlX21wdGFibGVfc2V0dXAoY2hhciAq
c3RyKQogewogCWVuYWJsZV91cGRhdGVfbXB0YWJsZSA9IDE7CmRpZmYgLS1naXQgYS9pbmNsdWRl
L2FzbS14ODYvbXBzcGVjLmggYi9pbmNsdWRlL2FzbS14ODYvbXBzcGVjLmgKaW5kZXggYjhiYTM3
NC4uZjQ4ZGJjYSAxMDA2NDQKLS0tIGEvaW5jbHVkZS9hc20teDg2L21wc3BlYy5oCisrKyBiL2lu
Y2x1ZGUvYXNtLXg4Ni9tcHNwZWMuaApAQCAtNjEsNiArNjEsNyBAQCBleHRlcm4gdm9pZCBtcF9j
b25maWdfYWNwaV9sZWdhY3lfaXJxcyh2b2lkKTsKIGV4dGVybiBpbnQgbXBfcmVnaXN0ZXJfZ3Np
KHUzMiBnc2ksIGludCBlZGdlX2xldmVsLCBpbnQgYWN0aXZlX2hpZ2hfbG93KTsKIGV4dGVybiB2
b2lkIE1QX2ludHNyY19pbmZvKHN0cnVjdCBtcGNfY29uZmlnX2ludHNyYyAqbSk7CiAjaWZkZWYg
Q09ORklHX1g4Nl9JT19BUElDCitleHRlcm4gaW50IGVuYWJsZV91cGRhdGVfbXB0YWJsZTsKIGV4
dGVybiBpbnQgbXBfY29uZmlnX2FjcGlfZ3NpKHVuc2lnbmVkIGNoYXIgbnVtYmVyLCB1bnNpZ25l
ZCBpbnQgZGV2Zm4sIHU4IHBpbiwKIAkJCQl1MzIgZ3NpLCBpbnQgdHJpZ2dlcmluZywgaW50IHBv
bGFyaXR5KTsKICNlbHNlCg==
------=_Part_8656_28695158.1213432001317--
