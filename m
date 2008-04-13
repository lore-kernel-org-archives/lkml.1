Return-Path: <linux-kernel-owner+w=401wt.eu-S1755966AbYDMImQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966AbYDMImQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 04:42:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753166AbYDMImA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 04:42:00 -0400
Received: from rv-out-0708.google.com ([209.85.198.246]:45915 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751662AbYDMIl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 04:41:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:references;
        b=Vs0S3DOaQWgrHK6hychxoTxPHXvWLUeHTCj5YfkxEs6/e5e7iO22ufTySuTEoS51xilF/7hul1o0tv1nZS/YWgw/OxKOnszfwzl++pKn1qK0gO2s5Df+Re3t2kE8Sda0JWBcE5Ls2oIqyJ9Ko0s2lpG0B0gMTzJkuE3CQKynE7k=
Message-ID: <86802c440804130141uf7d5553s2e1b9eb43877d399@mail.gmail.com>
Date: Sun, 13 Apr 2008 01:41:58 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: x86 git tree broken (bisected)
Cc: "Ingo Molnar" <mingo@elte.hu>, "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, "Pavel Machek" <pavel@ucw.cz>,
       "Thomas Gleixner" <tglx@linutronix.de>, "H. Anvin" <hpa@zytor.com>,
       "Arjan van de Ven" <arjan@infradead.org>
In-Reply-To: <86802c440804130124l2b0cb199x4d75f2df68f93fa4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_24179_32618028.1208076118527"
References: <200804102159.14563.rjw@sisk.pl> <200804112126.29455.rjw@sisk.pl>
	 <86802c440804111326t4c3ff4b6od33a128560b58aec@mail.gmail.com>
	 <200804112251.09769.rjw@sisk.pl>
	 <86802c440804130124l2b0cb199x4d75f2df68f93fa4@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_24179_32618028.1208076118527
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Sun, Apr 13, 2008 at 1:24 AM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>
> On Fri, Apr 11, 2008 at 1:51 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>  >
>  > On Friday, 11 of April 2008, Yinghai Lu wrote:
>  >  > On Fri, Apr 11, 2008 at 12:26 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>  >  > > On Friday, 11 of April 2008, Rafael J. Wysocki wrote:
>  >  > >  > On Thursday, 10 of April 2008, Ingo Molnar wrote:
>  >  > >  > >
>  >  > >  > > * Ingo Molnar <mingo@elte.hu> wrote:
>  >  > >  > >
>  >  > >  > > > > > > First, the X server doesn't want to start (it says it couldn't
>  >  > >  > > > > > > mmap the framebuffer).
>  >  > >  > > > > >
>  >  > >  > > > > > could you send your .config?
>  >  > >  > > > >
>  >  > >  > > > > Attached.
>  >  > >  > > >
>  >  > >  > > > could you disable this option:
>  >  > >  > > >
>  >  > >  > > >  CONFIG_NONPROMISC_DEVMEM=y
>  >  > >  > > >
>  >  > >  > > > does it help with the X problem?
>  >  > >  >
>  >  > >  > That didn't help.
>  >  > >  >
>  >  > >  > > btw., Xorg works fine here on a comparable AMD system - but i use a
>  >  > >  > > rather new distro (Fedora 8) which has Xorg 7.2.
>  >  > >  >
>  >  > >  > My system is an OpenSUSE 10.3 and it has Xorg 7.2 as well.
>  >  > >  >
>  >  > >  > I think the problem is somehow related to the Radeon.
>  >  > >
>  >  > >  The bisection turned up commit ea1441bdf53692c3dc1fd2658addcf1205629661
>  >  > >  "x86: use bus conf in NB conf fun1 to get bus range on, on 64-bit"  as the one
>  >  > >  causing problems.
>  >  > >
>  >  > >  Unfortunately, I can't revert cleanly it, because there are two more commits
>  >  > >  depending on it in a highly nontrivial fashion, so I have reverted all three
>  >  > >  commits
>  >  > >
>  >  > >  a365998cd2cecfb827469dbd57c29602c106cb83
>  >  > >  44f7f90fbe7a3a99aab082f765346514b7b5c705
>  >  > >  ea1441bdf53692c3dc1fd2658addcf1205629661
>  >  > >
>  >  > >  and X starts again.  Also, suspend to RAM works from under X.
>  >  >
>  >  > please keep the three patches and applied the two attached debug patches.
>  >  >
>  >  > i wonder if there is some io allocation overlapping with your system.
>  >
>  >  Attached is a boot dmesg output from the current x86 git tree with your two
>  >  patches applied.
>  >
>  can you try to apply the patch i sent to you about agp bridge order
>  reading for buggy silicon?
>
>  Please boot kernel with "debug"...
>
>  I want to verify if you can get
>
>  "
>  Aperture conflicts with PCI mapping.
>  "
>
>  in your boot log...
>

then with this patch for io allocation overlapping...

