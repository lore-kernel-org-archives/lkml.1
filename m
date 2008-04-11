Return-Path: <linux-kernel-owner+w=401wt.eu-S1760937AbYDKU0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760937AbYDKU0S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 16:26:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759211AbYDKU0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 16:26:09 -0400
Received: from wx-out-0506.google.com ([66.249.82.232]:22062 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759116AbYDKU0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 16:26:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:references;
        b=AiaHpzXxhGuxwoSrfd33h4hKT9WFZHPB9VOWSqCuhd3Z+7aXqpeQ2fwFADPTqKN0zqRh+Gmd7WU24FMPGPOoyK6magPP9FG5gZgAb+Qb1TxTCiw/w6z4G2OuUOMjUouyT3F2hv3SlWlpVrWbdY/EQ/O+zCnaYPBbEQ1b9KjH0vQ=
Message-ID: <86802c440804111326t4c3ff4b6od33a128560b58aec@mail.gmail.com>
Date: Fri, 11 Apr 2008 13:26:06 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: x86 git tree broken (bisected)
Cc: "Ingo Molnar" <mingo@elte.hu>, "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, "Pavel Machek" <pavel@ucw.cz>,
       "Thomas Gleixner" <tglx@linutronix.de>, "H. Anvin" <hpa@zytor.com>,
       "Arjan van de Ven" <arjan@infradead.org>
In-Reply-To: <200804112126.29455.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_21364_6091728.1207945566704"
References: <200804102159.14563.rjw@sisk.pl> <20080410203800.GA14560@elte.hu>
	 <200804110028.22290.rjw@sisk.pl> <200804112126.29455.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_21364_6091728.1207945566704
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Fri, Apr 11, 2008 at 12:26 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Friday, 11 of April 2008, Rafael J. Wysocki wrote:
>  > On Thursday, 10 of April 2008, Ingo Molnar wrote:
>  > >
>  > > * Ingo Molnar <mingo@elte.hu> wrote:
>  > >
>  > > > > > > First, the X server doesn't want to start (it says it couldn't
>  > > > > > > mmap the framebuffer).
>  > > > > >
>  > > > > > could you send your .config?
>  > > > >
>  > > > > Attached.
>  > > >
>  > > > could you disable this option:
>  > > >
>  > > >  CONFIG_NONPROMISC_DEVMEM=y
>  > > >
>  > > > does it help with the X problem?
>  >
>  > That didn't help.
>  >
>  > > btw., Xorg works fine here on a comparable AMD system - but i use a
>  > > rather new distro (Fedora 8) which has Xorg 7.2.
>  >
>  > My system is an OpenSUSE 10.3 and it has Xorg 7.2 as well.
>  >
>  > I think the problem is somehow related to the Radeon.
>
>  The bisection turned up commit ea1441bdf53692c3dc1fd2658addcf1205629661
>  "x86: use bus conf in NB conf fun1 to get bus range on, on 64-bit"  as the one
>  causing problems.
>
>  Unfortunately, I can't revert cleanly it, because there are two more commits
>  depending on it in a highly nontrivial fashion, so I have reverted all three
>  commits
>
>  a365998cd2cecfb827469dbd57c29602c106cb83
>  44f7f90fbe7a3a99aab082f765346514b7b5c705
>  ea1441bdf53692c3dc1fd2658addcf1205629661
>
>  and X starts again.  Also, suspend to RAM works from under X.

please keep the three patches and applied the two attached debug patches.

i wonder if there is some io allocation overlapping with your system.

YH

------=_Part_21364_6091728.1207945566704
Content-Type: text/x-patch; name=debug_extra_pci_bus_res.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fex7m89r0
Content-Disposition: attachment; filename=debug_extra_pci_bus_res.patch

SW5kZXg6IGxpbnV4LTIuNi9kcml2ZXJzL3BjaS9zZXR1cC1idXMuYwo9PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09Ci0tLSBs
aW51eC0yLjYub3JpZy9kcml2ZXJzL3BjaS9zZXR1cC1idXMuYworKysgbGludXgtMi42L2RyaXZl
cnMvcGNpL3NldHVwLWJ1cy5jCkBAIC01MzYsNiArNTM2LDM2IEBAIHZvaWQgX19yZWYgcGNpX2J1
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
ZF9yZXNvdXJjZXModm9pZCkKIHsKQEAgLTU1MSw0ICs1ODEsOSBAQCBwY2lfYXNzaWduX3VuYXNz
aWduZWRfcmVzb3VyY2VzKHZvaWQpCiAJCXBjaV9idXNfYXNzaWduX3Jlc291cmNlcyhidXMpOwog
CQlwY2lfZW5hYmxlX2JyaWRnZXMoYnVzKTsKIAl9CisKKwkvKiBkdW1wIHRoZSByZXNvdXJjZSBv
biBidXNlcyAqLworCWxpc3RfZm9yX2VhY2hfZW50cnkoYnVzLCAmcGNpX3Jvb3RfYnVzZXMsIG5v
ZGUpIHsKKwkJcGNpX2J1c19kdW1wX3Jlc291cmNlcyhidXMpOworCX0KIH0K
------=_Part_21364_6091728.1207945566704
Content-Type: text/x-patch; name=debug_extra_pci_res_range.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fex7nk9t1
Content-Disposition: attachment; filename=debug_extra_pci_res_range.patch

