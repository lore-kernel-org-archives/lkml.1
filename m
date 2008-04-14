Return-Path: <linux-kernel-owner+w=401wt.eu-S1759032AbYDNBml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759032AbYDNBml (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 21:42:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753776AbYDNBme
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 21:42:34 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:12501 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753660AbYDNBmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 21:42:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:references;
        b=grwnOMNJf6bsKZ8nbdWJIWTbE8/2iD4PM2AlJVhxdQCs5Pcr26hayy12j0ietUxgY0o3uZ7WvSxReOH0x/D0Lm27WCDDwowjuEH0gmD72iBfBDy32eyuy4Vh/ePK81R3wmRWfHPqjJ+6VCCkr5JypyRoy9aK+KtlSTmVsBYsqmw=
Message-ID: <86802c440804131842t16d05976g20b2eb97af6bbf1b@mail.gmail.com>
Date: Sun, 13 Apr 2008 18:42:31 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: x86 git tree broken (bisected)
Cc: "Ingo Molnar" <mingo@elte.hu>, "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, "Pavel Machek" <pavel@ucw.cz>,
       "Thomas Gleixner" <tglx@linutronix.de>, "H. Anvin" <hpa@zytor.com>,
       "Arjan van de Ven" <arjan@infradead.org>
In-Reply-To: <200804140219.07350.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_25629_29784617.1208137351554"
References: <200804102159.14563.rjw@sisk.pl> <200804140010.01034.rjw@sisk.pl>
	 <86802c440804131532g4626233br82a425d6a96a6e11@mail.gmail.com>
	 <200804140219.07350.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_25629_29784617.1208137351554
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Sun, Apr 13, 2008 at 5:19 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>
> On Monday, 14 of April 2008, Yinghai Lu wrote:
>  > On Sun, Apr 13, 2008 at 3:10 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>  > >
>  > > On Monday, 14 of April 2008, Yinghai Lu wrote:
>  > >  > On Sun, Apr 13, 2008 at 9:12 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>  > >  > ...
>  > >  > >  > can you try to apply the patch i sent to you about agp bridge order
>  > >  > >  > reading for buggy silicon?
>  > >  > >  >
>  > >  > >  > Please boot kernel with "debug"...
>  > >  > >  >
>  > >  > >  > I want to verify if you can get
>  > >  > >  >
>  > >  > >  > "
>  > >  > >  > Aperture conflicts with PCI mapping.
>  > >  > >  > "
>  > >  > >  >
>  > >  > >  > in your boot log...
>  > >  > >
>  > >  > >  It's not present in there:
>  > >  > >
>  > >  > >  rafael@albercik:~> grep Aperture failing-with-patch-dmesg.log
>  > >  > >  Aperture too small (32 MB)
>  > >  > >  Aperture from AGP @ de000000 size 4096 MB (APSIZE 0)
>  > >  > >  Aperture too small (0 MB)
>  > >  > >  agpgart: Aperture pointing to RAM
>  > >  > >  agpgart: Aperture from AGP @ de000000 size 4096 MB
>  > >  > >  agpgart: Aperture too small (0 MB)
>  > >  > >
>  > >  > >  Full dmesg output attached.
>  > >  >
>  > >  > please check attached debug patch. and check if you can change GART
>  > >  > size in your BIOS setup to 64M instead of 32M
>  > >
>  > >  Hm, what tree am I supposed to apply it too:
>  > >  (1) current x86 git
>  > >  (2) current x86 git w/ some of your previous patches (which ones in this case)
>  > >  (3) failing (old) x86 git
>  > >  (4) failing (old) x86 git w/ some of your previous patches (which ones in this
>  > >     case)?
>  >
>  > (1) current x86.git
>
>  Attached is dmesg output from current x86.git with debug_gart_checking.patch
>  applied.

please test the final one ... ...

You should get back 64M memory back.

Thanks

Yinghai Lu

------=_Part_25629_29784617.1208137351554
Content-Type: text/x-patch; name=gart_checking_v2.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ff0dpfaa1
Content-Disposition: attachment; filename=gart_checking_v2.patch

W1BBVENIXSB4ODZfNjQ6IGNoZWNraW5nIGFwZXJ0dXJlIHNpemUgb3JkZXIKCnNvbWUgc3lzdGVt
IGlzIHVzaW5nIDMyTSBmb3IgZ2FydCBhbmQgYWdwIHdoZW4gbWVtb3J5IGlzIGxlc3MgNEcuCmtl
cm5lbCB3aWxsIHJlamVjdCBhbmQgdHJ5IHRvIGFsbGNhdGUgYW5vdGhlciA2NE0gdGhhdCBpcyBu
b3QgbmVlZGVkLgp3ZSB3aWxsIGxvc2UgNjRNIHJhbS4KCnRoaXMgcGF0Y2ggYWRkIHdvcmthcm91
bmQgYnkgY2hlY2tpbmcgYXBlcl9iYXNlL29yZGVyIGJldHdlZW4gTkIgYW5kIGFncCBicmlkZ2Uu
CmlmIHRoZXkgYXJlIHRoZSBzYW1lLCBhbmQgbWVtb3J5IHNpemUgaXMgdGhhbiA0Rywgd2lsbCBs
ZXQgaXQgZ28uCgpTaWduZWQtb2ZmLWJ5OiBZaW5naGFpIEx1IDx5aGx1Lmtlcm5lbEBnbWFpbC5j
b20+CgpJbmRleDogbGludXgtMi42L2FyY2gveDg2L2tlcm5lbC9hcGVydHVyZV82NC5jCj09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT0KLS0tIGxpbnV4LTIuNi5vcmlnL2FyY2gveDg2L2tlcm5lbC9hcGVydHVyZV82NC5jCisr
KyBsaW51eC0yLjYvYXJjaC94ODYva2VybmVsL2FwZXJ0dXJlXzY0LmMKQEAgLTgzLDcgKzgzLDcg
QEAgc3RhdGljIHUzMiBfX2luaXQgYWxsb2NhdGVfYXBlcnR1cmUodm9pZAogCXJldHVybiAodTMy
KV9fcGEocCk7CiB9CiAKLXN0YXRpYyBpbnQgX19pbml0IGFwZXJ0dXJlX3ZhbGlkKHU2NCBhcGVy
X2Jhc2UsIHUzMiBhcGVyX3NpemUpCitzdGF0aWMgaW50IF9faW5pdCBhcGVydHVyZV92YWxpZCh1
NjQgYXBlcl9iYXNlLCB1MzIgYXBlcl9zaXplLCB1MzIgbWluX3NpemUpCiB7CiAJaWYgKCFhcGVy
X2Jhc2UpCiAJCXJldHVybiAwOwpAQCAtOTYsOCArOTYsOSBAQCBzdGF0aWMgaW50IF9faW5pdCBh
cGVydHVyZV92YWxpZCh1NjQgYXBlCiAJCXByaW50ayhLRVJOX0VSUiAiQXBlcnR1cmUgcG9pbnRp
bmcgdG8gZTgyMCBSQU0uIElnbm9yaW5nLlxuIik7CiAJCXJldHVybiAwOwogCX0KLQlpZiAoYXBl
cl9zaXplIDwgNjQqMTAyNCoxMDI0KSB7Ci0JCXByaW50ayhLRVJOX0VSUiAiQXBlcnR1cmUgdG9v
IHNtYWxsICglZCBNQilcbiIsIGFwZXJfc2l6ZT4+MjApOworCWlmIChhcGVyX3NpemUgPCBtaW5f
c2l6ZSkgeworCQlwcmludGsoS0VSTl9FUlIgIkFwZXJ0dXJlIHRvbyBzbWFsbCAoJWQgTUIpIHRo
YW4gKCVkIE1CKVxuIiwKKwkJCQkgYXBlcl9zaXplPj4yMCwgbWluX3NpemU+PjIwKTsKIAkJcmV0
dXJuIDA7CiAJfQogCkBAIC0xNjcsNyArMTY4LDkgQEAgc3RhdGljIF9fdTMyIF9faW5pdCByZWFk
X2FncChpbnQgbnVtLCBpbgogCSAqIE9uIHNvbWUgc2ljayBjaGlwcywgQVBTSVpFIGlzIDAuIEl0
IG1lYW5zIGl0IHdhbnRzIDRHCiAJICogc28gbGV0IGRvdWJsZSBjaGVjayB0aGF0IG9yZGVyLCBh
bmQgbGV0cyB0cnVzdCBBTUQgTkIgc2V0dGluZ3M6CiAJICovCi0JaWYgKGFwZXIgKyAoMzJVTDw8
KDIwICsgKm9yZGVyKSkgPiAweDEwMDAwMDAwMFVMKSB7CisJcHJpbnRrKEtFUk5fSU5GTyAiQXBl
cnR1cmUgZnJvbSBBR1AgQCAlTHggb2xkIHNpemUgJXUgTUJcbiIsCisJCQlhcGVyLCAzMiA8PCBv
bGRfb3JkZXIpOworCWlmIChhcGVyICsgKDMyVUxMPDwoMjAgKyAqb3JkZXIpKSA+IDB4MTAwMDAw
MDAwVUxMKSB7CiAJCXByaW50ayhLRVJOX0lORk8gIkFwZXJ0dXJlIHNpemUgJXUgTUIgKEFQU0la
RSAleCkgaXMgbm90IHJpZ2h0LCB1c2luZyBzZXR0aW5ncyBmcm9tIE5CXG4iLAogCQkJCTMyIDw8
ICpvcmRlciwgYXBzaXplcmVnKTsKIAkJKm9yZGVyID0gb2xkX29yZGVyOwpAQCAtMTc2LDcgKzE3
OSw3IEBAIHN0YXRpYyBfX3UzMiBfX2luaXQgcmVhZF9hZ3AoaW50IG51bSwgaW4KIAlwcmludGso
S0VSTl9JTkZPICJBcGVydHVyZSBmcm9tIEFHUCBAICVMeCBzaXplICV1IE1CIChBUFNJWkUgJXgp
XG4iLAogCQkJYXBlciwgMzIgPDwgKm9yZGVyLCBhcHNpemVyZWcpOwogCi0JaWYgKCFhcGVydHVy
ZV92YWxpZChhcGVyLCAoMzIqMTAyNCoxMDI0KSA8PCAqb3JkZXIpKQorCWlmICghYXBlcnR1cmVf
dmFsaWQoYXBlciwgKDMyKjEwMjQqMTAyNCkgPDwgKm9yZGVyLCAzMjw8MjApKQogCQlyZXR1cm4g
MDsKIAlyZXR1cm4gKHUzMilhcGVyOwogfQpAQCAtMzAyLDggKzMwNSw4IEBAIHZvaWQgX19pbml0
IGVhcmx5X2dhcnRfaW9tbXVfY2hlY2sodm9pZCkKIAkJZml4ID0gMTsKIAogCWlmIChnYXJ0X2Zp
eF9lODIwICYmICFmaXggJiYgYXBlcl9lbmFibGVkKSB7Ci0JCWlmIChlODIwX2FueV9tYXBwZWQo
YXBlcl9iYXNlLCBhcGVyX2Jhc2UgKyBhcGVyX3NpemUsCi0JCQkJICAgIEU4MjBfUkFNKSkgewor
CQlpZiAoIWU4MjBfYWxsX21hcHBlZChhcGVyX2Jhc2UsIGFwZXJfYmFzZSArIGFwZXJfc2l6ZSwK
KwkJCQkgICAgRTgyMF9SRVNFUlZFRCkpIHsKIAkJCS8qIHJlc2VydmVkIGl0LCBzbyB3ZSBjYW4g
cmVzdXNlIGl0IGluIHNlY29uZCBrZXJuZWwgKi8KIAkJCXByaW50ayhLRVJOX0lORk8gInVwZGF0
ZSBlODIwIGZvciBHQVJUXG4iKTsKIAkJCWFkZF9tZW1vcnlfcmVnaW9uKGFwZXJfYmFzZSwgYXBl
cl9zaXplLCBFODIwX1JFU0VSVkVEKTsKQEAgLTMyNCw4ICszMjcsMTEgQEAgdm9pZCBfX2luaXQg
ZWFybHlfZ2FydF9pb21tdV9jaGVjayh2b2lkKQogCiB9CiAKK3N0YXRpYyBpbnQgX19pbml0ZGF0
YSBwcmludGVkX2dhcnRfc2l6ZV9tc2c7CisKIHZvaWQgX19pbml0IGdhcnRfaW9tbXVfaG9sZV9p
bml0KHZvaWQpCiB7CisJdTMyIGFncF9hcGVyX2Jhc2UgPSAwLCBhZ3BfYXBlcl9vcmRlciA9IDA7
CiAJdTMyIGFwZXJfc2l6ZSwgYXBlcl9hbGxvYyA9IDAsIGFwZXJfb3JkZXIgPSAwLCBsYXN0X2Fw
ZXJfb3JkZXIgPSAwOwogCXU2NCBhcGVyX2Jhc2UsIGxhc3RfYXBlcl9iYXNlID0gMDsKIAlpbnQg
Zml4LCBudW0sIHZhbGlkX2FncCA9IDA7CkBAIC0zMzcsNiArMzQzLDkgQEAgdm9pZCBfX2luaXQg
Z2FydF9pb21tdV9ob2xlX2luaXQodm9pZCkKIAogCXByaW50ayhLRVJOX0lORk8gICJDaGVja2lu
ZyBhcGVydHVyZS4uLlxuIik7CiAKKwlpZiAoIWZhbGxiYWNrX2FwZXJfZm9yY2UpCisJCWFncF9h
cGVyX2Jhc2UgPSBzZWFyY2hfYWdwX2JyaWRnZSgmYWdwX2FwZXJfb3JkZXIsICZ2YWxpZF9hZ3Ap
OworCiAJZml4ID0gMDsKIAlub2RlID0gMDsKIAlmb3IgKG51bSA9IDI0OyBudW0gPCAzMjsgbnVt
KyspIHsKQEAgLTM1NSw5ICszNjQsMjEgQEAgdm9pZCBfX2luaXQgZ2FydF9pb21tdV9ob2xlX2lu
aXQodm9pZCkKIAkJCQlub2RlLCBhcGVyX2Jhc2UsIGFwZXJfc2l6ZSA+PiAyMCk7CiAJCW5vZGUr
KzsKIAotCQlpZiAoIWFwZXJ0dXJlX3ZhbGlkKGFwZXJfYmFzZSwgYXBlcl9zaXplKSkgewotCQkJ
Zml4ID0gMTsKLQkJCWJyZWFrOworCQlpZiAoIWFwZXJ0dXJlX3ZhbGlkKGFwZXJfYmFzZSwgYXBl
cl9zaXplLCA2NDw8MjApKSB7CisJCQlpZiAodmFsaWRfYWdwICYmIGFncF9hcGVyX2Jhc2UgJiYK
KwkJCSAgICBhZ3BfYXBlcl9iYXNlID09IGFwZXJfYmFzZSAmJgorCQkJICAgIGFncF9hcGVyX29y
ZGVyID09IGFwZXJfb3JkZXIpIHsKKwkJCQkvKiB0aGUgc2FtZSBiZXR3ZWVuIHR3byBzZXR0aW5n
IGZyb20gTkIgYW5kIGFncCAqLworCQkJCWlmICghbm9faW9tbXUgJiYgZW5kX3BmbiA+IE1BWF9E
TUEzMl9QRk4gJiYgIXByaW50ZWRfZ2FydF9zaXplX21zZykgeworCQkJCQlwcmludGsoS0VSTl9F
UlIgInlvdSBhcmUgdXNpbmcgaW9tbXUgd2l0aCBhZ3AsIGJ1dCBHQVJUIHNpemUgaXMgbGVzcyB0
aGFuIDY0TVxuIik7CisJCQkJCXByaW50ayhLRVJOX0VSUiAicGxlYXNlIGluY3JlYXNlIEdBUlQg
c2l6ZSBpbiB5b3VyIEJJT1Mgc2V0dXBcbiIpOworCQkJCQlwcmludGsoS0VSTl9FUlIgImlmIEJJ
T1MgZG9lc24ndCBoYXZlIHRoYXQgb3B0aW9uLCBjb250YWN0IHlvdXIgSFcgdmVuZG9yIVxuIik7
CisJCQkJCXByaW50ZWRfZ2FydF9zaXplX21zZyA9IDE7CisJCQkJfQorCQkJfSBlbHNlIHsKKwkJ
CQlmaXggPSAxOworCQkJCWJyZWFrOworCQkJfQogCQl9CiAKIAkJaWYgKChsYXN0X2FwZXJfb3Jk
ZXIgJiYgYXBlcl9vcmRlciAhPSBsYXN0X2FwZXJfb3JkZXIpIHx8CkBAIC0zNzgsOCArMzk5LDEw
IEBAIHZvaWQgX19pbml0IGdhcnRfaW9tbXVfaG9sZV9pbml0KHZvaWQpCiAJCXJldHVybjsKIAl9
CiAKLQlpZiAoIWZhbGxiYWNrX2FwZXJfZm9yY2UpCi0JCWFwZXJfYWxsb2MgPSBzZWFyY2hfYWdw
X2JyaWRnZSgmYXBlcl9vcmRlciwgJnZhbGlkX2FncCk7CisJaWYgKCFmYWxsYmFja19hcGVyX2Zv
cmNlKSB7CisJCWFwZXJfYWxsb2MgPSBhZ3BfYXBlcl9iYXNlOworCQlhcGVyX29yZGVyID0gYWdw
X2FwZXJfb3JkZXI7CisJfQogCiAJaWYgKGFwZXJfYWxsb2MpIHsKIAkJLyogR290IHRoZSBhcGVy
dHVyZSBmcm9tIHRoZSBBR1AgYnJpZGdlICovCkluZGV4OiBsaW51eC0yLjYvZHJpdmVycy9jaGFy
L2FncC9hbWQ2NC1hZ3AuYwo9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09Ci0tLSBsaW51eC0yLjYub3JpZy9kcml2ZXJzL2No
YXIvYWdwL2FtZDY0LWFncC5jCisrKyBsaW51eC0yLjYvZHJpdmVycy9jaGFyL2FncC9hbWQ2NC1h
Z3AuYwpAQCAtMjQ1LDExICsyNDUsNyBAQCBzdGF0aWMgaW50IF9fZGV2aW5pdCBhcGVydHVyZV92
YWxpZCh1NjQgCiAJCXByaW50ayhLRVJOX0VSUiBQRlggIk5vIGFwZXJ0dXJlXG4iKTsKIAkJcmV0
dXJuIDA7CiAJfQotCWlmIChzaXplIDwgMzIqMTAyNCoxMDI0KSB7Ci0JCXByaW50ayhLRVJOX0VS
UiBQRlggIkFwZXJ0dXJlIHRvbyBzbWFsbCAoJWQgTUIpXG4iLCBzaXplPj4yMCk7Ci0JCXJldHVy
biAwOwotCX0KLSAgICAgICBpZiAoKHU2NClhcGVyICsgc2l6ZSA+IDB4MTAwMDAwMDAwVUxMKSB7
CisJaWYgKCh1NjQpYXBlciArIHNpemUgPiAweDEwMDAwMDAwMFVMTCkgewogCQlwcmludGsoS0VS
Tl9FUlIgUEZYICJBcGVydHVyZSBvdXQgb2YgYm91bmRzXG4iKTsKIAkJcmV0dXJuIDA7CiAJfQpA
QCAtMjU3LDYgKzI1MywxMCBAQCBzdGF0aWMgaW50IF9fZGV2aW5pdCBhcGVydHVyZV92YWxpZCh1
NjQgCiAJCXByaW50ayhLRVJOX0VSUiBQRlggIkFwZXJ0dXJlIHBvaW50aW5nIHRvIFJBTVxuIik7
CiAJCXJldHVybiAwOwogCX0KKwlpZiAoc2l6ZSA8IDMyKjEwMjQqMTAyNCkgeworCQlwcmludGso
S0VSTl9FUlIgUEZYICJBcGVydHVyZSB0b28gc21hbGwgKCVkIE1CKVxuIiwgc2l6ZT4+MjApOwor
CQlyZXR1cm4gMDsKKwl9CiAKIAkvKiBSZXF1ZXN0IHRoZSBBcGVydHVyZS4gVGhpcyBjYXRjaGVz
IGNhc2VzIHdoZW4gc29tZW9uZSBlbHNlCiAJICAgYWxyZWFkeSBwdXQgYSBtYXBwaW5nIGluIHRo
ZXJlIC0gaGFwcGVucyB3aXRoIHNvbWUgdmVyeSBicm9rZW4gQklPUwpAQCAtMzE3LDcgKzMxNyw3
IEBAIHN0YXRpYyBfX2RldmluaXQgaW50IGZpeF9ub3J0aGJyaWRnZShzdHIKIAkgKiBPbiBzb21l
IHNpY2sgY2hpcHMgQVBTSVpFIGlzIDAuIFRoaXMgbWVhbnMgaXQgd2FudHMgNEcKIAkgKiBzbyBs
ZXQgZG91YmxlIGNoZWNrIHRoYXQgb3JkZXIsIGFuZCBsZXRzIHRydXN0IHRoZSBBTUQgTkIgc2V0
dGluZ3MKIAkgKi8KLQlpZiAoYXBlciArICgzMlVMTDw8KDIwICsgb3JkZXIpKSA+IDB4MTAwMDAw
MDAwVUxMKSB7CisJaWYgKG9yZGVyID49MCAmJiBhcGVyICsgKDMyVUxMPDwoMjAgKyBvcmRlcikp
ID4gMHgxMDAwMDAwMDBVTEwpIHsKIAkJcHJpbnRrKEtFUk5fSU5GTyAiQXBlcnR1cmUgc2l6ZSAl
dSBNQiBpcyBub3QgcmlnaHQsIHVzaW5nIHNldHRpbmdzIGZyb20gTkJcbiIsCiAJCQkJICAzMiA8
PCBvcmRlcik7CiAJCW9yZGVyID0gbmJfb3JkZXI7Cg==
------=_Part_25629_29784617.1208137351554--
