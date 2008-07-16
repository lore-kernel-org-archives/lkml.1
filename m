Return-Path: <linux-kernel-owner+w=401wt.eu-S1759439AbYGPIgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759439AbYGPIgc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 04:36:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756458AbYGPIgY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 04:36:24 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:55761 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756375AbYGPIgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 04:36:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:references;
        b=QeM++O1I4pHaWebvhd2KqLpVzFbS2HMCyu3YEyT11WJzRdwBqSPUTgnwB0mqm6La0P
         6ItpXTsJX2tEaDJzOkIJB3qVoBBY9QygkDjXCxOAKn5pBVxMYI2XeBALLxXezL/Ilwbe
         nayBjd4xwGMi0kspfz1L5roXU4ZlZFq7NvmkE=
Message-ID: <86802c440807160136m6af981b2u6a37cabb8e33a629@mail.gmail.com>
Date: Wed, 16 Jul 2008 01:36:21 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Justin Mattock" <justinmattock@gmail.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Barnes, Jesse" <jesse.barnes@intel.com>
Subject: Re: 2.6.26-rc9-git9 doesn't boot on Macintel
Cc: "Jack Howarth" <howarth@bromo.msbb.uc.edu>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <dd18b0c30807160050r5b10908fiffc2a4b464abe5f3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_13601_20922336.1216197381082"
References: <dd18b0c30807151252w7edcea19t8cec5ec5f958c7c0@mail.gmail.com>
	 <20080715231118.GA26807@bromo.msbb.uc.edu>
	 <dd18b0c30807151726i622dabceve31828460085ee57@mail.gmail.com>
	 <20080716012427.GA27398@bromo.msbb.uc.edu>
	 <dd18b0c30807152005g3c58001br7182f7670d6247db@mail.gmail.com>
	 <20080716035830.GA27935@bromo.msbb.uc.edu>
	 <dd18b0c30807152230u39ef9c18v78b48d1c7b9ddd17@mail.gmail.com>
	 <86802c440807160044ge504cacl419b6cbcad5f0f9d@mail.gmail.com>
	 <dd18b0c30807160050r5b10908fiffc2a4b464abe5f3@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_13601_20922336.1216197381082
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Wed, Jul 16, 2008 at 12:50 AM, Justin Mattock
<justinmattock@gmail.com> wrote:
> On Wed, Jul 16, 2008 at 7:44 AM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>> I looked at your dmesg from 2.6.25.10
>>
>> it tried to use mmconfig, and later fall back to conf1, because
>> 1. your MCFG said it support bus [0,255], and range will be
>> [0xf0000000, 0xffffffff]
>> 2. firmware only reserve [0xf0000000, 0xf4000000)
>>
>> and 2.5.25 will not check acp reserved range.
>>
>> from 2.6.26, it will check if the [0xf0000000, 0xffffffff] is reserved
>> via acpi dsdt _crs?
>> it will fail too.
>>
>> So MCFG table is broken.
>>
>> You need to get firmware update from your vendor.
>>
>> or we need to put that system on DMI check to change end_bus_number
>> from 0xff to 0x3f
>>
>> ps: mem=2g will not work, it will can not change mcfg table etc... you
>> need take out 1G ram out.
>>
>> YH
>>
>
> Well shit man, that sucks...
> how hard is it to do a DMI check?
> regards;

please check attached patch... not sure the
DMI_MATCH(DMI_PRODUCT_NAME, "MacPro2"),  is right or not.

YH

------=_Part_13601_20922336.1216197381082
Content-Type: text/x-patch; name=mmconfig_apple_macpro2.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fipofk0l0
Content-Disposition: attachment; filename=mmconfig_apple_macpro2.patch

