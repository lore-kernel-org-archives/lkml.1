Return-Path: <linux-kernel-owner+w=401wt.eu-S1754815AbZHMPid@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815AbZHMPid (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 11:38:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751350AbZHMPic
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 11:38:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44530 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479AbZHMPib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 11:38:31 -0400
Message-ID: <4A842C5B.7050100@zytor.com>
Date: Thu, 13 Aug 2009 08:08:11 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "Wang, Shane" <shane.wang@intel.com>,
       "Cihula, Joseph" <joseph.cihula@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
       "jmorris@namei.org" <jmorris@namei.org>,
       "jbeulich@novell.com" <jbeulich@novell.com>,
       "peterm@redhat.com" <peterm@redhat.com>,
       "Wei, Gang" <gang.wei@intel.com>
Subject: Re: [PATCH 1/1] intel_txt: to fix build errors of CONFIG_ACPI_SLEEP
References: <4A4ACA60.1000209@intel.com> <20090807072752.GA12119@elte.hu> <20090812145321.GA11347@elte.hu> <037F493892196B458CD3E193E8EBAD4F01EAB64402@pdsmsx502.ccr.corp.intel.com> <20090813064634.GA12143@elte.hu>
In-Reply-To: <20090813064634.GA12143@elte.hu>
Content-Type: multipart/mixed;
 boundary="------------070009060406020505050606"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070009060406020505050606
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 08/12/2009 11:46 PM, Ingo Molnar wrote:
> * Wang, Shane <shane.wang@intel.com> wrote:
> 
>> Signed-off-by: Shane Wang <shane.wang@intel.com>
>>
>> diff -r 7358cf1b3090 arch/x86/kernel/tboot.c
>> --- a/arch/x86/kernel/tboot.c   Wed Aug 12 03:04:23 2009 -0700
>> +++ b/arch/x86/kernel/tboot.c   Wed Aug 12 18:06:21 2009 -0700
>> @@ -169,6 +169,7 @@ void tboot_create_trampoline(void)
>>
>>  static void set_mac_regions(void)
>>  {
>> +#ifdef CONFIG_ACPI_SLEEP
>>         tboot->num_mac_regions = 3;
>>         /* S3 resume code */
>>         tboot->mac_regions[0].start = PFN_PHYS(PFN_DOWN(acpi_wakeup_address));
>> @@ -181,6 +182,7 @@ static void set_mac_regions(void)
>>         tboot->mac_regions[2].start = PFN_PHYS(PFN_DOWN(virt_to_phys(&_text)));
>>         tboot->mac_regions[2].size = PFN_PHYS(PFN_UP(virt_to_phys(&_end))) -
>>                                      PFN_PHYS(PFN_DOWN(virt_to_phys(&_text)));
>> +#endif
> 
> These #ifdefs are quite ugly. Why not add a 'depends on ACPI_SLEEP' 
> rule to the INTEL_TXT Kconfig section?

I *strongly* disagree with that kind of false dependencies.  It makes it
seem like there is something magic going on, which invites cargo cult
programming in the future.  I also think those particular #ifdefs are
fairly innocuous... it's not like they're hiding flow of control or
major chunks of code.

However, I think the actual code to set the sections is ugly as hell,
which is probably why the #ifdef sticks in your eyes.

Consider the attached instead patch, which abstracts some of the (way
more complex than it should be) open-coded stuff and therefore makes it
stick out less.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.


--------------070009060406020505050606
Content-Type: text/plain;
 name="diff.txt"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="diff.txt"

ZGlmZiAtLWdpdCBhL2FyY2gveDg2L2tlcm5lbC90Ym9vdC5jIGIvYXJjaC94ODYva2VybmVs
L3Rib290LmMKaW5kZXggMWFiODAxMi4uYWYxNmQyNiAxMDA2NDQKLS0tIGEvYXJjaC94ODYv
a2VybmVsL3Rib290LmMKKysrIGIvYXJjaC94ODYva2VybmVsL3Rib290LmMKQEAgLTM0LDYg
KzM0LDcgQEAKICNpbmNsdWRlIDxhc20vcGd0YWJsZS5oPgogI2luY2x1ZGUgPGFzbS9wZ2Fs
bG9jLmg+CiAjaW5jbHVkZSA8YXNtL2ZpeG1hcC5oPgorI2luY2x1ZGUgPGFzbS9wcm90by5o
PgogI2luY2x1ZGUgPGFzbS9zZXR1cC5oPgogI2luY2x1ZGUgPGFzbS90Ym9vdC5oPgogI2lu
Y2x1ZGUgPGFzbS9lODIwLmg+CkBAIC0xNjQsMjMgKzE2NSwzNiBAQCB2b2lkIHRib290X2Ny
ZWF0ZV90cmFtcG9saW5lKHZvaWQpCiAJbWFwX2Jhc2UgPSBQRk5fRE9XTih0Ym9vdC0+dGJv
b3RfYmFzZSk7CiAJbWFwX3NpemUgPSBQRk5fVVAodGJvb3QtPnRib290X3NpemUpOwogCWlm
IChtYXBfdGJvb3RfcGFnZXMobWFwX2Jhc2UgPDwgUEFHRV9TSElGVCwgbWFwX2Jhc2UsIG1h
cF9zaXplKSkKLQkJcGFuaWMoInRib290OiBFcnJvciBtYXBwaW5nIHRib290IHBhZ2VzICht
Zm5zKSBAIDB4JXgsIDB4JXhcbiIsIG1hcF9iYXNlLCBtYXBfc2l6ZSk7CisJCXBhbmljKCJ0
Ym9vdDogRXJyb3IgbWFwcGluZyB0Ym9vdCBwYWdlcyAobWZucykgQCAweCV4LCAweCV4XG4i
LAorCQkgICAgICBtYXBfYmFzZSwgbWFwX3NpemUpOworfQorCitzdGF0aWMgdm9pZCBhZGRf
bWFjX3JlZ2lvbihwaHlzX2FkZHJfdCBzdGFydCwgdW5zaWduZWQgbG9uZyBzaXplKQorewor
CXN0cnVjdCB0Ym9vdF9tYWNfcmVnaW9uICptcjsKKwlwaHlzX2FkZHJfdCBlbmQgPSBzdGFy
dCArIHNpemU7CisKKwlpZiAoc3RhcnQgJiYgc2l6ZSkgeworCQltciA9ICZ0Ym9vdC0+bWFj
X3JlZ2lvbnNbdGJvb3QtPm51bV9tYWNfcmVnaW9ucysrXTsKKwkJbXItPnN0YXJ0ID0gcm91
bmRfZG93bihzdGFydCwgUEFHRV9TSVpFKTsKKwkJbXItPnNpemUgID0gcm91bmRfdXAoZW5k
LCBQQUdFX1NJWkUpIC0gbXItPnN0YXJ0OworCX0KIH0KIAogc3RhdGljIHZvaWQgc2V0X21h
Y19yZWdpb25zKHZvaWQpCiB7Ci0JdGJvb3QtPm51bV9tYWNfcmVnaW9ucyA9IDM7CisJdGJv
b3QtPm51bV9tYWNfcmVnaW9ucyA9IDA7CisKKyNpZmRlZiBDT05GSUdfQUNQSV9TTEVFUAog
CS8qIFMzIHJlc3VtZSBjb2RlICovCi0JdGJvb3QtPm1hY19yZWdpb25zWzBdLnN0YXJ0ID0g
UEZOX1BIWVMoUEZOX0RPV04oYWNwaV93YWtldXBfYWRkcmVzcykpOwotCXRib290LT5tYWNf
cmVnaW9uc1swXS5zaXplID0gUEZOX1VQKFdBS0VVUF9TSVpFKSA8PCBQQUdFX1NISUZUOwor
CWFkZF9tYWNfcmVnaW9uKGFjcGlfd2FrZXVwX2FkZHJlc3MsIFdBS0VVUF9TSVpFKTsKKyNl
bmRpZgorI2lmZGVmIENPTkZJR19YODZfVFJBTVBPTElORQogCS8qIEFQIHRyYW1wb2xpbmUg
Y29kZSAqLwotCXRib290LT5tYWNfcmVnaW9uc1sxXS5zdGFydCA9Ci0JCQlQRk5fUEhZUyhQ
Rk5fRE9XTih2aXJ0X3RvX3BoeXModHJhbXBvbGluZV9iYXNlKSkpOwotCXRib290LT5tYWNf
cmVnaW9uc1sxXS5zaXplID0gUEZOX1VQKFRSQU1QT0xJTkVfU0laRSkgPDwgUEFHRV9TSElG
VDsKKwlhZGRfbWFjX3JlZ2lvbih2aXJ0X3RvX3BoeXModHJhbXBvbGluZV9iYXNlKSwgVFJB
TVBPTElORV9TSVpFKTsKKyNlbmRpZgogCS8qIGtlcm5lbCBjb2RlICsgZGF0YSArIGJzcyAq
LwotCXRib290LT5tYWNfcmVnaW9uc1syXS5zdGFydCA9IFBGTl9QSFlTKFBGTl9ET1dOKHZp
cnRfdG9fcGh5cygmX3RleHQpKSk7Ci0JdGJvb3QtPm1hY19yZWdpb25zWzJdLnNpemUgPSBQ
Rk5fUEhZUyhQRk5fVVAodmlydF90b19waHlzKCZfZW5kKSkpIC0KLQkJCQkgICAgIFBGTl9Q
SFlTKFBGTl9ET1dOKHZpcnRfdG9fcGh5cygmX3RleHQpKSk7CisJYWRkX21hY19yZWdpb24o
dmlydF90b19waHlzKF90ZXh0KSwgX2VuZCAtIF90ZXh0KTsKIH0KIAogdm9pZCB0Ym9vdF9z
aHV0ZG93bih1MzIgc2h1dGRvd25fdHlwZSkKQEAgLTI1Myw3ICsyNjcsOSBAQCB2b2lkIHRi
b290X3NsZWVwKHU4IHNsZWVwX3N0YXRlLCB1MzIgcG0xYV9jb250cm9sLCB1MzIgcG0xYl9j
b250cm9sKQogCXRib290LT5hY3BpX3NpbmZvLnBtMWJfY250X3ZhbCA9IHBtMWJfY29udHJv
bDsKIAkvKiB3ZSBhbHdheXMgdXNlIHRoZSAzMmIgd2FrZXVwIHZlY3RvciAqLwogCXRib290
LT5hY3BpX3NpbmZvLnZlY3Rvcl93aWR0aCA9IDMyOworI2lmZGVmIENPTkZJR19BQ1BJX1NM
RUVQCiAJdGJvb3QtPmFjcGlfc2luZm8ua2VybmVsX3MzX3Jlc3VtZV92ZWN0b3IgPSBhY3Bp
X3dha2V1cF9hZGRyZXNzOworI2VuZGlmCiAKIAlpZiAoc2xlZXBfc3RhdGUgPj0gQUNQSV9T
X1NUQVRFX0NPVU5UIHx8CiAJICAgIGFjcGlfc2h1dGRvd25fbWFwW3NsZWVwX3N0YXRlXSA9
PSAtMSkgewo=
--------------070009060406020505050606--
