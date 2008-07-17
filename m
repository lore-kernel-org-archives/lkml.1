Return-Path: <linux-kernel-owner+w=401wt.eu-S1753655AbYGQENj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655AbYGQENj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 00:13:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750749AbYGQENa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 00:13:30 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:14479 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745AbYGQEN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 00:13:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:references;
        b=vqPCT7OUsJ+uU8qMVWt4xMNy8w59PajYcCZ2jIAC1lhb2wQaVV+518yE4HGjar4biN
         ZesoWIt4OS54HDPNMQ8SLwltebdYJew3HuPBJkQaOngQziFoD3Vn+ZwD37NUjQaxaG9z
         T+eBk+BW+AVYOyi1wyGsDe8vlrS7JKyi4gNjc=
Message-ID: <86802c440807162113g4cea3bd9ic71210330417032b@mail.gmail.com>
Date: Wed, 16 Jul 2008 21:13:28 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Jack Howarth" <howarth@bromo.msbb.uc.edu>
Subject: Re: 2.6.26-rc9-git9 doesn't boot on Macintel
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <20080717034418.GA18951@bromo.msbb.uc.edu>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_26964_21968996.1216268008879"
References: <86802c440807160044ge504cacl419b6cbcad5f0f9d@mail.gmail.com>
	 <86802c440807160136m6af981b2u6a37cabb8e33a629@mail.gmail.com>
	 <20080716140810.GA2861@bromo.msbb.uc.edu>
	 <86802c440807161029n7e0dac98x1ec260879204b6f0@mail.gmail.com>
	 <86802c440807161535n3a4d6891n6f7c16bd4e1f19c3@mail.gmail.com>
	 <20080717004004.GA17792@bromo.msbb.uc.edu>
	 <86802c440807161749u2f5c1eben618e05c6e254fedd@mail.gmail.com>
	 <20080717023538.GA18329@bromo.msbb.uc.edu>
	 <86802c440807161959s10666027k5297af1d657ff4fa@mail.gmail.com>
	 <20080717034418.GA18951@bromo.msbb.uc.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_26964_21968996.1216268008879
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Wed, Jul 16, 2008 at 8:44 PM, Jack Howarth <howarth@bromo.msbb.uc.edu> wrote:
> YH,
>   Okay, I can confirm that 2.6.25.10 boots okay with pci=nommconf
> which does disable MMCONFIG. It also works fine by default with
> MMCONFIG enabled. So there may be two possibly unrelated problems
> in 2.6.26. The first being that MMCONFIG doesn't start up properly
> without your patch and the second being that with or without
> MMCONFIG, the boot process hangs just before when the line...
>
> PCI: Transparent bridge - 0000:00:1e.0

please set CONFIG_PCI_DEBUG in your .config and apply attach two patches

should get sth like

calling  acpi_pci_root_init+0x0/0x54
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Scanning bus 0000:00
PCI: Found 0000:00:00.0 [10de/005e] 000580 00
PCI: Found 0000:00:01.0 [10de/0051] 000601 00
pci 0000:00:01.0: calling nvidia_force_enable_hpet+0x0/0xe7
PCI: Found 0000:00:01.1 [10de/0052] 000c05 00
PCI: 0000:00:01.1 reg 10 io port: [ee00, ee1f]
PCI: 0000:00:01.1 reg 20 io port: [ed00, ed3f]
PCI: 0000:00:01.1 reg 24 io port: [ed40, ed7f]
PCI: Found 0000:00:02.0 [10de/005a] 000c03 00
PCI: 0000:00:02.0 reg 10 32bit mmio: [fdeff000, fdefffff]
PCI: Found 0000:00:02.1 [10de/005b] 000c03 00
PCI: 0000:00:02.1 reg 10 32bit mmio: [fdefec00, fdefecff]
PCI: Found 0000:00:06.0 [10de/0053] 000101 00

YH

------=_Part_26964_21968996.1216268008879
Content-Type: text/x-patch; name=debug_extra_pci_bus_res.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fiqug4fl0
Content-Disposition: attachment; filename=debug_extra_pci_bus_res.patch

