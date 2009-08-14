Return-Path: <linux-kernel-owner+w=401wt.eu-S1756086AbZHNDFQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756086AbZHNDFQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 23:05:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753820AbZHNDFO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 23:05:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59262 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756016AbZHNDFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 23:05:10 -0400
Message-ID: <4A84D432.2040704@zytor.com>
Date: Thu, 13 Aug 2009 20:04:18 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: "Wang, Shane" <shane.wang@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, "Cihula, Joseph" <joseph.cihula@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
       "jmorris@namei.org" <jmorris@namei.org>,
       "jbeulich@novell.com" <jbeulich@novell.com>,
       "peterm@redhat.com" <peterm@redhat.com>,
       "Wei, Gang" <gang.wei@intel.com>
Subject: Re: [PATCH 1/1] intel_txt: to fix build errors of CONFIG_ACPI_SLEEP
References: <4A4ACA60.1000209@intel.com> <20090807072752.GA12119@elte.hu> <20090812145321.GA11347@elte.hu> <037F493892196B458CD3E193E8EBAD4F01EAB64402@pdsmsx502.ccr.corp.intel.com> <20090813064634.GA12143@elte.hu> <4A842C5B.7050100@zytor.com> <037F493892196B458CD3E193E8EBAD4F01EAB6464E@pdsmsx502.ccr.corp.intel.com>
In-Reply-To: <037F493892196B458CD3E193E8EBAD4F01EAB6464E@pdsmsx502.ccr.corp.intel.com>
Content-Type: multipart/mixed;
 boundary="------------030405020100090206010705"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030405020100090206010705
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 08/13/2009 07:06 PM, Wang, Shane wrote:
> I agree with hpa, considering TXT doesnot depends on acpi sleep.
> 
> takes effect but tboot->mac_regions[] will never be used without S3.
> 

Given that, I would create a function called tboot_setup_suspend() or
something like that and localize the setting of mac_regions as well as
s3_resume_vector there.

Since it looks like s3_resume_vector is simply set up in tboot_sleep()
before we'd call tboot_shutdown(), we can presumably simply do it all in
tboot_shutdown().

Ingo, Shane: how does the attached patch look?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.


--------------030405020100090206010705
Content-Type: text/plain;
 name="diff.txt"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="diff.txt"