W1BBVENIXSB4ODYscGNpOiBkbWkgY2hlY2sgZm9yIG1hY2twcm8gMi4yIG1tY29uZgoKY2hhbmdl
IHRoZSBtY29uZiBidXMgcmFuZ2UgZnJvbSBbMCwweGZmXSB0byB0byBbMCwgMHgzZl0KdG8gbWF0
Y2ggcmFuZ2UgWzB4ZjAwMDAwMDAsIDB4ZjQwMDAwMDApIGluIGU4MjAgdGFibGVzLgoKU2lnbmVk
LW9mZi1ieTogWWluZ2hhaSBMdSA8eWhsdS5rZXJuZWxAZ21haWwuY29tPgoKLS0tCiBhcmNoL3g4
Ni9wY2kvbW1jb25maWctc2hhcmVkLmMgfCAgIDM1ICsrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrCiAxIGZpbGUgY2hhbmdlZCwgMzUgaW5zZXJ0aW9ucygrKQoKSW5kZXg6IGxpbnV4
LTIuNi9hcmNoL3g4Ni9wY2kvbW1jb25maWctc2hhcmVkLmMKPT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQotLS0gbGludXgt
Mi42Lm9yaWcvYXJjaC94ODYvcGNpL21tY29uZmlnLXNoYXJlZC5jCisrKyBsaW51eC0yLjYvYXJj
aC94ODYvcGNpL21tY29uZmlnLXNoYXJlZC5jCkBAIC0zNzQsNiArMzc0LDQwIEBAIHJlamVjdDoK
IAogc3RhdGljIGludCBfX2luaXRkYXRhIGtub3duX2JyaWRnZTsKIAorc3RhdGljIGludCBfX2Rl
dmluaXQgY2hlY2tfbW1jb25mKGNvbnN0IHN0cnVjdCBkbWlfc3lzdGVtX2lkICpkKQoreworCXR5
cGVvZihwY2lfbW1jZmdfY29uZmlnWzBdKSAqY2ZnOworCisJaWYgKChwY2lfbW1jZmdfY29uZmln
X251bSAhPSAxKSB8fAorCSAgICAocGNpX21tY2ZnX2NvbmZpZyA9PSBOVUxMKSB8fAorCSAgICAo
cGNpX21tY2ZnX2NvbmZpZ1swXS5hZGRyZXNzID09IDApKQorCQlyZXR1cm4gMTsKKworCWNmZyA9
ICZwY2lfbW1jZmdfY29uZmlnWzBdOworCisJaWYgKGNmZy0+c3RhcnRfYnVzX251bWJlciA9PSAw
ICYmIGNmZy0+ZW5kX2J1c19udW1iZXIgPiAweDNmKQorCQljZmctPmVuZF9idXNfbnVtYmVyID0g
MHgzZjsKKworCXJldHVybiAwOworfQorCitzdGF0aWMgc3RydWN0IGRtaV9zeXN0ZW1faWQgX19k
ZXZpbml0ZGF0YSBtbWNvbmZfZG1pX3RhYmxlW10gPSB7CisgICAgICAgIHsKKyAgICAgICAgICAg
ICAgICAuY2FsbGJhY2sgPSBjaGVja19tbWNvbmYsCisgICAgICAgICAgICAgICAgLmlkZW50ID0g
IkFwcGxlIiwKKyAgICAgICAgICAgICAgICAubWF0Y2hlcyA9IHsKKyAgICAgICAgICAgICAgICAg
ICAgICAgIERNSV9NQVRDSChETUlfU1lTX1ZFTkRPUiwgIkFwcGxlIiksCisJCQlETUlfTUFUQ0go
RE1JX1BST0RVQ1RfTkFNRSwgIk1hY1BybzIiKSwKKyAgICAgICAgICAgICAgICB9LAorICAgICAg
ICB9LAorICAgICAgICB7fQorfTsKKwordm9pZCBfX2luaXQgY2hlY2tfbW1jb25mX2RtaSh2b2lk
KQoreworICAgICAgICBkbWlfY2hlY2tfc3lzdGVtKG1tY29uZl9kbWlfdGFibGUpOworfQorCiBz
dGF0aWMgdm9pZCBfX2luaXQgX19wY2lfbW1jZmdfaW5pdChpbnQgZWFybHkpCiB7CiAJLyogTU1D
T05GSUcgZGlzYWJsZWQgKi8KQEAgLTM5NSw2ICs0MjksNyBAQCBzdGF0aWMgdm9pZCBfX2luaXQg
X19wY2lfbW1jZmdfaW5pdChpbnQKIAogCWlmICgha25vd25fYnJpZGdlKSB7CiAJCWFjcGlfdGFi
bGVfcGFyc2UoQUNQSV9TSUdfTUNGRywgYWNwaV9wYXJzZV9tY2ZnKTsKKwkJY2hlY2tfbW1jb25m
X2RtaSgpOwogCQlwY2lfbW1jZmdfcmVqZWN0X2Jyb2tlbihlYXJseSk7CiAJfQogCg==
------=_Part_13601_20922336.1216197381082--