SW5kZXg6IGxpbnV4LTIuNi9kcml2ZXJzL3BjaS9wcm9iZS5jCj09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0KLS0tIGxpbnV4
LTIuNi5vcmlnL2RyaXZlcnMvcGNpL3Byb2JlLmMKKysrIGxpbnV4LTIuNi9kcml2ZXJzL3BjaS9w
cm9iZS5jCkBAIC0yNDYsNiArMjQ2LDcgQEAgc3RhdGljIHZvaWQgcGNpX3JlYWRfYmFzZXMoc3Ry
dWN0IHBjaV9kZQogCQkJfQogCQkJcmVzLT5zdGFydCA9IGw2NCAmIFBDSV9CQVNFX0FERFJFU1Nf
TUVNX01BU0s7CiAJCQlyZXMtPmVuZCA9IHJlcy0+c3RhcnQgKyBzejY0OworCQkJcHJpbnRrKEtF
Uk5fSU5GTyAiUENJOiAlcyByZWcgJXggNjRiaXQgbW1pbzogWyVsbHgsICVsbHhdXG4iLCBwY2lf
bmFtZShkZXYpLCByZWcsIHJlcy0+c3RhcnQsIHJlcy0+ZW5kKTsKICNlbHNlCiAJCQlpZiAoc3o2
NCA+IDB4MTAwMDAwMDAwVUxMKSB7CiAJCQkJcHJpbnRrKEtFUk5fRVJSICJQQ0k6IFVuYWJsZSB0
byBoYW5kbGUgNjQtYml0ICIKQEAgLTI2MSw2ICsyNjIsOCBAQCBzdGF0aWMgdm9pZCBwY2lfcmVh
ZF9iYXNlcyhzdHJ1Y3QgcGNpX2RlCiAJCQkJcmVzLT5lbmQgPSBzejsKIAkJCX0KICNlbmRpZgor
CQl9IGVsc2UgeworCQkJcHJpbnRrKEtFUk5fSU5GTyAiUENJOiAlcyByZWcgJXggJXM6IFslbGx4
LCAlbGx4XVxuIiwgcGNpX25hbWUoZGV2KSwgcmVnLCAocmVzLT5mbGFncyAmIElPUkVTT1VSQ0Vf
SU8pPyAiaW8gcG9ydCI6IjMyYml0IG1taW8iLCByZXMtPnN0YXJ0LCByZXMtPmVuZCk7CiAJCX0K
IAl9CiAJaWYgKHJvbSkgewpAQCAtMzI3LDYgKzMzMCw3IEBAIHZvaWQgX19kZXZpbml0IHBjaV9y
ZWFkX2JyaWRnZV9iYXNlcyhzdHIKIAkJCXJlcy0+c3RhcnQgPSBiYXNlOwogCQlpZiAoIXJlcy0+
ZW5kKQogCQkJcmVzLT5lbmQgPSBsaW1pdCArIDB4ZmZmOworCQlwcmludGsoS0VSTl9JTkZPICJQ
Q0k6IGJyaWRnZSAlcyBpbyBwb3J0OiBbJWxseCwgJWxseF1cbiIsIHBjaV9uYW1lKGRldiksIHJl
cy0+c3RhcnQsIHJlcy0+ZW5kKTsKIAl9CiAKIAlyZXMgPSBjaGlsZC0+cmVzb3VyY2VbMV07CkBA
IC0zMzgsNiArMzQyLDcgQEAgdm9pZCBfX2RldmluaXQgcGNpX3JlYWRfYnJpZGdlX2Jhc2VzKHN0
cgogCQlyZXMtPmZsYWdzID0gKG1lbV9iYXNlX2xvICYgUENJX01FTU9SWV9SQU5HRV9UWVBFX01B
U0spIHwgSU9SRVNPVVJDRV9NRU07CiAJCXJlcy0+c3RhcnQgPSBiYXNlOwogCQlyZXMtPmVuZCA9
IGxpbWl0ICsgMHhmZmZmZjsKKwkJcHJpbnRrKEtFUk5fSU5GTyAiUENJOiBicmlkZ2UgJXMgMzJi
aXQgbW1pbzogWyVsbHgsICVsbHhdXG4iLCBwY2lfbmFtZShkZXYpLCByZXMtPnN0YXJ0LCByZXMt
PmVuZCk7CiAJfQogCiAJcmVzID0gY2hpbGQtPnJlc291cmNlWzJdOwpAQCAtMzcyLDYgKzM3Nyw3
IEBAIHZvaWQgX19kZXZpbml0IHBjaV9yZWFkX2JyaWRnZV9iYXNlcyhzdHIKIAkJcmVzLT5mbGFn
cyA9IChtZW1fYmFzZV9sbyAmIFBDSV9NRU1PUllfUkFOR0VfVFlQRV9NQVNLKSB8IElPUkVTT1VS
Q0VfTUVNIHwgSU9SRVNPVVJDRV9QUkVGRVRDSDsKIAkJcmVzLT5zdGFydCA9IGJhc2U7CiAJCXJl
cy0+ZW5kID0gbGltaXQgKyAweGZmZmZmOworCQlwcmludGsoS0VSTl9JTkZPICJQQ0k6IGJyaWRn
ZSAlcyAlc2JpdCBtbWlvIHByZWY6IFslbGx4LCAlbGx4XVxuIiwgcGNpX25hbWUoZGV2KSwgKHJl
cy0+ZmxhZ3MgJiBQQ0lfUFJFRl9SQU5HRV9UWVBFXzY0KT8iNjQiOiIzMiIscmVzLT5zdGFydCwg
cmVzLT5lbmQpOwogCX0KIH0KIAo=
------=_Part_21364_6091728.1207945566704--