SW5kZXg6IGxpbnV4LTIuNi9kcml2ZXJzL3BjaS9zZXR1cC1idXMuYwo9PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09Ci0tLSBs
aW51eC0yLjYub3JpZy9kcml2ZXJzL3BjaS9zZXR1cC1idXMuYworKysgbGludXgtMi42L2RyaXZl
cnMvcGNpL3NldHVwLWJ1cy5jCkBAIC01MzcsNiArNTM3LDM2IEBAIHZvaWQgX19yZWYgcGNpX2J1
c19hc3NpZ25fcmVzb3VyY2VzKHN0cnUKIH0KIEVYUE9SVF9TWU1CT0wocGNpX2J1c19hc3NpZ25f
cmVzb3VyY2VzKTsKIAorc3RhdGljIHZvaWQgcGNpX2J1c19kdW1wX3JlcyhzdHJ1Y3QgcGNpX2J1
cyAqYnVzKQoreworICAgICAgICBpbnQgaTsKKworICAgICAgICBmb3IgKGkgPSAwOyBpIDwgUENJ
X0JVU19OVU1fUkVTT1VSQ0VTOyBpKyspIHsKKyAgICAgICAgICAgICAgICBzdHJ1Y3QgcmVzb3Vy
Y2UgKnJlcyA9IGJ1cy0+cmVzb3VyY2VbaV07CisgICAgICAgICAgICAgICAgaWYgKCFyZXMpCisg
ICAgICAgICAgICAgICAgICAgICAgICBjb250aW51ZTsKKworCQlwcmludGsoS0VSTl9JTkZPICJi
dXM6ICUwMnggaW5kZXggJXggJXM6IFslbGx4LCAlbGx4XVxuIiwgYnVzLT5udW1iZXIsIGksIChy
ZXMtPmZsYWdzICYgSU9SRVNPVVJDRV9JTyk/ICJpbyBwb3J0IjoibW1pbyIsIHJlcy0+c3RhcnQs
IHJlcy0+ZW5kKTsKKyAgICAgICAgfQorfQorCitzdGF0aWMgdm9pZCBwY2lfYnVzX2R1bXBfcmVz
b3VyY2VzKHN0cnVjdCBwY2lfYnVzICpidXMpCit7CisJc3RydWN0IHBjaV9idXMgKmI7CisJc3Ry
dWN0IHBjaV9kZXYgKmRldjsKKworCisJcGNpX2J1c19kdW1wX3JlcyhidXMpOworCisJbGlzdF9m
b3JfZWFjaF9lbnRyeShkZXYsICZidXMtPmRldmljZXMsIGJ1c19saXN0KSB7CisJCWIgPSBkZXYt
PnN1Ym9yZGluYXRlOworCQlpZiAoIWIpCisJCQljb250aW51ZTsKKworCQlwY2lfYnVzX2R1bXBf
cmVzb3VyY2VzKGIpOworCX0KK30KKwogdm9pZCBfX2luaXQKIHBjaV9hc3NpZ25fdW5hc3NpZ25l
ZF9yZXNvdXJjZXModm9pZCkKIHsKQEAgLTU1Miw0ICs1ODIsOSBAQCBwY2lfYXNzaWduX3VuYXNz
aWduZWRfcmVzb3VyY2VzKHZvaWQpCiAJCXBjaV9idXNfYXNzaWduX3Jlc291cmNlcyhidXMpOwog
CQlwY2lfZW5hYmxlX2JyaWRnZXMoYnVzKTsKIAl9CisKKwkvKiBkdW1wIHRoZSByZXNvdXJjZSBv
biBidXNlcyAqLworCWxpc3RfZm9yX2VhY2hfZW50cnkoYnVzLCAmcGNpX3Jvb3RfYnVzZXMsIG5v
ZGUpIHsKKwkJcGNpX2J1c19kdW1wX3Jlc291cmNlcyhidXMpOworCX0KIH0K
------=_Part_26964_21968996.1216268008879
Content-Type: text/x-patch; name=debug_extra_pci_res_range.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fiquigs91
Content-Disposition: attachment; filename=debug_extra_pci_res_range.patch

