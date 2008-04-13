Return-Path: <linux-kernel-owner+w=401wt.eu-S1755511AbYDMWAh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511AbYDMWAh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 18:00:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751806AbYDMWA3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 18:00:29 -0400
Received: from rv-out-0708.google.com ([209.85.198.241]:5298 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751673AbYDMWA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 18:00:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:references;
        b=uk21pjRnWNAZlDkFnA7nlvNWi6peWlkcWl3pRBvjYORcUlGd9Uz7SWdOsjSVThdEDYbuyowuqVOZRsU2K+9rp4+LE3FqLsCdNQj2BinkC8JHsUtk5G5FLTNU5JqxNjzpmVMbDszIu3n4Hl/pHU/Knu+PGPu6MsCU22CfDHn+rUM=
Message-ID: <86802c440804131500q420f7442hd8512cc6f4a1a6fd@mail.gmail.com>
Date: Sun, 13 Apr 2008 15:00:28 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: x86 git tree broken (bisected)
Cc: "Ingo Molnar" <mingo@elte.hu>, "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, "Pavel Machek" <pavel@ucw.cz>,
       "Thomas Gleixner" <tglx@linutronix.de>, "H. Anvin" <hpa@zytor.com>,
       "Arjan van de Ven" <arjan@infradead.org>
In-Reply-To: <200804131812.55684.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_25399_1428928.1208124028495"
References: <200804102159.14563.rjw@sisk.pl> <200804112251.09769.rjw@sisk.pl>
	 <86802c440804130124l2b0cb199x4d75f2df68f93fa4@mail.gmail.com>
	 <200804131812.55684.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_25399_1428928.1208124028495
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Sun, Apr 13, 2008 at 9:12 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
...
>  > can you try to apply the patch i sent to you about agp bridge order
>  > reading for buggy silicon?
>  >
>  > Please boot kernel with "debug"...
>  >
>  > I want to verify if you can get
>  >
>  > "
>  > Aperture conflicts with PCI mapping.
>  > "
>  >
>  > in your boot log...
>
>  It's not present in there:
>
>  rafael@albercik:~> grep Aperture failing-with-patch-dmesg.log
>  Aperture too small (32 MB)
>  Aperture from AGP @ de000000 size 4096 MB (APSIZE 0)
>  Aperture too small (0 MB)
>  agpgart: Aperture pointing to RAM
>  agpgart: Aperture from AGP @ de000000 size 4096 MB
>  agpgart: Aperture too small (0 MB)
>
>  Full dmesg output attached.

please check attached debug patch. and check if you can change GART
size in your BIOS setup to 64M instead of 32M

Thanks

YH

------=_Part_25399_1428928.1208124028495
Content-Type: text/x-patch; name=debug_gart_checking.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ff04xx9d1
Content-Disposition: attachment; filename=debug_gart_checking.patch

W1BBVENIXSB4ODZfNjQ6IGNoZWNraW5nIGFwZXJ0dXJlIHNpemUgb3JkZXIuLi4KCmRpZmYgLS1n
aXQgYS9hcmNoL3g4Ni9rZXJuZWwvYXBlcnR1cmVfNjQuYyBiL2FyY2gveDg2L2tlcm5lbC9hcGVy
dHVyZV82NC5jCmluZGV4IDJlOTNiMzEuLmU4NjY4OWEgMTAwNjQ0Ci0tLSBhL2FyY2gveDg2L2tl
cm5lbC9hcGVydHVyZV82NC5jCisrKyBiL2FyY2gveDg2L2tlcm5lbC9hcGVydHVyZV82NC5jCkBA
IC05Niw3ICs5Niw3IEBAIHN0YXRpYyBpbnQgX19pbml0IGFwZXJ0dXJlX3ZhbGlkKHU2NCBhcGVy
X2Jhc2UsIHUzMiBhcGVyX3NpemUpCiAJCXByaW50ayhLRVJOX0VSUiAiQXBlcnR1cmUgcG9pbnRp
bmcgdG8gZTgyMCBSQU0uIElnbm9yaW5nLlxuIik7CiAJCXJldHVybiAwOwogCX0KLQlpZiAoYXBl
cl9zaXplIDwgNjQqMTAyNCoxMDI0KSB7CisJaWYgKGFwZXJfc2l6ZSA8IDMyKjEwMjQqMTAyNCkg
ewogCQlwcmludGsoS0VSTl9FUlIgIkFwZXJ0dXJlIHRvbyBzbWFsbCAoJWQgTUIpXG4iLCBhcGVy
X3NpemU+PjIwKTsKIAkJcmV0dXJuIDA7CiAJfQpAQCAtMTY3LDcgKzE2Nyw5IEBAIHN0YXRpYyBf
X3UzMiBfX2luaXQgcmVhZF9hZ3AoaW50IG51bSwgaW50IHNsb3QsIGludCBmdW5jLCBpbnQgY2Fw
LCB1MzIgKm9yZGVyKQogCSAqIE9uIHNvbWUgc2ljayBjaGlwcywgQVBTSVpFIGlzIDAuIEl0IG1l
YW5zIGl0IHdhbnRzIDRHCiAJICogc28gbGV0IGRvdWJsZSBjaGVjayB0aGF0IG9yZGVyLCBhbmQg
bGV0cyB0cnVzdCBBTUQgTkIgc2V0dGluZ3M6CiAJICovCi0JaWYgKGFwZXIgKyAoMzJVTDw8KDIw
ICsgKm9yZGVyKSkgPiAweDEwMDAwMDAwMFVMKSB7CisJcHJpbnRrKEtFUk5fSU5GTyAiQXBlcnR1
cmUgZnJvbSBBR1AgQCAlTHggb2xkIHNpemUgJXUgTUJcbiIsCisJCQlhcGVyLCAzMiA8PCBvbGRf
b3JkZXIpOworCWlmIChhcGVyICsgKDMyVUxMPDwoMjAgKyAqb3JkZXIpKSA+IDB4MTAwMDAwMDAw
VUxMKSB7CiAJCXByaW50ayhLRVJOX0lORk8gIkFwZXJ0dXJlIHNpemUgJXUgTUIgKEFQU0laRSAl
eCkgaXMgbm90IHJpZ2h0LCB1c2luZyBzZXR0aW5ncyBmcm9tIE5CXG4iLAogCQkJCTMyIDw8ICpv
cmRlciwgYXBzaXplcmVnKTsKIAkJKm9yZGVyID0gb2xkX29yZGVyOwpAQCAtMzAyLDggKzMwNCw4
IEBAIHZvaWQgX19pbml0IGVhcmx5X2dhcnRfaW9tbXVfY2hlY2sodm9pZCkKIAkJZml4ID0gMTsK
IAogCWlmIChnYXJ0X2ZpeF9lODIwICYmICFmaXggJiYgYXBlcl9lbmFibGVkKSB7Ci0JCWlmIChl
ODIwX2FueV9tYXBwZWQoYXBlcl9iYXNlLCBhcGVyX2Jhc2UgKyBhcGVyX3NpemUsCi0JCQkJICAg
IEU4MjBfUkFNKSkgeworCQlpZiAoIWU4MjBfYWxsX21hcHBlZChhcGVyX2Jhc2UsIGFwZXJfYmFz
ZSArIGFwZXJfc2l6ZSwKKwkJCQkgICAgRTgyMF9SRVNFUlZFRCkpIHsKIAkJCS8qIHJlc2VydmVk
IGl0LCBzbyB3ZSBjYW4gcmVzdXNlIGl0IGluIHNlY29uZCBrZXJuZWwgKi8KIAkJCXByaW50ayhL
RVJOX0lORk8gInVwZGF0ZSBlODIwIGZvciBHQVJUXG4iKTsKIAkJCWFkZF9tZW1vcnlfcmVnaW9u
KGFwZXJfYmFzZSwgYXBlcl9zaXplLCBFODIwX1JFU0VSVkVEKTsKZGlmZiAtLWdpdCBhL2RyaXZl
cnMvY2hhci9hZ3AvYW1kNjQtYWdwLmMgYi9kcml2ZXJzL2NoYXIvYWdwL2FtZDY0LWFncC5jCmlu
ZGV4IDhmYzA1YzguLjk3ZDQ4MjEgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvY2hhci9hZ3AvYW1kNjQt
YWdwLmMKKysrIGIvZHJpdmVycy9jaGFyL2FncC9hbWQ2NC1hZ3AuYwpAQCAtMjQ1LDExICsyNDUs
NyBAQCBzdGF0aWMgaW50IF9fZGV2aW5pdCBhcGVydHVyZV92YWxpZCh1NjQgYXBlciwgdTMyIHNp
emUpCiAJCXByaW50ayhLRVJOX0VSUiBQRlggIk5vIGFwZXJ0dXJlXG4iKTsKIAkJcmV0dXJuIDA7
CiAJfQotCWlmIChzaXplIDwgMzIqMTAyNCoxMDI0KSB7Ci0JCXByaW50ayhLRVJOX0VSUiBQRlgg
IkFwZXJ0dXJlIHRvbyBzbWFsbCAoJWQgTUIpXG4iLCBzaXplPj4yMCk7Ci0JCXJldHVybiAwOwot
CX0KLSAgICAgICBpZiAoKHU2NClhcGVyICsgc2l6ZSA+IDB4MTAwMDAwMDAwVUxMKSB7CisJaWYg
KCh1NjQpYXBlciArIHNpemUgPiAweDEwMDAwMDAwMFVMTCkgewogCQlwcmludGsoS0VSTl9FUlIg
UEZYICJBcGVydHVyZSBvdXQgb2YgYm91bmRzXG4iKTsKIAkJcmV0dXJuIDA7CiAJfQpAQCAtMjU3
LDYgKzI1MywxMCBAQCBzdGF0aWMgaW50IF9fZGV2aW5pdCBhcGVydHVyZV92YWxpZCh1NjQgYXBl
ciwgdTMyIHNpemUpCiAJCXByaW50ayhLRVJOX0VSUiBQRlggIkFwZXJ0dXJlIHBvaW50aW5nIHRv
IFJBTVxuIik7CiAJCXJldHVybiAwOwogCX0KKwlpZiAoc2l6ZSA8IDMyKjEwMjQqMTAyNCkgewor
CQlwcmludGsoS0VSTl9FUlIgUEZYICJBcGVydHVyZSB0b28gc21hbGwgKCVkIE1CKVxuIiwgc2l6
ZT4+MjApOworCQlyZXR1cm4gMDsKKwl9CiAKIAkvKiBSZXF1ZXN0IHRoZSBBcGVydHVyZS4gVGhp
cyBjYXRjaGVzIGNhc2VzIHdoZW4gc29tZW9uZSBlbHNlCiAJICAgYWxyZWFkeSBwdXQgYSBtYXBw
aW5nIGluIHRoZXJlIC0gaGFwcGVucyB3aXRoIHNvbWUgdmVyeSBicm9rZW4gQklPUwpAQCAtMzE3
LDcgKzMxNyw3IEBAIHN0YXRpYyBfX2RldmluaXQgaW50IGZpeF9ub3J0aGJyaWRnZShzdHJ1Y3Qg
cGNpX2RldiAqbmIsIHN0cnVjdCBwY2lfZGV2ICphZ3AsCiAJICogT24gc29tZSBzaWNrIGNoaXBz
IEFQU0laRSBpcyAwLiBUaGlzIG1lYW5zIGl0IHdhbnRzIDRHCiAJICogc28gbGV0IGRvdWJsZSBj
aGVjayB0aGF0IG9yZGVyLCBhbmQgbGV0cyB0cnVzdCB0aGUgQU1EIE5CIHNldHRpbmdzCiAJICov
Ci0JaWYgKGFwZXIgKyAoMzJVTEw8PCgyMCArIG9yZGVyKSkgPiAweDEwMDAwMDAwMFVMTCkgewor
CWlmIChvcmRlciA+PTAgJiYgYXBlciArICgzMlVMTDw8KDIwICsgb3JkZXIpKSA+IDB4MTAwMDAw
MDAwVUxMKSB7CiAJCXByaW50ayhLRVJOX0lORk8gIkFwZXJ0dXJlIHNpemUgJXUgTUIgaXMgbm90
IHJpZ2h0LCB1c2luZyBzZXR0aW5ncyBmcm9tIE5CXG4iLAogCQkJCSAgMzIgPDwgb3JkZXIpOwog
CQlvcmRlciA9IG5iX29yZGVyOwo=
------=_Part_25399_1428928.1208124028495--
