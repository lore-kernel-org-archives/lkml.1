Return-Path: <linux-kernel-owner+w=401wt.eu-S1753388AbYDMSHl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388AbYDMSHl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 14:07:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751927AbYDMSHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 14:07:33 -0400
Received: from rv-out-0708.google.com ([209.85.198.246]:33435 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751816AbYDMSHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 14:07:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:references;
        b=Cildw5Fq+jLEZu8TaKVDlSSQumbx4EX2IZudO2a1xH8n3P9nGrHtYA+vas4+L8QrsPzeG0DfJdLSFU9XAmZP0vQYy8KhEqA2InM0CUQfB6PGmhbN8zqEiZ9BkHzGTk0EGKiIcdCkLgFG0RWXggUkPQOtrlgin1b7Q8bvfDU7JLQ=
Message-ID: <86802c440804131107s7c132bc6j10ba713e50589353@mail.gmail.com>
Date: Sun, 13 Apr 2008 11:07:31 -0700
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
	boundary="----=_Part_25044_22156647.1208110051947"
References: <200804102159.14563.rjw@sisk.pl> <200804112251.09769.rjw@sisk.pl>
	 <86802c440804130124l2b0cb199x4d75f2df68f93fa4@mail.gmail.com>
	 <200804131812.55684.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_25044_22156647.1208110051947
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Sun, Apr 13, 2008 at 9:12 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>
> On Sunday, 13 of April 2008, Yinghai Lu wrote:
>  > On Fri, Apr 11, 2008 at 1:51 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>  > >
>  > > On Friday, 11 of April 2008, Yinghai Lu wrote:
>  > >  > On Fri, Apr 11, 2008 at 12:26 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>  > >  > > On Friday, 11 of April 2008, Rafael J. Wysocki wrote:
>  > >  > >  > On Thursday, 10 of April 2008, Ingo Molnar wrote:
>  > >  > >  > >
>  > >  > >  > > * Ingo Molnar <mingo@elte.hu> wrote:
>  > >  > >  > >
>  > >  > >  > > > > > > First, the X server doesn't want to start (it says it couldn't
>  > >  > >  > > > > > > mmap the framebuffer).
>  > >  > >  > > > > >
>  > >  > >  > > > > > could you send your .config?
>  > >  > >  > > > >
>  > >  > >  > > > > Attached.
>  > >  > >  > > >
>  > >  > >  > > > could you disable this option:
>  > >  > >  > > >
>  > >  > >  > > >  CONFIG_NONPROMISC_DEVMEM=y
>  > >  > >  > > >
>  > >  > >  > > > does it help with the X problem?
>  > >  > >  >
>  > >  > >  > That didn't help.
>  > >  > >  >
>  > >  > >  > > btw., Xorg works fine here on a comparable AMD system - but i use a
>  > >  > >  > > rather new distro (Fedora 8) which has Xorg 7.2.
>  > >  > >  >
>  > >  > >  > My system is an OpenSUSE 10.3 and it has Xorg 7.2 as well.
>  > >  > >  >
>  > >  > >  > I think the problem is somehow related to the Radeon.
>  > >  > >
>  > >  > >  The bisection turned up commit ea1441bdf53692c3dc1fd2658addcf1205629661
>  > >  > >  "x86: use bus conf in NB conf fun1 to get bus range on, on 64-bit"  as the one
>  > >  > >  causing problems.
>  > >  > >
>  > >  > >  Unfortunately, I can't revert cleanly it, because there are two more commits
>  > >  > >  depending on it in a highly nontrivial fashion, so I have reverted all three
>  > >  > >  commits
>  > >  > >
>  > >  > >  a365998cd2cecfb827469dbd57c29602c106cb83
>  > >  > >  44f7f90fbe7a3a99aab082f765346514b7b5c705
>  > >  > >  ea1441bdf53692c3dc1fd2658addcf1205629661
>  > >  > >
>  > >  > >  and X starts again.  Also, suspend to RAM works from under X.
>  > >  >
>  > >  > please keep the three patches and applied the two attached debug patches.
>  > >  >
>  > >  > i wonder if there is some io allocation overlapping with your system.
>  > >
>  > >  Attached is a boot dmesg output from the current x86 git tree with your two
>  > >  patches applied.
>  > >
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