ZGlmZiAtLWdpdCBhL2FyY2gveDg2L2tlcm5lbC90Ym9vdC5jIGIvYXJjaC94ODYva2VybmVs
L3Rib290LmMKaW5kZXggMWFiODAxMi4uYTE4M2JlZiAxMDA2NDQKLS0tIGEvYXJjaC94ODYv
a2VybmVsL3Rib290LmMKKysrIGIvYXJjaC94ODYva2VybmVsL3Rib290LmMKQEAgLTM0LDYg
KzM0LDcgQEAKICNpbmNsdWRlIDxhc20vcGd0YWJsZS5oPgogI2luY2x1ZGUgPGFzbS9wZ2Fs
bG9jLmg+CiAjaW5jbHVkZSA8YXNtL2ZpeG1hcC5oPgorI2luY2x1ZGUgPGFzbS9wcm90by5o
PgogI2luY2x1ZGUgPGFzbS9zZXR1cC5oPgogI2luY2x1ZGUgPGFzbS90Ym9vdC5oPgogI2lu
Y2x1ZGUgPGFzbS9lODIwLmg+CkBAIC0xNjQsMjUgKzE2NSw1MSBAQCB2b2lkIHRib290X2Ny
ZWF0ZV90cmFtcG9saW5lKHZvaWQpCiAJbWFwX2Jhc2UgPSBQRk5fRE9XTih0Ym9vdC0+dGJv
b3RfYmFzZSk7CiAJbWFwX3NpemUgPSBQRk5fVVAodGJvb3QtPnRib290X3NpemUpOwogCWlm
IChtYXBfdGJvb3RfcGFnZXMobWFwX2Jhc2UgPDwgUEFHRV9TSElGVCwgbWFwX2Jhc2UsIG1h
cF9zaXplKSkKLQkJcGFuaWMoInRib290OiBFcnJvciBtYXBwaW5nIHRib290IHBhZ2VzICht
Zm5zKSBAIDB4JXgsIDB4JXhcbiIsIG1hcF9iYXNlLCBtYXBfc2l6ZSk7CisJCXBhbmljKCJ0
Ym9vdDogRXJyb3IgbWFwcGluZyB0Ym9vdCBwYWdlcyAobWZucykgQCAweCV4LCAweCV4XG4i
LAorCQkgICAgICBtYXBfYmFzZSwgbWFwX3NpemUpOwogfQogCi1zdGF0aWMgdm9pZCBzZXRf
bWFjX3JlZ2lvbnModm9pZCkKKyNpZmRlZiBDT05GSUdfQUNQSV9TTEVFUAorCitzdGF0aWMg
dm9pZCBhZGRfbWFjX3JlZ2lvbihwaHlzX2FkZHJfdCBzdGFydCwgdW5zaWduZWQgbG9uZyBz
aXplKQogewotCXRib290LT5udW1fbWFjX3JlZ2lvbnMgPSAzOworCXN0cnVjdCB0Ym9vdF9t
YWNfcmVnaW9uICptcjsKKwlwaHlzX2FkZHJfdCBlbmQgPSBzdGFydCArIHNpemU7CisKKwlp
ZiAoc3RhcnQgJiYgc2l6ZSkgeworCQltciA9ICZ0Ym9vdC0+bWFjX3JlZ2lvbnNbdGJvb3Qt
Pm51bV9tYWNfcmVnaW9ucysrXTsKKwkJbXItPnN0YXJ0ID0gcm91bmRfZG93bihzdGFydCwg
UEFHRV9TSVpFKTsKKwkJbXItPnNpemUgID0gcm91bmRfdXAoZW5kLCBQQUdFX1NJWkUpIC0g
bXItPnN0YXJ0OworCX0KK30KKworc3RhdGljIGludCB0Ym9vdF9zZXR1cF9zbGVlcCh2b2lk
KQoreworCXRib290LT5udW1fbWFjX3JlZ2lvbnMgPSAwOworCiAJLyogUzMgcmVzdW1lIGNv
ZGUgKi8KLQl0Ym9vdC0+bWFjX3JlZ2lvbnNbMF0uc3RhcnQgPSBQRk5fUEhZUyhQRk5fRE9X
TihhY3BpX3dha2V1cF9hZGRyZXNzKSk7Ci0JdGJvb3QtPm1hY19yZWdpb25zWzBdLnNpemUg
PSBQRk5fVVAoV0FLRVVQX1NJWkUpIDw8IFBBR0VfU0hJRlQ7CisJYWRkX21hY19yZWdpb24o
YWNwaV93YWtldXBfYWRkcmVzcywgV0FLRVVQX1NJWkUpOwogCS8qIEFQIHRyYW1wb2xpbmUg
Y29kZSAqLwotCXRib290LT5tYWNfcmVnaW9uc1sxXS5zdGFydCA9Ci0JCQlQRk5fUEhZUyhQ
Rk5fRE9XTih2aXJ0X3RvX3BoeXModHJhbXBvbGluZV9iYXNlKSkpOwotCXRib290LT5tYWNf
cmVnaW9uc1sxXS5zaXplID0gUEZOX1VQKFRSQU1QT0xJTkVfU0laRSkgPDwgUEFHRV9TSElG
VDsKKwlhZGRfbWFjX3JlZ2lvbih2aXJ0X3RvX3BoeXModHJhbXBvbGluZV9iYXNlKSwgVFJB
TVBPTElORV9TSVpFKTsKIAkvKiBrZXJuZWwgY29kZSArIGRhdGEgKyBic3MgKi8KLQl0Ym9v
dC0+bWFjX3JlZ2lvbnNbMl0uc3RhcnQgPSBQRk5fUEhZUyhQRk5fRE9XTih2aXJ0X3RvX3Bo
eXMoJl90ZXh0KSkpOwotCXRib290LT5tYWNfcmVnaW9uc1syXS5zaXplID0gUEZOX1BIWVMo
UEZOX1VQKHZpcnRfdG9fcGh5cygmX2VuZCkpKSAtCi0JCQkJICAgICBQRk5fUEhZUyhQRk5f
RE9XTih2aXJ0X3RvX3BoeXMoJl90ZXh0KSkpOworCWFkZF9tYWNfcmVnaW9uKHZpcnRfdG9f
cGh5cyhfdGV4dCksIF9lbmQgLSBfdGV4dCk7CisKKwl0Ym9vdC0+YWNwaV9zaW5mby5rZXJu
ZWxfczNfcmVzdW1lX3ZlY3RvciA9IGFjcGlfd2FrZXVwX2FkZHJlc3M7CisKKwlyZXR1cm4g
MDsKIH0KIAorI2Vsc2UgLyogbm8gQ09ORklHX0FDUElfU0xFRVAgKi8KKworc3RhdGljIGlu
dCB0Ym9vdF9zZXR1cF9zbGVlcCh2b2lkKQoreworCS8qIFMzIHNodXRkb3duIHJlcXVlc3Rl
ZCwgYnV0IFMzIG5vdCBzdXBwb3J0ZWQgYnkgdGhlIGtlcm5lbC4uLiAqLworCUJVRygpOwor
CXJldHVybiAtMTsKK30KKworI2VuZGlmCisKIHZvaWQgdGJvb3Rfc2h1dGRvd24odTMyIHNo
dXRkb3duX3R5cGUpCiB7CiAJdm9pZCAoKnNodXRkb3duKSh2b2lkKTsKQEAgLTIwMCw3ICsy
MjcsOCBAQCB2b2lkIHRib290X3NodXRkb3duKHUzMiBzaHV0ZG93bl90eXBlKQogCiAJLyog
aWYgdGhpcyBpcyBTMyB0aGVuIHNldCByZWdpb25zIHRvIE1BQyAqLwogCWlmIChzaHV0ZG93
bl90eXBlID09IFRCX1NIVVRET1dOX1MzKQotCQlzZXRfbWFjX3JlZ2lvbnMoKTsKKwkJaWYg
KHRib290X3NldHVwX3NsZWVwKCkpCisJCQlyZXR1cm47CiAKIAl0Ym9vdC0+c2h1dGRvd25f
dHlwZSA9IHNodXRkb3duX3R5cGU7CiAKQEAgLTI1Myw3ICsyODEsNiBAQCB2b2lkIHRib290
X3NsZWVwKHU4IHNsZWVwX3N0YXRlLCB1MzIgcG0xYV9jb250cm9sLCB1MzIgcG0xYl9jb250
cm9sKQogCXRib290LT5hY3BpX3NpbmZvLnBtMWJfY250X3ZhbCA9IHBtMWJfY29udHJvbDsK
IAkvKiB3ZSBhbHdheXMgdXNlIHRoZSAzMmIgd2FrZXVwIHZlY3RvciAqLwogCXRib290LT5h
Y3BpX3NpbmZvLnZlY3Rvcl93aWR0aCA9IDMyOwotCXRib290LT5hY3BpX3NpbmZvLmtlcm5l
bF9zM19yZXN1bWVfdmVjdG9yID0gYWNwaV93YWtldXBfYWRkcmVzczsKIAogCWlmIChzbGVl
cF9zdGF0ZSA+PSBBQ1BJX1NfU1RBVEVfQ09VTlQgfHwKIAkgICAgYWNwaV9zaHV0ZG93bl9t
YXBbc2xlZXBfc3RhdGVdID09IC0xKSB7Cg==
--------------030405020100090206010705--