YH

------=_Part_24179_32618028.1208076118527
Content-Type: text/x-patch; name=fix_peer_overlapping.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fezd925a0
Content-Disposition: attachment; filename=fix_peer_overlapping.patch

W1BBVENIXSB4ODZfNjQ6IHdvcmthcm91bmQgaW8gYWxsb2NhdGlvbiBvdmVybGFwcGluZyBmb3Ig
SFQgbGluawoKU2lnbmVkLW9mZi1ieTogWWluZ2hhaSBMdSA8eWhsdS5rZXJuZWxAZ21haWwuY29t
PgoKSW5kZXg6IGxpbnV4LTIuNi9hcmNoL3g4Ni9wY2kvazgtYnVzXzY0LmMKPT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQot
LS0gbGludXgtMi42Lm9yaWcvYXJjaC94ODYvcGNpL2s4LWJ1c182NC5jCisrKyBsaW51eC0yLjYv
YXJjaC94ODYvcGNpL2s4LWJ1c182NC5jCkBAIC0xMTEsMTcgKzExMSwyNSBAQCBzdGF0aWMgdm9p
ZCBfX2luaXQgdXBkYXRlX3JhbmdlKHN0cnVjdCByCiAJZm9yIChqID0gMDsgaiA8IFJBTkdFX05V
TTsgaisrKSB7CiAJCWlmICghcmFuZ2Vbal0uZW5kKQogCQkJY29udGludWU7Ci0JCWlmIChzdGFy
dCA9PSByYW5nZVtqXS5zdGFydCAmJiBlbmQgPCByYW5nZVtqXS5lbmQpIHsKLQkJCXJhbmdlW2pd
LnN0YXJ0ID0gZW5kICsgMTsKLQkJCWJyZWFrOwotCQl9IGVsc2UgaWYgKHN0YXJ0ID09IHJhbmdl
W2pdLnN0YXJ0ICYmIGVuZCA9PSByYW5nZVtqXS5lbmQpIHsKKworCQlpZiAoc3RhcnQgPD0gcmFu
Z2Vbal0uc3RhcnQgJiYgZW5kID49IHJhbmdlW2pdLmVuZCkgewogCQkJcmFuZ2Vbal0uc3RhcnQg
PSAwOwogCQkJcmFuZ2Vbal0uZW5kID0gMDsKLQkJCWJyZWFrOwotCQl9IGVsc2UgaWYgKHN0YXJ0
ID4gcmFuZ2Vbal0uc3RhcnQgJiYgZW5kID09IHJhbmdlW2pdLmVuZCkgeworCQkJY29udGludWU7
CisJCX0KKworCQlpZiAoc3RhcnQgPD0gcmFuZ2Vbal0uc3RhcnQgJiYgZW5kIDwgcmFuZ2Vbal0u
ZW5kICYmIHJhbmdlW2pdLnN0YXJ0IDwgZW5kICsgMSkgeworCQkJcmFuZ2Vbal0uc3RhcnQgPSBl
bmQgKyAxOworCQkJY29udGludWU7CisJCX0KKworCisJCWlmIChzdGFydCA+IHJhbmdlW2pdLnN0
YXJ0ICYmIGVuZCA+PSByYW5nZVtqXS5lbmQgJiYgcmFuZ2Vbal0uZW5kID4gc3RhcnQgLSAxKSB7
CiAJCQlyYW5nZVtqXS5lbmQgPSBzdGFydCAtIDE7Ci0JCQlicmVhazsKLQkJfSBlbHNlIGlmIChz
dGFydCA+IHJhbmdlW2pdLnN0YXJ0ICYmIGVuZCA8IHJhbmdlW2pdLmVuZCkgeworCQkJY29udGlu
dWU7CisJCX0KKworCQlpZiAoc3RhcnQgPiByYW5nZVtqXS5zdGFydCAmJiBlbmQgPCByYW5nZVtq
XS5lbmQpIHsKIAkJCS8qIGZpbmQgdGhlIG5ldyBzcGFyZSAqLwogCQkJZm9yIChpID0gMDsgaSA8
IFJBTkdFX05VTTsgaSsrKSB7CiAJCQkJaWYgKHJhbmdlW2ldLmVuZCA9PSAwKQpAQCAtMTM0LDcg
KzE0Miw3IEBAIHN0YXRpYyB2b2lkIF9faW5pdCB1cGRhdGVfcmFuZ2Uoc3RydWN0IHIKIAkJCQlw
cmludGsoS0VSTl9FUlIgInJ1biBvZiBzbG90IGluIHJhbmdlc1xuIik7CiAJCQl9CiAJCQlyYW5n
ZVtqXS5lbmQgPSBzdGFydCAtIDE7Ci0JCQlicmVhazsKKwkJCWNvbnRpbnVlOwogCQl9CiAJfQog
fQpAQCAtMTUwLDE2ICsxNTgsMjQgQEAgc3RhdGljIHZvaWQgX19pbml0IHVwZGF0ZV9yZXMoc3Ry
dWN0IHBjaQogCiAJLyogdHJ5IHRvIG1lcmdlIGl0IHdpdGggb2xkIG9uZSAqLwogCWZvciAoaSA9
IDA7IGkgPCBpbmZvLT5yZXNfbnVtOyBpKyspIHsKKwkJc2l6ZV90IGZpbmFsX3N0YXJ0LCBmaW5h
bF9lbmQ7CisJCXNpemVfdCBjb21tb25fc3RhcnQsIGNvbW1vbl9lbmQ7CisKIAkJcmVzID0gJmlu
Zm8tPnJlc1tpXTsKIAkJaWYgKHJlcy0+ZmxhZ3MgIT0gZmxhZ3MpCiAJCQljb250aW51ZTsKLQkJ
aWYgKHJlcy0+ZW5kICsgMSA9PSBzdGFydCkgewotCQkJcmVzLT5lbmQgPSBlbmQ7Ci0JCQlyZXR1
cm47Ci0JCX0gZWxzZSBpZiAoZW5kICsgMSA9PSByZXMtPnN0YXJ0KSB7Ci0JCQlyZXMtPnN0YXJ0
ID0gc3RhcnQ7Ci0JCQlyZXR1cm47Ci0JCX0KKworCQljb21tb25fc3RhcnQgPSBtYXgoKHNpemVf
dClyZXMtPnN0YXJ0LCBzdGFydCk7CisJCWNvbW1vbl9lbmQgPSBtaW4oKHNpemVfdClyZXMtPmVu
ZCwgZW5kKTsKKwkJaWYgKGNvbW1vbl9zdGFydCA+IGNvbW1vbl9lbmQgKyAxKQorCQkJY29udGlu
dWU7CisKKwkJZmluYWxfc3RhcnQgPSBtaW4oKHNpemVfdClyZXMtPnN0YXJ0LCBzdGFydCk7CisJ
CWZpbmFsX2VuZCA9IG1heCgoc2l6ZV90KXJlcy0+ZW5kLCBlbmQpOworCisJCXJlcy0+c3RhcnQg
PSBmaW5hbF9zdGFydDsKKwkJcmVzLT5lbmQgPSBmaW5hbF9lbmQ7CisJCXJldHVybjsKIAl9CiAK
IGFkZGl0OgpAQCAtMzM1LDcgKzM1MSwxMSBAQCBzdGF0aWMgaW50IF9faW5pdCBlYXJseV9maWxs
X21wX2J1c19pbmZvCiAJCWluZm8gPSAmcGNpX3Jvb3RfaW5mb1tqXTsKIAkJcHJpbnRrKEtFUk5f
REVCVUcgIm5vZGUgJWQgbGluayAlZDogaW8gcG9ydCBbJWxseCwgJWxseF1cbiIsCiAJCSAgICAg
ICBub2RlLCBsaW5rLCAodTY0KXN0YXJ0LCAodTY0KWVuZCk7Ci0JCXVwZGF0ZV9yZXMoaW5mbywg
c3RhcnQsIGVuZCwgSU9SRVNPVVJDRV9JTywgMCk7CisKKwkJLyoga2VybmVsIG9ubHkgaGFuZGxl
IDE2IGJpdCBvbmx5ICovCisJCWlmIChlbmQgPiAweGZmZmYpCisJCQllbmQgPSAweGZmZmY7CisJ
CXVwZGF0ZV9yZXMoaW5mbywgc3RhcnQsIGVuZCwgSU9SRVNPVVJDRV9JTywgMSk7CiAJCXVwZGF0
ZV9yYW5nZShyYW5nZSwgc3RhcnQsIGVuZCk7CiAJfQogCS8qIGFkZCBsZWZ0IG92ZXIgaW8gcG9y
dCByYW5nZSB0byBkZWYgbm9kZS9saW5rLCBbMCwgMHhmZmZmXSAqLwpAQCAtNDQzLDcgKzQ2Myw3
IEBAIHN0YXRpYyBpbnQgX19pbml0IGVhcmx5X2ZpbGxfbXBfYnVzX2luZm8KIAkJCX0KIAkJfQog
Ci0JCXVwZGF0ZV9yZXMoaW5mbywgc3RhcnQsIGVuZCwgSU9SRVNPVVJDRV9NRU0sIDApOworCQl1
cGRhdGVfcmVzKGluZm8sIHN0YXJ0LCBlbmQsIElPUkVTT1VSQ0VfTUVNLCAxKTsKIAkJdXBkYXRl
X3JhbmdlKHJhbmdlLCBzdGFydCwgZW5kKTsKIAkJcHJpbnRrKEtFUk5fQ09OVCAiXG4iKTsKIAl9
Cg==
------=_Part_24179_32618028.1208076118527--