did you apply the patch like the attached that i sent you in another mail?

YH

------=_Part_25044_22156647.1208110051947
Content-Type: text/x-patch; name=fix_buggy_agp_order.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fezxh0wl1
Content-Disposition: attachment; filename=fix_buggy_agp_order.patch

e1BBVENIXSB4ODZfNjQ6IGFncF9nYXJ0IHNpemUgY2hlY2tpbmcgZm9yIGJ1Z2d5IGRldmljZQoK
CndoaWxlIGxvb2tpbiBSYWZhZWwgSi4gV3lzb2NraSA8cmp3QHNpc2sucGw+IHN5c3RlbSBib290
IGxvZywKCmZpbmQgc29tZSBmdW5ueSBwcmludCBvdXQKCglOb2RlIDA6IGFwZXJ0dXJlIEAgZGUw
MDAwMDAgc2l6ZSAzMiBNQgoJQXBlcnR1cmUgdG9vIHNtYWxsICgzMiBNQikKCUFHUCBicmlkZ2Ug
YXQgMDA6MDQ6MDAKCUFwZXJ0dXJlIGZyb20gQUdQIEAgZGUwMDAwMDAgc2l6ZSA0MDk2IE1CIChB
UFNJWkUgMCkKCUFwZXJ0dXJlIHRvbyBzbWFsbCAoMCBNQikKCVlvdXIgQklPUyBkb2Vzbid0IGxl
YXZlIGEgYXBlcnR1cmUgbWVtb3J5IGhvbGUKCVBsZWFzZSBlbmFibGUgdGhlIElPTU1VIG9wdGlv
biBpbiB0aGUgQklPUyBzZXR1cAoJVGhpcyBjb3N0cyB5b3UgNjQgTUIgb2YgUkFNCglNYXBwaW5n
IGFwZXJ0dXJlIG92ZXIgNjU1MzYgS0Igb2YgUkFNIEAgNDAwMDAwMAoKCS4uLgoKCWFncGdhcnQ6
IERldGVjdGVkIEFHUCBicmlkZ2UgMjAKCWFncGdhcnQ6IEFwZXJ0dXJlIHBvaW50aW5nIHRvIFJB
TQoJYWdwZ2FydDogQXBlcnR1cmUgZnJvbSBBR1AgQCBkZTAwMDAwMCBzaXplIDQwOTYgTUIKCWFn
cGdhcnQ6IEFwZXJ0dXJlIHRvbyBzbWFsbCAoMCBNQikKCWFncGdhcnQ6IE5vIHVzYWJsZSBhcGVy
dHVyZSBmb3VuZC4KCWFncGdhcnQ6IENvbnNpZGVyIHJlYm9vdGluZyB3aXRoIGlvbW11PW1lbWFw
ZXI9MiB0byBnZXQgYSBnb29kIGFwZXJ0dXJlLgoKCml0IG1lYW4gQklPUyBhbGxvY2F0ZSBjb3Jy
ZWN0IGdhcnQgb24gTkIgYW5kIEFHUCBicmlkZ2UgYnV0IGJlY2F1c2Ugb25lIGJ1ZyBpbiBzaWxp
Y29uCiggdGhlIGFncCBicmlkZ2UgcmVwb3J0IHdyb25nIG9yZGVyLCBpdCB3YW50IDRHKQp0aGUg
a2VybmVsIHdpbGwgcmVqZWN0IHRoYXQgYWxsY2F0aW9uLCBiZWNhc2UgdGhlIHNpemUgaXMgb25s
eSAzMk0uIGFuZCB0cnkgdG8gZ2V0IGFub3RoZXIKNjRNIGZvciBnYXJ0LCBhbmQgbGF0ZSBmaXhf
bm9ydGhicmlkZ2UgY2FuIG5vdCByZXZlcnQgdGhhdCBjaGFuZ2UgYmVjYXVzZSBpdCBzdGlsbCBy
ZWFkCndyb25nIHNpemUgZnJvbSBhZ3AgYnJpZGdlLgoKU28gdHJ5IHRvIGRvdWJsZSBjaGVjayBv
cmRlciBmcm9tIGFncCBicmlkZ2UsIGJlZm9yZSBjYWxsaW5nIGFwZXJ0dXJlX3ZhbGlkKCkuCgpT
aWduZWQtb2ZmLWJ5OiBZaW5naGFpIEx1IDx5aGx1Lmtlcm5lbEBnbWFpbC5jb20+CgpkaWZmIC0t
Z2l0IGEvYXJjaC94ODYva2VybmVsL2FwZXJ0dXJlXzY0LmMgYi9hcmNoL3g4Ni9rZXJuZWwvYXBl
cnR1cmVfNjQuYwppbmRleCA0Nzk5MjZkLi45Zjg2Nzc4IDEwMDY0NAotLS0gYS9hcmNoL3g4Ni9r
ZXJuZWwvYXBlcnR1cmVfNjQuYworKysgYi9hcmNoL3g4Ni9rZXJuZWwvYXBlcnR1cmVfNjQuYwpA
QCAtMTM4LDYgKzEzOCw3IEBAIHN0YXRpYyBfX3UzMiBfX2luaXQgcmVhZF9hZ3AoaW50IG51bSwg
aW50IHNsb3QsIGludCBmdW5jLCBpbnQgY2FwLCB1MzIgKm9yZGVyKQogCWludCBuYml0czsKIAl1
MzIgYXBlcl9sb3csIGFwZXJfaGk7CiAJdTY0IGFwZXI7CisJdTMyIG9sZF9vcmRlcjsKIAogCXBy
aW50ayhLRVJOX0lORk8gIkFHUCBicmlkZ2UgYXQgJTAyeDolMDJ4OiUwMnhcbiIsIG51bSwgc2xv
dCwgZnVuYyk7CiAJYXBzaXplcmVnID0gcmVhZF9wY2lfY29uZmlnXzE2KG51bSwgc2xvdCwgZnVu
YywgY2FwICsgMHgxNCk7CkBAIC0xNDYsNiArMTQ3LDkgQEAgc3RhdGljIF9fdTMyIF9faW5pdCBy
ZWFkX2FncChpbnQgbnVtLCBpbnQgc2xvdCwgaW50IGZ1bmMsIGludCBjYXAsIHUzMiAqb3JkZXIp
CiAJCXJldHVybiAwOwogCX0KIAorCS8qIG9sZF9vcmRlciBjb3VsZCBiZSB0aGUgdmFsdWUgZnJv
bSBOQiBnYXJ0IHNldHRpbmcgKi8KKwlvbGRfb3JkZXIgPSAqb3JkZXI7CisKIAlhcHNpemUgPSBh
cHNpemVyZWcgJiAweGZmZjsKIAkvKiBTb21lIEJJT1MgdXNlIHdlaXJkIGVuY29kaW5ncyBub3Qg
aW4gdGhlIEFHUHYzIHRhYmxlLiAqLwogCWlmIChhcHNpemUgJiAweGZmKQpAQCAtMTU5LDYgKzE2
MywxNiBAQCBzdGF0aWMgX191MzIgX19pbml0IHJlYWRfYWdwKGludCBudW0sIGludCBzbG90LCBp
bnQgZnVuYywgaW50IGNhcCwgdTMyICpvcmRlcikKIAlhcGVyX2hpID0gcmVhZF9wY2lfY29uZmln
KG51bSwgc2xvdCwgZnVuYywgMHgxNCk7CiAJYXBlciA9IChhcGVyX2xvdyAmIH4oKDE8PDIyKS0x
KSkgfCAoKHU2NClhcGVyX2hpIDw8IDMyKTsKIAorCS8qCisJICogc29tZSBzaWNrIGNoaXAsIEFQ
U0laRSBpcyAwLCBpdCBtZWFuIGl0IHdhbnRzIDRHCisJICogc28gbGV0IGRvdWJsZSBjaGVjayB0
aGF0IG9yZGVyLCBsZXQgdHJ1c3QgQU1EIE5CIHNldHRpbmcKKwkgKi8KKwlpZiAoYXBlciArICgz
MlVMPDwoMjAgKyAqb3JkZXIpKSA+IDB4MTAwMDAwMDAwVUwpIHsKKwkJcHJpbnRrKEtFUk5fSU5G
TyAiQXBlcnR1cmUgc2l6ZSAldSBNQiAoQVBTSVpFICV4KSBpcyBub3QgcmlnaHQsIHVzZSBzZXR0
aW5nIGZyb20gTkJcbiIsCisJCQkJMzIgPDwgKm9yZGVyLCBhcHNpemVyZWcpOworCQkqb3JkZXIg
PSBvbGRfb3JkZXI7CisJfQorCiAJcHJpbnRrKEtFUk5fSU5GTyAiQXBlcnR1cmUgZnJvbSBBR1Ag
QCAlTHggc2l6ZSAldSBNQiAoQVBTSVpFICV4KVxuIiwKIAkJCWFwZXIsIDMyIDw8ICpvcmRlciwg
YXBzaXplcmVnKTsKIApkaWZmIC0tZ2l0IGEvZHJpdmVycy9jaGFyL2FncC9hbWQ2NC1hZ3AuYyBi
L2RyaXZlcnMvY2hhci9hZ3AvYW1kNjQtYWdwLmMKaW5kZXggOWQ4MjA0NS4uMjg4ZDFmNSAxMDA2
NDQKLS0tIGEvZHJpdmVycy9jaGFyL2FncC9hbWQ2NC1hZ3AuYworKysgYi9kcml2ZXJzL2NoYXIv
YWdwL2FtZDY0LWFncC5jCkBAIC0zMTIsNiArMzEyLDE3IEBAIHN0YXRpYyBfX2RldmluaXQgaW50
IGZpeF9ub3J0aGJyaWRnZShzdHJ1Y3QgcGNpX2RldiAqbmIsIHN0cnVjdCBwY2lfZGV2ICphZ3As
CiAJcGNpX3JlYWRfY29uZmlnX2R3b3JkKGFncCwgMHgxMCwgJmFwZXJfbG93KTsKIAlwY2lfcmVh
ZF9jb25maWdfZHdvcmQoYWdwLCAweDE0LCAmYXBlcl9oaSk7CiAJYXBlciA9IChhcGVyX2xvdyAm
IH4oKDE8PDIyKS0xKSkgfCAoKHU2NClhcGVyX2hpIDw8IDMyKTsKKworICAgICAgICAvKgorICAg
ICAgICAgKiBzb21lIHNpY2sgY2hpcCwgQVBTSVpFIGlzIDAsIGl0IG1lYW4gaXQgd2FudHMgNEcK
KyAgICAgICAgICogc28gbGV0IGRvdWJsZSBjaGVjayB0aGF0IG9yZGVyLCBsZXQgdHJ1c3QgQU1E
IE5CIHNldHRpbmcKKyAgICAgICAgICovCisgICAgICAgIGlmIChhcGVyICsgKDMyVUw8PCgyMCAr
IG9yZGVyKSkgPiAweDEwMDAwMDAwMFVMKSB7CisgICAgICAgICAgICAgICAgcHJpbnRrKEtFUk5f
SU5GTyAiQXBlcnR1cmUgc2l6ZSAldSBNQiBpcyBub3QgcmlnaHQsIHVzZSBzZXR0aW5nIGZyb20g
TkJcbiIsCisgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIDMyIDw8IG9yZGVyKTsKKyAg
ICAgICAgICAgICAgICBvcmRlciA9IG5iX29yZGVyOworICAgICAgICB9CisKIAlwcmludGsoS0VS
Tl9JTkZPIFBGWCAiQXBlcnR1cmUgZnJvbSBBR1AgQCAlTHggc2l6ZSAldSBNQlxuIiwgYXBlciwg
MzIgPDwgb3JkZXIpOwogCWlmIChvcmRlciA8IDAgfHwgIWFwZXJ0dXJlX3ZhbGlkKGFwZXIsICgz
MioxMDI0KjEwMjQpPDxvcmRlcikpCiAJCXJldHVybiAtMTsK
------=_Part_25044_22156647.1208110051947--
