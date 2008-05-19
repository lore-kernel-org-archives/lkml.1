Return-Path: <linux-kernel-owner+w=401wt.eu-S1757731AbYESDnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757731AbYESDnU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 23:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754586AbYESDnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 23:43:12 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:39957 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754581AbYESDnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 23:43:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:references;
        b=CCps20PoGFolyk260V4Qy4K1KDzsTutfvd4GDL9Oa2eTiczygZIYpZfZJzWJaC6wrv6F0t2LpXGz+HrtarvDzGH08v37JvsB26pQ5kENkt8h4Qz34E26UyhmjAgTKqlL7dJHoNcJdikqn0YHc+MNrXaF/Mh/WBdxJqu9fd80pU4=
Message-ID: <86802c440805182043n2a4855bcw6924f6df2fbdc9f4@mail.gmail.com>
Date: Sun, 18 May 2008 20:43:09 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ciaran McCreesh" <ciaran.mccreesh@googlemail.com>
Subject: Re: kernel boot hangs after x86: insert_resorce for lapic addr after e820_reserve_resources
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
In-Reply-To: <20080518232347.7964835c@snowcone>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_14744_14669863.1211168590021"
References: <20080518014111.4f32298b@googlemail.com>
	 <86802c440805172055x30c2c6feg441e16f5fb24f64f@mail.gmail.com>
	 <20080518164127.2236d82a@googlemail.com>
	 <86802c440805181400m5a3b4e28oeab6245e9a2ffd00@mail.gmail.com>
	 <20080518232347.7964835c@snowcone>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_14744_14669863.1211168590021
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Sun, May 18, 2008 at 3:23 PM, Ciaran McCreesh
<ciaran.mccreesh@googlemail.com> wrote:
> On Sun, 18 May 2008 14:00:16 -0700
> "Yinghai Lu" <yhlu.kernel@gmail.com> wrote:
>> >> wonder if init_apic_mapping need some delay with that strange
>> >> chipset.
>> >
>> > I don't see any additional information with apic=verbose with the
>> > broken kernel (although I only have a screen's worth of text that I
>> > can see -- the kernel doesn't get far enough to let me grab it).
>> > I've attached dmesg from a working kernel with apic=verbose in case
>> > that helps.
>>
>> or try to boot with initcall_debug to see where did it hang.
>
> The last initcall_debug messages are:
>
>    calling atiixp_ide_init+0x0/0x20
>    initcall atiixp_ide_init+0x0/0x20 returned 0 after 0 msecs
>    calling piix_ide_init+0x0/0xc0
>    initcall piix_ide_init+0x0/0xc0 returned 0 after 0 msecs
>    calling ide_scan_pcibus+0x0/0x100
>
> ide_scan_pcibus doesn't return. I tried shoving some printks in there,
> but as soon as I did it instead locked up in pci_init. Is it worth
> continuing this approach or will doing so not give useful results
> anyway?

could be pci iomem conflicts...
please enable CONFIG_PCI_DEBUG=y
and apply the following two debug patches

YH

------=_Part_14744_14669863.1211168590021
Content-Type: text/x-patch; name=debug_extra_pci_res_range.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fgeigj020
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
------=_Part_14744_14669863.1211168590021
Content-Type: text/x-patch; name=debug_extra_pci_bus_res.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fgeihkcq1
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
------=_Part_14744_14669863.1211168590021--