SW5kZXg6IGxpbnV4LTIuNi9kcml2ZXJzL3BjaS9wcm9iZS5jCj09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0KLS0tIGxpbnV4
LTIuNi5vcmlnL2RyaXZlcnMvcGNpL3Byb2JlLmMKKysrIGxpbnV4LTIuNi9kcml2ZXJzL3BjaS9w
cm9iZS5jCkBAIC0yNzUsNiArMjc1LDcgQEAgc3RhdGljIHZvaWQgcGNpX3JlYWRfYmFzZXMoc3Ry
dWN0IHBjaV9kZQogCQkJfQogCQkJcmVzLT5zdGFydCA9IGw2NCAmIFBDSV9CQVNFX0FERFJFU1Nf
TUVNX01BU0s7CiAJCQlyZXMtPmVuZCA9IHJlcy0+c3RhcnQgKyBzejY0OworCQkJcHJpbnRrKEtF
Uk5fSU5GTyAiUENJOiAlcyByZWcgJXggNjRiaXQgbW1pbzogWyVsbHgsICVsbHhdXG4iLCBwY2lf
bmFtZShkZXYpLCByZWcsIHJlcy0+c3RhcnQsIHJlcy0+ZW5kKTsKICNlbHNlCiAJCQlpZiAoc3o2
NCA+IDB4MTAwMDAwMDAwVUxMKSB7CiAJCQkJcHJpbnRrKEtFUk5fRVJSICJQQ0k6IFVuYWJsZSB0
byBoYW5kbGUgNjQtYml0ICIKQEAgLTI5MCw2ICsyOTEsOCBAQCBzdGF0aWMgdm9pZCBwY2lfcmVh
ZF9iYXNlcyhzdHJ1Y3QgcGNpX2RlCiAJCQkJcmVzLT5lbmQgPSBzejsKIAkJCX0KICNlbmRpZgor
CQl9IGVsc2UgeworCQkJcHJpbnRrKEtFUk5fSU5GTyAiUENJOiAlcyByZWcgJXggJXM6IFslbGx4
LCAlbGx4XVxuIiwgcGNpX25hbWUoZGV2KSwgcmVnLCAocmVzLT5mbGFncyAmIElPUkVTT1VSQ0Vf
SU8pPyAiaW8gcG9ydCI6IjMyYml0IG1taW8iLCByZXMtPnN0YXJ0LCByZXMtPmVuZCk7CiAJCX0K
IAl9CiAJaWYgKHJvbSkgewpAQCAtMzU3LDYgKzM2MCw3IEBAIHZvaWQgX19kZXZpbml0IHBjaV9y
ZWFkX2JyaWRnZV9iYXNlcyhzdHIKIAkJCXJlcy0+c3RhcnQgPSBiYXNlOwogCQlpZiAoIXJlcy0+
ZW5kKQogCQkJcmVzLT5lbmQgPSBsaW1pdCArIDB4ZmZmOworCQlwcmludGsoS0VSTl9JTkZPICJQ
Q0k6IGJyaWRnZSAlcyBpbyBwb3J0OiBbJWxseCwgJWxseF1cbiIsIHBjaV9uYW1lKGRldiksIHJl
cy0+c3RhcnQsIHJlcy0+ZW5kKTsKIAl9CiAKIAlyZXMgPSBjaGlsZC0+cmVzb3VyY2VbMV07CkBA
IC0zNjgsNiArMzcyLDcgQEAgdm9pZCBfX2RldmluaXQgcGNpX3JlYWRfYnJpZGdlX2Jhc2VzKHN0
cgogCQlyZXMtPmZsYWdzID0gKG1lbV9iYXNlX2xvICYgUENJX01FTU9SWV9SQU5HRV9UWVBFX01B
U0spIHwgSU9SRVNPVVJDRV9NRU07CiAJCXJlcy0+c3RhcnQgPSBiYXNlOwogCQlyZXMtPmVuZCA9
IGxpbWl0ICsgMHhmZmZmZjsKKwkJcHJpbnRrKEtFUk5fSU5GTyAiUENJOiBicmlkZ2UgJXMgMzJi
aXQgbW1pbzogWyVsbHgsICVsbHhdXG4iLCBwY2lfbmFtZShkZXYpLCByZXMtPnN0YXJ0LCByZXMt
PmVuZCk7CiAJfQogCiAJcmVzID0gY2hpbGQtPnJlc291cmNlWzJdOwpAQCAtNDAyLDYgKzQwNyw3
IEBAIHZvaWQgX19kZXZpbml0IHBjaV9yZWFkX2JyaWRnZV9iYXNlcyhzdHIKIAkJcmVzLT5mbGFn
cyA9IChtZW1fYmFzZV9sbyAmIFBDSV9NRU1PUllfUkFOR0VfVFlQRV9NQVNLKSB8IElPUkVTT1VS
Q0VfTUVNIHwgSU9SRVNPVVJDRV9QUkVGRVRDSDsKIAkJcmVzLT5zdGFydCA9IGJhc2U7CiAJCXJl
cy0+ZW5kID0gbGltaXQgKyAweGZmZmZmOworCQlwcmludGsoS0VSTl9JTkZPICJQQ0k6IGJyaWRn
ZSAlcyAlc2JpdCBtbWlvIHByZWY6IFslbGx4LCAlbGx4XVxuIiwgcGNpX25hbWUoZGV2KSwgKHJl
cy0+ZmxhZ3MgJiBQQ0lfUFJFRl9SQU5HRV9UWVBFXzY0KT8iNjQiOiIzMiIscmVzLT5zdGFydCwg
cmVzLT5lbmQpOwogCX0KIH0KIAo=
------=_Part_26964_21968996.1216268008879--
