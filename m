Return-Path: <linux-kernel-owner+w=401wt.eu-S1753902AbZAFGJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902AbZAFGJT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 01:09:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751324AbZAFGJH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 01:09:07 -0500
Received: from rv-out-0506.google.com ([209.85.198.226]:3133 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311AbZAFGJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 01:09:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:references:x-google-sender-auth;
        b=aBr8d4hhJscyZnxUdzUgzta562WBHg8Ui9xfGVlH1YK0FD3BXauS7LhPYAl6bvYynR
         V3Hbv2Rm5BbvmRr/fNoO+VmMN9csu9F5ha+xtWhnzYsH/JLHci1KTff9Oq7rqC81ab0s
         VAqu6r0xKKdg/iwunUkoBRruZLxrClDpYC0k0=
Message-ID: <86802c440901052209k6785a2f6i755a758d087892f@mail.gmail.com>
Date: Mon, 5 Jan 2009 22:09:03 -0800
From: "Yinghai Lu" <yinghai@kernel.org>
To: david@lang.hm
Subject: Re: early exception error
Cc: "Ingo Molnar" <mingo@elte.hu>, "Cyrill Gorcunov" <gorcunov@gmail.com>,
       "Jiri Slaby" <jirislaby@gmail.com>, "Andi Kleen" <andi@firstfloor.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0901052126360.27565@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_74637_3362945.1231222143888"
References: <20090102174845.GD5372@localhost>
	 <alpine.DEB.1.10.0901051520210.27641@asgard.lang.hm>
	 <alpine.DEB.1.10.0901051649250.28400@asgard.lang.hm>
	 <alpine.DEB.1.10.0901051653290.28400@asgard.lang.hm>
	 <49629FAF.6060709@kernel.org>
	 <alpine.DEB.1.10.0901051717440.28514@asgard.lang.hm>
	 <4962A4F0.7030201@kernel.org>
	 <alpine.DEB.1.10.0901051802320.28514@asgard.lang.hm>
	 <4962AE82.6050905@kernel.org>
	 <alpine.DEB.1.10.0901052126360.27565@asgard.lang.hm>
X-Google-Sender-Auth: 9a14ca6a7f9225b8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_74637_3362945.1231222143888
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Mon, Jan 5, 2009 at 9:29 PM,  <david@lang.hm> wrote:
> On Mon, 5 Jan 2009, Yinghai Lu wrote:
>
>> david@lang.hm wrote:
>>>
>>> On Mon, 5 Jan 2009, Yinghai Lu wrote:
>>>
>>>> david@lang.hm wrote:
>>>>>
>>>>> On Mon, 5 Jan 2009, Yinghai Lu wrote:
>>>>>
>>>>>
>>>>> this motherboard is a Tyan Thunder K8S Pro S2882
>>>>>
>>>>> I just uploaded some snapshots of the bios screens
>>>>
>>>> please try to update the BIOS. the installed BIOS seems has problem...
>>>>
>>>> http://tyan.com/support_download_bios.aspx?model=S.S2882
>>>
>>> what problems are you seeing (i.e. what did I miss seeing that would
>>> have pointed me in this direction without eating everyone's time)
>>>
>>
>> you should get 4g ram instead of 3g according to e820.
>>
>> BIOS should set ram routing correctly according to iommu (gart) and
>> memhole etc.
>
> this seems to have solved the problem

can you post boot log and lspci -vvxxx ?

>
> I do have another of these systems if there is any desire to do any more
> troubleshooting (it would be really nice if things died with a better error
> message for example)

good,
0. setup serial cable between your two system. use minicom in your
first system to capture serial message from second system
1. apply attached patch
2. we need full boot log of your second system. please boot with "
debug console=uart8250,io,0x3f8,115200n8 pci=earlydump"

YH

------=_Part_74637_3362945.1231222143888
Content-Type: text/x-patch; name=mminit_loglevel_2.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fpm5qy850
Content-Disposition: attachment; filename=mminit_loglevel_2.patch

RnJvbTogWWluZ2hhaSBMdSA8eWhsdS5rZXJuZWxAZ21haWwuY29tPgpTdWJqZWN0OiBbUEFUQ0hd
IG1tOiBwcmludCBvdXQgaW5mbyBhYm91dCBhZGRpbmcvcmVtb3ZpbmcgYWN0aXZlIHJlZ2lvbgoK
U2lnbmVkLW9mZi1ieTogWWluZ2hhaSBMdSA8eWhsdS5rZXJuZWxAZ21haWwuY29tPgoKLS0tCiBt
bS9wYWdlX2FsbG9jLmMgfCAgICA1ICsrLS0tCiAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25z
KCspLCAzIGRlbGV0aW9ucygtKQoKSW5kZXg6IGxpbnV4LTIuNi9tbS9wYWdlX2FsbG9jLmMKPT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PQotLS0gbGludXgtMi42Lm9yaWcvbW0vcGFnZV9hbGxvYy5jCisrKyBsaW51eC0yLjYv
bW0vcGFnZV9hbGxvYy5jCkBAIC0zNjI2LDggKzM2MjYsNyBAQCB2b2lkIF9faW5pdCBhZGRfYWN0
aXZlX3JhbmdlKHVuc2lnbmVkIGluCiB7CiAJaW50IGk7CiAKLQltbWluaXRfZHByaW50ayhNTUlO
SVRfVFJBQ0UsICJtZW1vcnlfcmVnaXN0ZXIiLAotCQkJIkVudGVyaW5nIGFkZF9hY3RpdmVfcmFu
Z2UoJWQsICUjbHgsICUjbHgpICIKKwlwcmludGsoS0VSTl9ERUJVRyAiQWRkaW5nIGFjdGl2ZSBy
YW5nZSAoJWQsICUjbHgsICUjbHgpICIKIAkJCSIlZCBlbnRyaWVzIG9mICVkIHVzZWRcbiIsCiAJ
CQluaWQsIHN0YXJ0X3BmbiwgZW5kX3BmbiwKIAkJCW5yX25vZGVtYXBfZW50cmllcywgTUFYX0FD
VElWRV9SRUdJT05TKTsKQEAgLTM2ODksNyArMzY4OCw3IEBAIHZvaWQgX19pbml0IHJlbW92ZV9h
Y3RpdmVfcmFuZ2UodW5zaWduZWQKIAlpbnQgaSwgajsKIAlpbnQgcmVtb3ZlZCA9IDA7CiAKLQlw
cmludGsoS0VSTl9ERUJVRyAicmVtb3ZlX2FjdGl2ZV9yYW5nZSAoJWQsICVsdSwgJWx1KVxuIiwK
KwlwcmludGsoS0VSTl9ERUJVRyAiUmVtb3ZpbmcgYWN0aXZlIHJhbmdlICglZCwgJSNseCwgJSNs
eClcbiIsCiAJCQkgIG5pZCwgc3RhcnRfcGZuLCBlbmRfcGZuKTsKIAogCS8qIEZpbmQgdGhlIG9s
ZCBhY3RpdmUgcmVnaW9uIGVuZCBhbmQgc2hyaW5rICovCg==
------=_Part_74637_3362945.1231222143888--
