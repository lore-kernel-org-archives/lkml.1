Return-Path: <linux-kernel-owner+w=401wt.eu-S1760703AbZCaUpc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760703AbZCaUpc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 16:45:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755226AbZCaUpV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 16:45:21 -0400
Received: from rv-out-0506.google.com ([209.85.198.226]:60930 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475AbZCaUpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 16:45:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=PlbPPZVmTOdoq3uQTPqjT2ZgwNBv0mjwIsJhiQ6tnMdmwZ5QeK1VX5W7hj9VQDWKi+
         ipsDyWv5taCxdT5FVP8lM1CszqwxD01wZUPHddDh686kJI55Aw0bNvcPyql8uzDm0TkI
         PRsjDsCXAng2eHu3gLAcdLAzQXyrhHgVgQp/c=
MIME-Version: 1.0
In-Reply-To: <200903310944.32883.a.miskiewicz@gmail.com>
References: <200903302317.04515.a.miskiewicz@gmail.com>
	 <200903310125.12120.a.miskiewicz@gmail.com>
	 <20090331002100.GA10490@linux-os.sc.intel.com>
	 <200903310944.32883.a.miskiewicz@gmail.com>
Date: Tue, 31 Mar 2009 13:45:17 -0700
X-Google-Sender-Auth: 6d3cd9ce0e47aff9
Message-ID: <86802c440903311345h2f07977fr5a4b47fe652944b3@mail.gmail.com>
Subject: Re: 2.6.29 git master and PAT problems
From: Yinghai Lu <yinghai@kernel.org>
To: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=000e0cd14606d5e02404667046c7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--000e0cd14606d5e02404667046c7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 31, 2009 at 12:44 AM, Arkadiusz Miskiewicz
<a.miskiewicz@gmail.com> wrote:
> On Tuesday 31 of March 2009, Pallipadi, Venkatesh wrote:
>> On Mon, Mar 30, 2009 at 04:25:11PM -0700, Arkadiusz Miskiewicz wrote:
>> > On Tuesday 31 of March 2009, Arkadiusz Miskiewicz wrote:
>> > > On Monday 30 of March 2009, Pallipadi, Venkatesh wrote:
>> > >
>> > > More info follows. Now I've switched to
>> > > e1c502482853f84606928f5a2f2eb6da1993cda1 which contains latest drm
>> > > fixes and now I get much lower numbers of PAT errors but still.
>> >
>> > Also when I switch t400 into discrete mode (radeon hd 3400 instead
>> > of integrated intel GM45) I get such errors (probably unrelated
>> > to these seen when using intel):
>> >
>> > [ =A0419.187657] X:10550 conflicting memory types cfff0000-d0000000
>> > uncached<->uncached-minus [ =A0419.187670] reserve_memtype failed
>> > 0xcfff0000-0xd0000000, track uncached, req write-back [ =A0419.553914]
>> > X:10550 conflicting memory types cfff0000-d0000000
>> > uncached<->uncached-minus [ =A0419.553923] reserve_memtype failed
>> > 0xcfff0000-0xd0000000, track uncached, req write-back [ =A0419.813592]
>> > X:10550 conflicting memory types cfff0000-d0000000
>> > uncached<->uncached-minus [ =A0419.813601] reserve_memtype failed
>> > 0xcfff0000-0xd0000000, track uncached, req write-back [ =A0420.100102]
>> > X:10550 conflicting memory types cfff0000-d0000000
>> > uncached<->uncached-minus [ =A0420.100111] reserve_memtype failed
>> > 0xcfff0000-0xd0000000, track uncached, req write-back
>>
>> Yes. This is a different problem than the freeing invalid type one. Are
>> these errors also with latest git kernel? Can you try the patch below
>> (which is a part of a bigger cleanup patch I have lined up).
>
> It's a latest git kernel as of today morning
> (latest commit is 15f7176eb1cccec0a332541285ee752b935c1c85)
> + your patch. Problem persists:
>
> [ =A0 74.696353] [drm] Setting GART location based on new memory map
> [ =A0 74.711520] [drm] Loading RV620 CP Microcode
> [ =A0 74.711792] [drm] Loading RV620 PFP Microcode
> [ =A0 74.726719] [drm] Resetting GPU
> [ =A0 74.726776] [drm] writeback test succeeded in 1 usecs
> [ =A0 75.256034] X:5366 conflicting memory types d0000000-e0000000 uncach=
ed-minus<->write-combining
> [ =A0 75.256043] reserve_memtype failed 0xd0000000-0xe0000000, track unca=
ched-minus, req write-back
> [ =A0 75.849951] X:5366 conflicting memory types d0000000-e0000000 uncach=
ed-minus<->write-combining
> [ =A0 75.849960] reserve_memtype failed 0xd0000000-0xe0000000, track unca=
ched-minus, req write-back
> [ =A0 76.054374] X:5366 conflicting memory types d0000000-e0000000 uncach=
ed-minus<->write-combining
> [ =A0 76.054377] reserve_memtype failed 0xd0000000-0xe0000000, track unca=
ched-minus, req write-back
> [ =A0 76.074481] X:5378 freeing invalid memtype d0000000-e0000000
> [ =A0 76.176881] X:5366 conflicting memory types d0000000-e0000000 uncach=
ed-minus<->write-combining
> [ =A0 76.176885] reserve_memtype failed 0xd0000000-0xe0000000, track unca=
ched-minus, req write-back
> [ =A0 76.207734] X:5380 freeing invalid memtype d0000000-e0000000
>
> cat /debug/x86/pat_memtype_list
> PAT memtype list:
> uncached-minus @ 0xbfad1000-0xbfad2000
> uncached-minus @ 0xbfad2000-0xbfad3000
> uncached-minus @ 0xbfad3000-0xbfad4000
> uncached-minus @ 0xbfb06000-0xbfb07000
> uncached-minus @ 0xbfb07000-0xbfb08000
> uncached-minus @ 0xbfd6a000-0xbfd6b000
> uncached-minus @ 0xbfd6a000-0xbfd6b000
> uncached-minus @ 0xbfd6a000-0xbfd7a000
> uncached-minus @ 0xbfd79000-0xbfd7a000
> uncached-minus @ 0xbfd79000-0xbfd7a000
> uncached-minus @ 0xbfd79000-0xbfd7a000
> uncached-minus @ 0xbfd79000-0xbfd7a000
> uncached-minus @ 0xbfd79000-0xbfd7a000
> uncached-minus @ 0xbfd79000-0xbfd7a000
> uncached-minus @ 0xbfd79000-0xbfd7a000
> uncached-minus @ 0xbfd7b000-0xbfd7c000
> uncached-minus @ 0xbfd8d000-0xbfd8e000
> uncached-minus @ 0xbfd8e000-0xbfd8f000
> uncached-minus @ 0xbfd8e000-0xbfd8f000
> uncached-minus @ 0xcfff0000-0xd0000000
> uncached-minus @ 0xcfff0000-0xd0000000
> uncached-minus @ 0xcfff0000-0xd0000000
> uncached-minus @ 0xcfff0000-0xd0000000
> uncached-minus @ 0xcfff0000-0xd0000000
> write-combining @ 0xdfff0000-0xe0000000
> uncached-minus @ 0xe0000000-0xe4000000
> uncached-minus @ 0xf4200000-0xf4202000
> uncached-minus @ 0xf4300000-0xf4301000
> uncached-minus @ 0xf4301000-0xf4302000
> uncached-minus @ 0xf4301000-0xf4302000
> uncached-minus @ 0xfc200000-0xfc220000
> uncached-minus @ 0xfc220000-0xfc224000
> uncached-minus @ 0xfc225000-0xfc226000
> uncached-minus @ 0xfc226000-0xfc227000
> uncached-minus @ 0xfc226000-0xfc227000
> uncached-minus @ 0xfc227000-0xfc228000
> uncached-minus @ 0xfed00000-0xfed01000
> uncached-minus @ 0xfed1f000-0xfed20000
> cat /proc/mtrr
> reg00: base=3D0x13c000000 ( 5056MB), size=3D =A0 64MB, count=3D1: uncacha=
ble
> reg01: base=3D0x000000000 ( =A0 =A00MB), size=3D 2048MB, count=3D1: write=
-back
> reg02: base=3D0x080000000 ( 2048MB), size=3D 1024MB, count=3D1: write-bac=
k
> reg03: base=3D0x100000000 ( 4096MB), size=3D 1024MB, count=3D1: write-bac=
k
> reg04: base=3D0x0d0000000 ( 3328MB), size=3D =A0256MB, count=3D1: write-c=
ombining
>

please try on attached patch on top on tip/master

http://people.redhat.com/mingo/tip.git/readme.txt

YH

--000e0cd14606d5e02404667046c7
Content-Type: text/x-patch; charset=US-ASCII; name="pat_fix.patch"
Content-Disposition: attachment; filename="pat_fix.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fsz1zauh0

LS0tCiBhcmNoL3g4Ni9tbS9wYXQuYyB8ICAgMzUgKysrKysrKysrKysrKysrLS0tLS0tLS0tLS0t
LS0tLS0tLS0KIDEgZmlsZSBjaGFuZ2VkLCAxNSBpbnNlcnRpb25zKCspLCAyMCBkZWxldGlvbnMo
LSkKCkluZGV4OiBsaW51eC0yLjYvYXJjaC94ODYvbW0vcGF0LmMKPT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQotLS0gbGlu
dXgtMi42Lm9yaWcvYXJjaC94ODYvbW0vcGF0LmMKKysrIGxpbnV4LTIuNi9hcmNoL3g4Ni9tbS9w
YXQuYwpAQCAtMzEsNyArMzEsNyBAQAogI2lmZGVmIENPTkZJR19YODZfUEFUCiBpbnQgX19yZWFk
X21vc3RseSBwYXRfZW5hYmxlZCA9IDE7CiAKLXZvaWQgX19jcHVpbml0IHBhdF9kaXNhYmxlKGNv
bnN0IGNoYXIgKnJlYXNvbikKK3N0YXRpYyB2b2lkIF9fY3B1aW5pdCBwYXRfZGlzYWJsZShjb25z
dCBjaGFyICpyZWFzb24pCiB7CiAJcGF0X2VuYWJsZWQgPSAwOwogCXByaW50ayhLRVJOX0lORk8g
IiVzXG4iLCByZWFzb24pOwpAQCAtMTc2LDkgKzE3Niw5IEBAIHN0YXRpYyB1bnNpZ25lZCBsb25n
IHBhdF94X210cnJfdHlwZSh1NjQKIHsKIAkvKgogCSAqIExvb2sgZm9yIE1UUlIgaGludCB0byBn
ZXQgdGhlIGVmZmVjdGl2ZSB0eXBlIGluIGNhc2Ugd2hlcmUgUEFUCi0JICogcmVxdWVzdCBpcyBm
b3IgV0IuCisJICogcmVxdWVzdCBpcyBmb3IgV0Igb3IgV0MuCiAJICovCi0JaWYgKHJlcV90eXBl
ID09IF9QQUdFX0NBQ0hFX1dCKSB7CisJaWYgKHJlcV90eXBlID09IF9QQUdFX0NBQ0hFX1dCIHx8
IHJlcV90eXBlID09IF9QQUdFX0NBQ0hFX1dDKSB7CiAJCXU4IG10cnJfdHlwZTsKIAogCQltdHJy
X3R5cGUgPSBtdHJyX3R5cGVfbG9va3VwKHN0YXJ0LCBlbmQpOwpAQCAtMTkxLDEwICsxOTEsMTUg
QEAgc3RhdGljIHVuc2lnbmVkIGxvbmcgcGF0X3hfbXRycl90eXBlKHU2NAogCXJldHVybiByZXFf
dHlwZTsKIH0KIAorc3RhdGljIHVuc2lnbmVkIGxvbmcgcmVhbF90eXBlKHN0cnVjdCBtZW10eXBl
ICplbnRyeSkKK3sKKwlyZXR1cm4gcGF0X3hfbXRycl90eXBlKGVudHJ5LT5zdGFydCwgZW50cnkt
PmVuZCwgZW50cnktPnR5cGUpOworfQorCiBzdGF0aWMgaW50CiBjaGtfY29uZmxpY3Qoc3RydWN0
IG1lbXR5cGUgKm5ldywgc3RydWN0IG1lbXR5cGUgKmVudHJ5LCB1bnNpZ25lZCBsb25nICp0eXBl
KQogewotCWlmIChuZXctPnR5cGUgIT0gZW50cnktPnR5cGUpIHsKKwlpZiAocmVhbF90eXBlKG5l
dykgIT0gcmVhbF90eXBlKGVudHJ5KSkgewogCQlpZiAodHlwZSkgewogCQkJbmV3LT50eXBlID0g
ZW50cnktPnR5cGU7CiAJCQkqdHlwZSA9IGVudHJ5LT50eXBlOwpAQCAtMjA2LDE1ICsyMTEsMTYg
QEAgY2hrX2NvbmZsaWN0KHN0cnVjdCBtZW10eXBlICpuZXcsIHN0cnVjdAogCWxpc3RfZm9yX2Vh
Y2hfZW50cnlfY29udGludWUoZW50cnksICZtZW10eXBlX2xpc3QsIG5kKSB7CiAJCWlmIChuZXct
PmVuZCA8PSBlbnRyeS0+c3RhcnQpCiAJCQlicmVhazsKLQkJZWxzZSBpZiAobmV3LT50eXBlICE9
IGVudHJ5LT50eXBlKQorCQllbHNlIGlmIChyZWFsX3R5cGUobmV3KSAhPSByZWFsX3R5cGUoZW50
cnkpKQogCQkJZ290byBjb25mbGljdDsKIAl9CiAJcmV0dXJuIDA7CiAKICBjb25mbGljdDoKIAlw
cmludGsoS0VSTl9JTkZPICIlczolZCBjb25mbGljdGluZyBtZW1vcnkgdHlwZXMgIgotCSAgICAg
ICAiJUx4LSVMeCAlczwtPiVzXG4iLCBjdXJyZW50LT5jb21tLCBjdXJyZW50LT5waWQsIG5ldy0+
c3RhcnQsCi0JICAgICAgIG5ldy0+ZW5kLCBjYXR0cl9uYW1lKG5ldy0+dHlwZSksIGNhdHRyX25h
bWUoZW50cnktPnR5cGUpKTsKKwkgICAgICAgIiVMeC0lTHggJXMgPC0+ICVMeC0lTHglc1xuIiwg
Y3VycmVudC0+Y29tbSwgY3VycmVudC0+cGlkLAorCSAgICAgICBuZXctPnN0YXJ0LCBuZXctPmVu
ZCwgY2F0dHJfbmFtZShuZXctPnR5cGUpLAorCSAgICAgICBlbnRyeS0+c3RhcnQsIGVudHJ5LT5l
bmQsIGNhdHRyX25hbWUoZW50cnktPnR5cGUpKTsKIAlyZXR1cm4gLUVCVVNZOwogfQogCkBAIC0z
NTMsMTggKzM1OSw3IEBAIGludCByZXNlcnZlX21lbXR5cGUodTY0IHN0YXJ0LCB1NjQgZW5kLAog
CX0KIAogCWlmIChyZXFfdHlwZSA9PSAtMSkgewotCQkvKgotCQkgKiBDYWxsIG10cnJfbG9va3Vw
IHRvIGdldCB0aGUgdHlwZSBoaW50LiBUaGlzIGlzIGFuCi0JCSAqIG9wdGltaXphdGlvbiBmb3Ig
L2Rldi9tZW0gbW1hcCdlcnMgaW50byBXQiBtZW1vcnkgKEJJT1MKLQkJICogdG9vbHMgYW5kIEFD
UEkgdG9vbHMpLiBVc2UgV0IgcmVxdWVzdCBmb3IgV0IgbWVtb3J5IGFuZCB1c2UKLQkJICogVUNf
TUlOVVMgb3RoZXJ3aXNlLgotCQkgKi8KLQkJdTggbXRycl90eXBlID0gbXRycl90eXBlX2xvb2t1
cChzdGFydCwgZW5kKTsKLQotCQlpZiAobXRycl90eXBlID09IE1UUlJfVFlQRV9XUkJBQ0spCi0J
CQlhY3R1YWxfdHlwZSA9IF9QQUdFX0NBQ0hFX1dCOwotCQllbHNlCi0JCQlhY3R1YWxfdHlwZSA9
IF9QQUdFX0NBQ0hFX1VDX01JTlVTOworCQlhY3R1YWxfdHlwZSA9IHBhdF94X210cnJfdHlwZShz
dGFydCwgZW5kLCBfUEFHRV9DQUNIRV9XQik7CiAJfSBlbHNlIHsKIAkJYWN0dWFsX3R5cGUgPSBw
YXRfeF9tdHJyX3R5cGUoc3RhcnQsIGVuZCwKIAkJCQkJICAgICAgcmVxX3R5cGUgJiBfUEFHRV9D
QUNIRV9NQVNLKTsKQEAgLTM4Niw3ICszODEsNyBAQCBpbnQgcmVzZXJ2ZV9tZW10eXBlKHU2NCBz
dGFydCwgdTY0IGVuZCwKIAogCW5ldy0+c3RhcnQJPSBzdGFydDsKIAluZXctPmVuZAk9IGVuZDsK
LQluZXctPnR5cGUJPSBhY3R1YWxfdHlwZTsKKwluZXctPnR5cGUJPSByZXFfdHlwZSAmIF9QQUdF
X0NBQ0hFX01BU0s7CiAKIAlzcGluX2xvY2soJm1lbXR5cGVfbG9jayk7CiAK
--000e0cd14606d5e02404667046c7--
