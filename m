Return-Path: <linux-kernel-owner+w=401wt.eu-S1758153AbYD2Cl6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758153AbYD2Cl6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 22:41:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753910AbYD2Clr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 22:41:47 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:1349 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753735AbYD2Clp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 22:41:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:references;
        b=Jtu723JPXZSJEA5MAPctco2ny9XAx2JZHJjcIT+0orzPHb/w65GbHUGIivL7B1IwHkAmVz3ZYYJ58s+s3kFc65Jg+/BBEc8eHby9cXrbt1PSHcqFtjNiaT0F9TZbHWfOymZsBJsgv2DXmilr35fqCZgNQiLnocL9ZQORjfnWbwk=
Message-ID: <86802c440804281941h440c7a86kd86fd4d9dcf91ad4@mail.gmail.com>
Date: Mon, 28 Apr 2008 19:41:43 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Gabriel C" <nix.or.die@googlemail.com>
Subject: Re: [PATCH] x86_32: trim memory by updating e820 v3
Cc: "Mika Fischer" <mika.fischer@zoopnet.de>, "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       "Jesse Barnes" <jesse.barnes@intel.com>, balajirrao@gmail.com,
       "Andi Kleen" <andi@firstfloor.org>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <48167473.80207@googlemail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_6922_4353305.1209436903512"
References: <200801192045.17291.yinghai.lu@sun.com>
	 <4815DE0C.6000802@googlemail.com>
	 <86802c440804281206u6b5086a3h42192b7d36b08325@mail.gmail.com>
	 <481627B7.9060406@googlemail.com> <4816376B.8060907@googlemail.com>
	 <48163F56.70704@googlemail.com>
	 <86802c440804281503q1f9e6f8anb18cd514e89b76fe@mail.gmail.com>
	 <4816562B.2070905@googlemail.com>
	 <86802c440804281623m28a5cf5x701580d0f007c097@mail.gmail.com>
	 <48167473.80207@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_6922_4353305.1209436903512
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Mon, Apr 28, 2008 at 6:05 PM, Gabriel C <nix.or.die@googlemail.com> wrote:
>
> Yinghai Lu wrote:
>  > On Mon, Apr 28, 2008 at 3:56 PM, Gabriel C <nix.or.die@googlemail.com> wrote:
>  >> Yinghai Lu wrote:
>  >>  > On Mon, Apr 28, 2008 at 2:19 PM, Gabriel C <nix.or.die@googlemail.com> wrote:
>  >>  >> Gabriel C wrote:
>  >>  >>  > Gabriel C wrote:
>  >>  >>  >> Yinghai Lu wrote:
>  >>  >>  >>> On Mon, Apr 28, 2008 at 7:24 AM, Gabriel C <nix.or.die@googlemail.com> wrote:
>  >>  >>  >>>> Mika Fischer wrote:
>  >>  >>  >>>>  > Hi Ingo,
>  >>  >>  >>>>  >
>  >>  >>  >>>>  > I'm having the same problem.
>  >>  >>  >>>>  >
>  >>  >>  >>>>  > Ingo Molnar schrieb:
>  >>  >>  >>>>  >> excellent. So just to make sure: this box never had proper graphics
>  >>  >>  >>>>  >> under Linux (under no previous kernel), due to the way the BIOS has set
>  >>  >>  >>>>  >> up the MTRR's, right?
>  >>  >>  >>>>  >
>  >>  >>  >>>>  > Well, not quite. X still works fine, but since the video memory is
>  >>  >>  >>>>  > overlapped by two of the existing MTRRs, X cannot add a write-combining
>  >>  >>  >>>>  > range for the video memory. That makes X rather slow especially if you
>  >>  >>  >>>>  > use DRI for Compiz etc.
>  >>  >>  >>>>
>  >>  >>  >>>>  Well you are lucky then :)
>  >>  >>  >>>>
>  >>  >>  >>>>  Yeah X 'worked' but it worked as slow as with vesa video driver here.
>  >>  >>  >>> [    0.000000] rangeX: 0000000000000000 - 00000000d0000000
>  >>  >>  >>> [    0.000000] Setting variable MTRR 0, base: 0MB, range: 2048MB, type WB
>  >>  >>  >>> [    0.000000] Setting variable MTRR 1, base: 2048MB, range: 1024MB, type WB
>  >>  >>  >>> [    0.000000] Setting variable MTRR 2, base: 3072MB, range: 256MB, type WB
>  >>  >>  >>> [    0.000000] range0: 00000000cf800000 - 00000000cf800000
>  >>  >>  >>> [    0.000000] range: 00000000cf800000 - 00000000d0000000
>  >>  >>  >>> [    0.000000] Setting variable MTRR 3, base: 3320MB, range: 8MB, type WB
>  >>  >>  >>> [    0.000000] range0: 0000000100000000 - 0000000120000000
>  >>  >>  >>> [    0.000000] Setting variable MTRR 4, base: 4096MB, range: 512MB, type WB
>  >>  >>  >>> [    0.000000] range: 0000000120000000 - 0000000130000000
>  >>  >>  >>> [    0.000000] Setting variable MTRR 5, base: 4608MB, range: 256MB, type WB
>  >>  >>  >>> [    0.000000] hole: 000000012c000000 - 0000000130000000
>  >>  >>  >>> [    0.000000] Setting variable MTRR 6, base: 4800MB, range: 64MB, type UC
>  >>  >>  >>>
>  >>  >>  >>> so your X server need two entries for WB?
>  >>  >>  >>>
>  >>  >>  >>> can you send out /proc/mtrr with booting with disable_mtrr_cleanup?
>  >>  >>  >> I can just not right now , cannot reboot the box yet. In about 1h or so , maybe less.
>  >>  >>  >
>  >>  >>  > Here the output with v3 which is disabled by default:
>  >>  >>  >
>  >>  >>  > --($:~)-- cat /proc/mtrr
>  >>  >>  > reg00: base=0xd0000000 (3328MB), size= 256MB: uncachable, count=1
>  >>  >>  > reg01: base=0xe0000000 (3584MB), size= 512MB: uncachable, count=1
>  >>  >>  > reg02: base=0x00000000 (   0MB), size=4096MB: write-back, count=1
>  >>  >>  > reg03: base=0x100000000 (4096MB), size= 512MB: write-back, count=1
>  >>  >>  > reg04: base=0x120000000 (4608MB), size= 128MB: write-back, count=1
>  >>  >>  > reg05: base=0x128000000 (4736MB), size=  64MB: write-back, count=1
>  >>  >>  > reg06: base=0xcf600000 (3318MB), size=   2MB: uncachable, count=1
>  >>  >>  >
>  >>  >>  > dmesg is saying now :
>  >>  >>  >
>  >>  >>  > [   22.764595] mtrr: type mismatch for d0000000,10000000 old: write-back new: write-combining
>  >>  >>  >
>  >>  >>  >
>  >>  >>  > My card settings in BIOS ( that was default ) are the following :
>  >>  >>  >
>  >>  >>  > DVMT Mode -> DVMT Mode ( possible setting DVMT Mode or Fixed Mode )
>  >>  >>  > DVMT / Memory -> 256MB ( possible settings 128/256 MB or Maximum DVMT )
>  >>  >>  >
>  >>  >>  > Initiate Graphics Adapter -> PEG/PCI ( possible settings IGD , PCI/IGD , PCI/PEG , PEG/IGD )
>  >>  >>  > Internal Graphics Mode Select -> Enabled,8MB ( possible settings Enabled,8MB , Enabled,1MB maybe Disabled I forgot to look)
>  >>  >>  > PEG Port -> Auto ( possible settings Auto , Disabled )
>  >>  >>  > PEG Port Force x1 -> Disabled ( possible settings Enabled , Disabled )
>  >>  >>  >
>  >>  >>  > Of course these settings are only possible when the card is not disabled :)
>  >>  >>  >
>  >>  >>  > I'm gonna try v4 now and enable it. Please let me know if you need more infos.
>  >>  >>
>  >>  >>  Hmm v4 doesn't work anymore here ( I've tested with all possible settings in BIOS ).
>  >>  >>  It takes 6 minutes to boot to :
>  >>  >>
>  >>  >
>  >>  > so you card is using 256M and 8M? 0xd0000000-0xe0000000, where is
>  >>  > another 8M address.
>  >>
>  >>  Looks like this , yes. Is using the 256MB Memory and the 8MB for Graphics Mode Select.
>  >>
>  >>  I'm not really sure why the 8MB are needed , BIOS book doesn't tell me.
>  >>  I could try to disable and see what I get =)
>  >>
>  >>
>  >>
>  >>  >
>  >>  > mtrr by BIOS is very interesting:
>  >>  > before
>  >>  >>  > reg02: base=0x00000000 (   0MB), size=4096MB: write-back, count=1
>  >>  >>  > reg06: base=0xcf600000 (3318MB), size=   2MB: uncachable, count=1
>  >>  >>  > reg00: base=0xd0000000 (3328MB), size= 256MB: uncachable, count=1
>  >>  >>  > reg01: base=0xe0000000 (3584MB), size= 512MB: uncachable, count=1
>  >>  >>  > reg03: base=0x100000000 (4096MB), size= 512MB: write-back, count=1
>  >>  >>  > reg04: base=0x120000000 (4608MB), size= 128MB: write-back, count=1
>  >>  >>  > reg05: base=0x128000000 (4736MB), size=  64MB: write-back, count=1
>  >>  >
>  >>  >
>  >>  > after 256M chunk size got
>  >>  >>  >>> [    0.000000] Setting variable MTRR 0, base: 0MB, range: 2048MB, type WB
>  >>  >>  >>> [    0.000000] Setting variable MTRR 1, base: 2048MB, range: 1024MB, type WB
>  >>  >>  >>> [    0.000000] Setting variable MTRR 2, base: 3072MB, range: 256MB, type WB
>  >>  >>  >>> [    0.000000] Setting variable MTRR 3, base: 3320MB, range: 8MB, type WB
>  >>  >>  >>> [    0.000000] Setting variable MTRR 4, base: 4096MB, range: 512MB, type WB
>  >>  >>  >>> [    0.000000] Setting variable MTRR 5, base: 4608MB, range: 256MB, type WB
>  >>  >>  >>> [    0.000000] Setting variable MTRR 6, base: 4800MB, range: 64MB, type UC
>  >>  >
>  >>  > so the convering is right..., need to spare another entry for your card.
>  >>  >
>  >>  > or we can dumping the
>  >>  >>  >>> [    0.000000] Setting variable MTRR 3, base: 3320MB, range: 8MB, type WB
>  >>  > for extra entra...
>  >>  >
>  >>  > but the mtrr trimming code need to be updated instead of only using highest_pfn
>  >>  >
>  >>  > YH
>  >>  >
>  >
>  > please try to test patch with mtrr_chunk_size= 2g; 1g, 512m, 128m. etc.
>  > only for test: i comment out the fill_var_state..
>
>  There are the dmesg's , down to 2m and without chunk_size :
>
>  http://frugalware.org/~crazy/mtrr/mtrr/

please check this one v6 test.

please only check =2g, 1g, and 512m, 256m, 128m, 64m.

Thanks

Yinghai Lu

------=_Part_6922_4353305.1209436903512
Content-Type: text/x-patch; name=mtrr_cleanup_v6.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fflvg45s0
Content-Disposition: attachment; filename=mtrr_cleanup_v6.patch

W1BBVENIXSB4ODY6IG10cnIgY2xlYW51cCBmb3IgY29udmVydGluZyBjb250aW51b3VzIHRvIGRp
c2NyZXRlIGxheW91dCB2NgoKc29tZSBCSU9TIGxpa2UgdG8gdXNlIGNvbnRpbnVzIE1UUlIgbGF5
b3V0LCBhbmQgbWF5IFggZHJpdmVyIGNhbiBub3QgYWRkCldCIGVudHJpZXMgZm9yIGdyYXBoaWNh
bCBjYXJkcyB3aGVuIDRnIG9yIG1vcmUgUkFNIGluc3RhbGxlZC4KCnRoZSBwYXRjaCB3aWxsIGNo
YW5nZSBNVFJSIHRvIGRpc2NyZXRlLgoKbXRycl9jaHVua19zaXplPSBjb3VsZCBiZSB1c2VkIHRv
IGhhdmUgc21hbGxlciBjb250aW51b3VzIGJsb2NrIHRvIGhvbGQgaG9sZXMuCmRlZmF1bHQgaXMg
MjU2bSwgY291bGQgYmUgc2V0IGFjY29yZGluZyB0byBzaXplIG9mIGdyYXBoaWNzIGNhcmQgbWVt
b3J5LgoKdjI6IGZpeCAtMSBmb3IgVUMgY2hlY2tpbmcKdjM6IGRlZmF1bHQgdG8gZGlzYWJsZSwg
YW5kIG5lZWQgdXNlIGVuYWJsZV9tdHJyX2NsZWFudXAgdG8gZW5hYmxlIHRoaXMgZmVhdHVyZQog
ICAgc2tpcCB0aGUgdmFyIHN0YXRlIGNoYW5nZSB3YXJuaW5nLgogICAgcmVtb3ZlIG5leHRfYmFz
ZWsgaW4gcmFuZ2VfdG9fbXRycigpCnY0OiBjb3JyZWN0IHdhcm5pbmcgbWFzay4KdjU6IENPTkZJ
R19NVFJSX1NBTklUSVpFUgp2NjogMWcsIDJnLCA1MTIgYWxpZ21lbnQgd2l0aCBleHRyYSBob2xl
CgpTaWduZWQtb2ZmLWJ5OiBZaW5naGFpIEx1IDx5aGx1Lmtlcm5lbEBnbWFpbC5jb20+CgpJbmRl
eDogbGludXgtMi42L2FyY2gveDg2L2tlcm5lbC9jcHUvbXRyci9nZW5lcmljLmMKPT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PQotLS0gbGludXgtMi42Lm9yaWcvYXJjaC94ODYva2VybmVsL2NwdS9tdHJyL2dlbmVyaWMuYwor
KysgbGludXgtMi42L2FyY2gveDg2L2tlcm5lbC9jcHUvbXRyci9nZW5lcmljLmMKQEAgLTE1OCw2
ICsxNTgsMjAgQEAgZ2V0X210cnJfdmFyX3JhbmdlKHVuc2lnbmVkIGludCBpbmRleCwgcwogCXJk
bXNyKE1UUlJwaHlzTWFza19NU1IoaW5kZXgpLCB2ci0+bWFza19sbywgdnItPm1hc2tfaGkpOwog
fQogCisvKiAgZmlsbCB0aGUgTVNSIHBhaXIgcmVsYXRpbmcgdG8gYSB2YXIgcmFuZ2UgICovCit2
b2lkIGZpbGxfbXRycl92YXJfcmFuZ2UodW5zaWduZWQgaW50IGluZGV4LAorCQl1MzIgYmFzZV9s
bywgdTMyIGJhc2VfaGksIHUzMiBtYXNrX2xvLCB1MzIgbWFza19oaSkKK3sKKwlzdHJ1Y3QgbXRy
cl92YXJfcmFuZ2UgKnZyOworCisJdnIgPSBtdHJyX3N0YXRlLnZhcl9yYW5nZXM7CisKKwl2cltp
bmRleF0uYmFzZV9sbyA9IGJhc2VfbG87CisJdnJbaW5kZXhdLmJhc2VfaGkgPSBiYXNlX2hpOwor
CXZyW2luZGV4XS5tYXNrX2xvID0gbWFza19sbzsKKwl2cltpbmRleF0ubWFza19oaSA9IG1hc2tf
aGk7Cit9CisKIHN0YXRpYyB2b2lkCiBnZXRfZml4ZWRfcmFuZ2VzKG10cnJfdHlwZSAqIGZycykK
IHsKSW5kZXg6IGxpbnV4LTIuNi9hcmNoL3g4Ni9rZXJuZWwvY3B1L210cnIvbWFpbi5jCj09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT0KLS0tIGxpbnV4LTIuNi5vcmlnL2FyY2gveDg2L2tlcm5lbC9jcHUvbXRyci9tYWluLmMK
KysrIGxpbnV4LTIuNi9hcmNoL3g4Ni9rZXJuZWwvY3B1L210cnIvbWFpbi5jCkBAIC0zNyw2ICsz
Nyw3IEBACiAjaW5jbHVkZSA8bGludXgvc21wLmg+CiAjaW5jbHVkZSA8bGludXgvY3B1Lmg+CiAj
aW5jbHVkZSA8bGludXgvbXV0ZXguaD4KKyNpbmNsdWRlIDxsaW51eC9zb3J0Lmg+CiAKICNpbmNs
dWRlIDxhc20vZTgyMC5oPgogI2luY2x1ZGUgPGFzbS9tdHJyLmg+CkBAIC02MDksNiArNjEwLDM3
NSBAQCBzdGF0aWMgc3RydWN0IHN5c2Rldl9kcml2ZXIgbXRycl9zeXNkZXZfCiAJLnJlc3VtZQkJ
PSBtdHJyX3Jlc3RvcmUsCiB9OwogCisjaWZkZWYgQ09ORklHX01UUlJfU0FOSVRJWkVSCisKKyNp
ZmRlZiBDT05GSUdfTVRSUl9TQU5JVElaRVJfRU5BQkxFX0RFRkFVTFQKK3N0YXRpYyBpbnQgZW5h
YmxlX210cnJfY2xlYW51cCBfX2luaXRkYXRhID0gMTsKKyNlbHNlCitzdGF0aWMgaW50IGVuYWJs
ZV9tdHJyX2NsZWFudXAgX19pbml0ZGF0YTsKKyNlbmRpZgorCisjZWxzZQorCitzdGF0aWMgaW50
IGVuYWJsZV9tdHJyX2NsZWFudXAgX19pbml0ZGF0YSA9IC0xOworCisjZW5kaWYKKworc3RhdGlj
IGludCBfX2luaXQgZGlzYWJsZV9tdHJyX2NsZWFudXBfc2V0dXAoY2hhciAqc3RyKQoreworCWlm
IChlbmFibGVfbXRycl9jbGVhbnVwICE9IC0xKQorCQllbmFibGVfbXRycl9jbGVhbnVwID0gMDsK
KwlyZXR1cm4gMDsKK30KK2Vhcmx5X3BhcmFtKCJkaXNhYmxlX210cnJfY2xlYW51cCIsIGRpc2Fi
bGVfbXRycl9jbGVhbnVwX3NldHVwKTsKKworc3RhdGljIGludCBfX2luaXQgZW5hYmxlX210cnJf
Y2xlYW51cF9zZXR1cChjaGFyICpzdHIpCit7CisJaWYgKGVuYWJsZV9tdHJyX2NsZWFudXAgIT0g
LTEpCisJCWVuYWJsZV9tdHJyX2NsZWFudXAgPSAxOworCXJldHVybiAwOworfQorZWFybHlfcGFy
YW0oImVuYmxlX210cnJfY2xlYW51cCIsIGVuYWJsZV9tdHJyX2NsZWFudXBfc2V0dXApOworCisj
ZGVmaW5lIFJBTkdFX05VTSAyNTYKKworc3RydWN0IHJlc19yYW5nZSB7CisJc2l6ZV90IHN0YXJ0
OworCXNpemVfdCBlbmQ7Cit9OworCitzdGF0aWMgdm9pZCBfX2luaXQgc3VidHJhY3RfcmFuZ2Uo
c3RydWN0IHJlc19yYW5nZSAqcmFuZ2UsIHNpemVfdCBzdGFydCwKKwkJCQlzaXplX3QgZW5kKQor
eworCWludCBpOworCWludCBqOworCisJZm9yIChqID0gMDsgaiA8IFJBTkdFX05VTTsgaisrKSB7
CisJCWlmICghcmFuZ2Vbal0uZW5kKQorCQkJY29udGludWU7CisKKwkJaWYgKHN0YXJ0IDw9IHJh
bmdlW2pdLnN0YXJ0ICYmIGVuZCA+PSByYW5nZVtqXS5lbmQpIHsKKwkJCXJhbmdlW2pdLnN0YXJ0
ID0gMDsKKwkJCXJhbmdlW2pdLmVuZCA9IDA7CisJCQljb250aW51ZTsKKwkJfQorCisJCWlmIChz
dGFydCA8PSByYW5nZVtqXS5zdGFydCAmJiBlbmQgPCByYW5nZVtqXS5lbmQgJiYgcmFuZ2Vbal0u
c3RhcnQgPCBlbmQgKyAxKSB7CisJCQlyYW5nZVtqXS5zdGFydCA9IGVuZCArIDE7CisJCQljb250
aW51ZTsKKwkJfQorCisKKwkJaWYgKHN0YXJ0ID4gcmFuZ2Vbal0uc3RhcnQgJiYgZW5kID49IHJh
bmdlW2pdLmVuZCAmJiByYW5nZVtqXS5lbmQgPiBzdGFydCAtIDEpIHsKKwkJCXJhbmdlW2pdLmVu
ZCA9IHN0YXJ0IC0gMTsKKwkJCWNvbnRpbnVlOworCQl9CisKKwkJaWYgKHN0YXJ0ID4gcmFuZ2Vb
al0uc3RhcnQgJiYgZW5kIDwgcmFuZ2Vbal0uZW5kKSB7CisJCQkvKiBmaW5kIHRoZSBuZXcgc3Bh
cmUgKi8KKwkJCWZvciAoaSA9IDA7IGkgPCBSQU5HRV9OVU07IGkrKykgeworCQkJCWlmIChyYW5n
ZVtpXS5lbmQgPT0gMCkKKwkJCQkJYnJlYWs7CisJCQl9CisJCQlpZiAoaSA8IFJBTkdFX05VTSkg
eworCQkJCXJhbmdlW2ldLmVuZCA9IHJhbmdlW2pdLmVuZDsKKwkJCQlyYW5nZVtpXS5zdGFydCA9
IGVuZCArIDE7CisJCQl9IGVsc2UgeworCQkJCXByaW50ayhLRVJOX0VSUiAicnVuIG9mIHNsb3Qg
aW4gcmFuZ2VzXG4iKTsKKwkJCX0KKwkJCXJhbmdlW2pdLmVuZCA9IHN0YXJ0IC0gMTsKKwkJCWNv
bnRpbnVlOworCQl9CisJfQorfQorCitzdGF0aWMgaW50IF9fY3B1aW5pdCBjbXBfcmFuZ2UoY29u
c3Qgdm9pZCAqeDEsIGNvbnN0IHZvaWQgKngyKQoreworCWNvbnN0IHN0cnVjdCByZXNfcmFuZ2Ug
KnIxID0geDE7CisJY29uc3Qgc3RydWN0IHJlc19yYW5nZSAqcjIgPSB4MjsKKwlzNjQgc3RhcnQx
LCBzdGFydDI7CisKKwlzdGFydDEgPSByMS0+c3RhcnQ7CisJc3RhcnQyID0gcjItPnN0YXJ0Owor
CisJcmV0dXJuIHN0YXJ0MSAtIHN0YXJ0MjsKK30KKworc3RydWN0IHZhcl9tdHJyX3N0YXRlIHsK
Kwl1bnNpZ25lZCBsb25nIHJhbmdlX3N0YXJ0aywgcmFuZ2Vfc2l6ZWs7CisJdW5zaWduZWQgbG9u
ZyBjaHVua19zaXplazsKKwl1bnNpZ25lZCBpbnQgcmVnOworCXVuc2lnbmVkIGFkZHJlc3NfYml0
czsKK307CisKK3N0YXRpYyB2b2lkIF9faW5pdCBzZXRfdmFyX210cnIoCisJdW5zaWduZWQgaW50
IHJlZywgdW5zaWduZWQgbG9uZyBiYXNlaywgdW5zaWduZWQgbG9uZyBzaXplaywKKwl1bnNpZ25l
ZCBjaGFyIHR5cGUsIHVuc2lnbmVkIGFkZHJlc3NfYml0cykKK3sKKwl1MzIgYmFzZV9sbywgYmFz
ZV9oaSwgbWFza19sbywgbWFza19oaTsKKwl1bnNpZ25lZCBhZGRyZXNzX21hc2tfaGlnaDsKKwor
CWlmICghc2l6ZWspIHsKKy8vCQlmaWxsX210cnJfdmFyX3JhbmdlKHJlZywgMCwgMCwgMCwgMCk7
CisJCXJldHVybjsKKwl9CisKKwlhZGRyZXNzX21hc2tfaGlnaCA9ICgoMXUgPDwgKGFkZHJlc3Nf
Yml0cyAtIDMydSkpIC0gMXUpOworCisJYmFzZV9oaSA9IGJhc2VrID4+IDIyOworCWJhc2VfbG8g
ID0gYmFzZWsgPDwgMTA7CisKKwlpZiAoc2l6ZWsgPCA0KjEwMjQqMTAyNCkgeworCQltYXNrX2hp
ID0gYWRkcmVzc19tYXNrX2hpZ2g7CisJCW1hc2tfbG8gPSB+KChzaXplayA8PCAxMCkgLSAxKTsK
Kwl9IGVsc2UgeworCQltYXNrX2hpID0gYWRkcmVzc19tYXNrX2hpZ2ggJiAofigoc2l6ZWsgPj4g
MjIpIC0gMSkpOworCQltYXNrX2xvID0gMDsKKwl9CisKKwliYXNlX2xvIHw9IHR5cGU7CisJbWFz
a19sbyB8PSAweDgwMDsKKy8vCWZpbGxfbXRycl92YXJfcmFuZ2UocmVnLCBiYXNlX2xvLCBiYXNl
X2hpLCBtYXNrX2xvLCBtYXNrX2hpKTsKK30KKworc3RhdGljIHVuc2lnbmVkIGludCBfX2luaXQg
cmFuZ2VfdG9fbXRycih1bnNpZ25lZCBpbnQgcmVnLAorCXVuc2lnbmVkIGxvbmcgcmFuZ2Vfc3Rh
cnRrLCB1bnNpZ25lZCBsb25nIHJhbmdlX3NpemVrLAorCXVuc2lnbmVkIGNoYXIgdHlwZSwgdW5z
aWduZWQgYWRkcmVzc19iaXRzKQoreworCWlmICghcmFuZ2Vfc2l6ZWsgfHwgKHJlZyA+PSBudW1f
dmFyX3JhbmdlcykpCisJCXJldHVybiByZWc7CisKKwl3aGlsZSAocmFuZ2Vfc2l6ZWspIHsKKwkJ
dW5zaWduZWQgbG9uZyBtYXhfYWxpZ24sIGFsaWduOworCQl1bnNpZ25lZCBsb25nIHNpemVrOwor
CQkvKiBDb21wdXRlIHRoZSBtYXhpbXVtIHNpemUgSSBjYW4gbWFrZSBhIHJhbmdlICovCisJCWlm
IChyYW5nZV9zdGFydGspCisJCQltYXhfYWxpZ24gPSBmZnMocmFuZ2Vfc3RhcnRrKSAtIDE7CisJ
CWVsc2UKKwkJCW1heF9hbGlnbiA9IDMyOworCQlhbGlnbiA9IGZscyhyYW5nZV9zaXplaykgLSAx
OworCQlpZiAoYWxpZ24gPiBtYXhfYWxpZ24pCisJCQlhbGlnbiA9IG1heF9hbGlnbjsKKworCQlz
aXplayA9IDEgPDwgYWxpZ247CisJCXByaW50ayhLRVJOX0lORk8gIlNldHRpbmcgdmFyaWFibGUg
TVRSUiAlZCwgYmFzZTogJWxkTUIsIHJhbmdlOiAlbGRNQiwgdHlwZSAlc1xuIiwKKwkJCXJlZywg
cmFuZ2Vfc3RhcnRrID4+IDEwLCBzaXplayA+PiAxMCwKKwkJCSh0eXBlID09IE1UUlJfVFlQRV9V
TkNBQ0hBQkxFKT8iVUMiOgorCQkJICAgICgodHlwZSA9PSBNVFJSX1RZUEVfV1JCQUNLKT8iV0Ii
OiJPdGhlciIpCisJCQkpOworCQlzZXRfdmFyX210cnIocmVnKyssIHJhbmdlX3N0YXJ0aywgc2l6
ZWssIHR5cGUsIGFkZHJlc3NfYml0cyk7CisJCXJhbmdlX3N0YXJ0ayArPSBzaXplazsKKwkJcmFu
Z2Vfc2l6ZWsgLT0gc2l6ZWs7CisJCWlmIChyZWcgPj0gbnVtX3Zhcl9yYW5nZXMpCisJCQlicmVh
azsKKwl9CisJcmV0dXJuIHJlZzsKK30KKworc3RhdGljIHZvaWQgX19pbml0IHJhbmdlX3RvX210
cnJfd2l0aF9ob2xlKHN0cnVjdCB2YXJfbXRycl9zdGF0ZSAqc3RhdGUsIHVuc2lnbmVkIGxvbmcg
YmFzZWspCit7CisJdW5zaWduZWQgbG9uZyBob2xlX2Jhc2VrLCBob2xlX3NpemVrOworCXVuc2ln
bmVkIGxvbmcgcmFuZ2UwX2Jhc2VrLCByYW5nZTBfc2l6ZWs7CisJdW5zaWduZWQgbG9uZyByYW5n
ZV9iYXNlaywgcmFuZ2Vfc2l6ZWs7CisJdW5zaWduZWQgbG9uZyBjaHVua19zaXplazsKKworCWhv
bGVfYmFzZWsgPSAwOworCWhvbGVfc2l6ZWsgPSAwOworCWNodW5rX3NpemVrID0gc3RhdGUtPmNo
dW5rX3NpemVrOworCXJhbmdlMF9iYXNlayA9IHN0YXRlLT5yYW5nZV9zdGFydGs7CisKKwkvKiB0
cnkgdG8gYXBwZW5kIHNvbWUgc21hbGwgaG9sZSAqLworCXJhbmdlMF9zaXplayA9IEFMSUdOKHN0
YXRlLT5yYW5nZV9zaXplaywgY2h1bmtfc2l6ZWspOworCWlmICgocmFuZ2UwX3NpemVrID09IHN0
YXRlLT5yYW5nZV9zaXplaykgfHwKKwkgICAgKChyYW5nZTBfYmFzZWsgKyByYW5nZTBfc2l6ZWsg
LSBjaHVua19zaXplayA+IGJhc2VrKSAmJiBiYXNlaykpIHsKKwkJCXByaW50ayhLRVJOX0lORk8g
InJhbmdlWDogJTAxNmx4IC0gJTAxNmx4XG4iLCByYW5nZTBfYmFzZWs8PDEwLCAocmFuZ2UwX2Jh
c2VrICsgc3RhdGUtPnJhbmdlX3NpemVrKTw8MTApOworCQkJc3RhdGUtPnJlZyA9IHJhbmdlX3Rv
X210cnIoc3RhdGUtPnJlZywgcmFuZ2UwX2Jhc2VrLAorCQkJCXN0YXRlLT5yYW5nZV9zaXplaywg
TVRSUl9UWVBFX1dSQkFDSywgc3RhdGUtPmFkZHJlc3NfYml0cyk7CisJCXJldHVybjsKKwl9CisK
KworCXJhbmdlMF9zaXplayAtPSBjaHVua19zaXplazsKKwlyYW5nZV9iYXNlayA9IHJhbmdlMF9i
YXNlayArIHJhbmdlMF9zaXplazsKKwlwcmludGsoS0VSTl9JTkZPICJyYW5nZTA6ICUwMTZseCAt
ICUwMTZseFxuIiwgcmFuZ2UwX2Jhc2VrPDwxMCwgKHJhbmdlMF9iYXNlayArIHJhbmdlMF9zaXpl
ayk8PDEwKTsKKwlzdGF0ZS0+cmVnID0gcmFuZ2VfdG9fbXRycihzdGF0ZS0+cmVnLCByYW5nZTBf
YmFzZWssCisJCQlyYW5nZTBfc2l6ZWssIE1UUlJfVFlQRV9XUkJBQ0ssIHN0YXRlLT5hZGRyZXNz
X2JpdHMpOworCisJcmFuZ2Vfc2l6ZWsgPSBjaHVua19zaXplazsKKwlpZiAocmFuZ2Vfc2l6ZWsg
LSAoc3RhdGUtPnJhbmdlX3NpemVrIC0gcmFuZ2UwX3NpemVrKSA8IChjaHVua19zaXplayA+PiAx
KSkKKwkJaG9sZV9zaXplayA9IHJhbmdlX3NpemVrIC0gKHN0YXRlLT5yYW5nZV9zaXplayAtIHJh
bmdlMF9zaXplayk7CisJZWxzZQorCQlyYW5nZV9zaXplayA9IHN0YXRlLT5yYW5nZV9zaXplayAt
IHJhbmdlMF9zaXplazsKKworCXByaW50ayhLRVJOX0lORk8gInJhbmdlOiAlMDE2bHggLSAlMDE2
bHhcbiIsIHJhbmdlX2Jhc2VrPDwxMCwgKHJhbmdlX2Jhc2VrICsgcmFuZ2Vfc2l6ZWspPDwxMCk7
CisJc3RhdGUtPnJlZyA9IHJhbmdlX3RvX210cnIoc3RhdGUtPnJlZywgcmFuZ2VfYmFzZWssCisJ
CQlyYW5nZV9zaXplaywgTVRSUl9UWVBFX1dSQkFDSywgc3RhdGUtPmFkZHJlc3NfYml0cyk7CisJ
aWYgKGhvbGVfc2l6ZWspIHsKKwkJcHJpbnRrKEtFUk5fSU5GTyAiaG9sZTogJTAxNmx4IC0gJTAx
Nmx4XG4iLCBob2xlX2Jhc2VrPDwxMCwgKGhvbGVfYmFzZWsgKyBob2xlX3NpemVrKTw8MTApOwor
CQlzdGF0ZS0+cmVnID0gcmFuZ2VfdG9fbXRycihzdGF0ZS0+cmVnLCBob2xlX2Jhc2VrLAorCQkJ
CWhvbGVfc2l6ZWssIE1UUlJfVFlQRV9VTkNBQ0hBQkxFLCBzdGF0ZS0+YWRkcmVzc19iaXRzKTsK
Kwl9Cit9CisKK3N0YXRpYyB2b2lkIF9faW5pdCBzZXRfdmFyX210cnJfcmFuZ2Uoc3RydWN0IHZh
cl9tdHJyX3N0YXRlICpzdGF0ZSwgc2l6ZV90IGJhc2VfcGZuLCBzaXplX3Qgc2l6ZV9wZm4pCit7
CisJdW5zaWduZWQgbG9uZyBiYXNlaywgc2l6ZWs7CisKKwlpZiAoc3RhdGUtPnJlZyA+PSBudW1f
dmFyX3JhbmdlcykKKwkJcmV0dXJuOworCisJYmFzZWsgPSBiYXNlX3BmbiA8PCAoUEFHRV9TSElG
VCAtIDEwKTsKKwlzaXplayA9IHNpemVfcGZuIDw8IChQQUdFX1NISUZUIC0gMTApOworCisJLyog
U2VlIGlmIEkgY2FuIG1lcmdlIHdpdGggdGhlIGxhc3QgcmFuZ2UgKi8KKwlpZiAoKGJhc2VrIDw9
IDEwMjQpIHx8IChzdGF0ZS0+cmFuZ2Vfc3RhcnRrICsgc3RhdGUtPnJhbmdlX3NpemVrID09IGJh
c2VrKSkgeworCQl1bnNpZ25lZCBsb25nIGVuZGsgPSBiYXNlayArIHNpemVrOworCQlzdGF0ZS0+
cmFuZ2Vfc2l6ZWsgPSBlbmRrIC0gc3RhdGUtPnJhbmdlX3N0YXJ0azsKKwkJcmV0dXJuOworCX0K
KwkvKiBXcml0ZSB0aGUgcmFuZ2UgbXRycnMgKi8KKwlpZiAoc3RhdGUtPnJhbmdlX3NpemVrICE9
IDApIHsKKwkJcmFuZ2VfdG9fbXRycl93aXRoX2hvbGUoc3RhdGUsIGJhc2VrKTsKKworCQlzdGF0
ZS0+cmFuZ2Vfc3RhcnRrID0gMDsKKwkJc3RhdGUtPnJhbmdlX3NpemVrID0gMDsKKwl9CisJLyog
QWxsb2NhdGUgYW4gbXNyICovCisJc3RhdGUtPnJhbmdlX3N0YXJ0ayA9IGJhc2VrOworCXN0YXRl
LT5yYW5nZV9zaXplayAgPSBzaXplazsKK30KKworc3RhdGljIHU2NCBtdHJyX2NodW5rX3NpemUg
X19pbml0ZGF0YSA9ICgyNTZVTEw8PDIwKTsKKworc3RhdGljIGludCBfX2luaXQgcGFyc2VfbXRy
cl9jaHVua19zaXplX29wdChjaGFyICpwKQoreworCWlmICghcCkKKwkJcmV0dXJuIC1FSU5WQUw7
CisJbXRycl9jaHVua19zaXplID0gbWVtcGFyc2UocCwgJnApOworCXJldHVybiAwOworfQorZWFy
bHlfcGFyYW0oIm10cnJfY2h1bmtfc2l6ZSIsIHBhcnNlX210cnJfY2h1bmtfc2l6ZV9vcHQpOwor
CitzdGF0aWMgdm9pZCBfX2luaXQgeDg2X3NldHVwX3Zhcl9tdHJycyhzdHJ1Y3QgcmVzX3Jhbmdl
ICpyYW5nZSwgaW50IG5yX3JhbmdlLCB1bnNpZ25lZCBhZGRyZXNzX2JpdHMpCit7CisJc3RydWN0
IHZhcl9tdHJyX3N0YXRlIHZhcl9zdGF0ZTsKKwlpbnQgaTsKKworCXZhcl9zdGF0ZS5yYW5nZV9z
dGFydGsgPSAwOworCXZhcl9zdGF0ZS5yYW5nZV9zaXplayA9IDA7CisJdmFyX3N0YXRlLnJlZyA9
IDA7CisJdmFyX3N0YXRlLmFkZHJlc3NfYml0cyA9IGFkZHJlc3NfYml0czsKKwl2YXJfc3RhdGUu
Y2h1bmtfc2l6ZWsgPSBtdHJyX2NodW5rX3NpemUgPj4gMTA7CisKKwkvKiBXcml0ZSB0aGUgcmFu
Z2UgZXRjICovCisJZm9yIChpID0gMDsgaSA8IG5yX3JhbmdlOyBpKyspCisJCXNldF92YXJfbXRy
cl9yYW5nZSgmdmFyX3N0YXRlLCByYW5nZVtpXS5zdGFydCwgcmFuZ2VbaV0uZW5kIC0gcmFuZ2Vb
aV0uc3RhcnQgKyAxKTsKKworCS8qIFdyaXRlIHRoZSBsYXN0IHJhbmdlICovCisJcmFuZ2VfdG9f
bXRycl93aXRoX2hvbGUoJnZhcl9zdGF0ZSwgMCk7CisJcHJpbnRrKEtFUk5fSU5GTyAiRE9ORSB2
YXJpYWJsZSBNVFJSc1xuIik7CisJLyogQ2xlYXIgb3V0IHRoZSBleHRyYSBNVFJSJ3MgKi8KKwl3
aGlsZSAodmFyX3N0YXRlLnJlZyA8IG51bV92YXJfcmFuZ2VzKQorCQlzZXRfdmFyX210cnIodmFy
X3N0YXRlLnJlZysrLCAwLCAwLCAwLCB2YXJfc3RhdGUuYWRkcmVzc19iaXRzKTsKK30KKworc3Rh
dGljIGludCBfX2luaXQgeDg2X2dldF9tdHJyX21lbV9yYW5nZShzdHJ1Y3QgcmVzX3JhbmdlICpy
YW5nZSwgaW50IG5yX3JhbmdlKQoreworCXVuc2lnbmVkIGxvbmcgaSwgYmFzZSwgc2l6ZTsKKwlt
dHJyX3R5cGUgdHlwZTsKKwkvKgorCSAqIGdldCBXQiByYW5nZXMgYXQgZmlyc3QKKwkgKiBhc3N1
bWUgQklPUyBkb24ndCBnaXZlIHVzIG92ZXJsYXBwaW5nIFdCIGVudHJpZXMKKwkgKiBvciBhZGQg
YWRkX3JhbmdlPworCSAqLworCWZvciAoaSA9IDA7IGkgPCBudW1fdmFyX3JhbmdlczsgaSsrKSB7
CisJCW10cnJfaWYtPmdldChpLCAmYmFzZSwgJnNpemUsICZ0eXBlKTsKKwkJaWYgKHR5cGUgIT0g
TVRSUl9UWVBFX1dSQkFDSykKKwkJCWNvbnRpbnVlOworCQlyYW5nZVtucl9yYW5nZV0uc3RhcnQg
PSBiYXNlOworCQlyYW5nZVtucl9yYW5nZV0uZW5kID0gYmFzZSArIHNpemUgLSAxOworCQlucl9y
YW5nZSsrOworCX0KKwlwcmludGsoS0VSTl9JTkZPICJBZnRlciBXQiBjaGVja2luZ1xuIik7CisJ
Zm9yIChpID0gMDsgaSA8IG5yX3JhbmdlOyBpKyspCisJCXByaW50ayhLRVJOX0lORk8gIk1UUlIg
TUFQIFBGTjogJTAxNmx4IC0gJTAxNmx4XG4iLCByYW5nZVtpXS5zdGFydCwgcmFuZ2VbaV0uZW5k
ICsgMSk7CisKKwkvKiB0YWtlIG91dCBVQyByYW5nZXMgKi8KKwlmb3IgKGkgPSAwOyBpIDwgbnVt
X3Zhcl9yYW5nZXM7IGkrKykgeworCQltdHJyX2lmLT5nZXQoaSwgJmJhc2UsICZzaXplLCAmdHlw
ZSk7CisJCWlmICh0eXBlICE9IE1UUlJfVFlQRV9VTkNBQ0hBQkxFKQorCQkJY29udGludWU7CisJ
CWlmICghc2l6ZSkKKwkJCWNvbnRpbnVlOworCQlzdWJ0cmFjdF9yYW5nZShyYW5nZSwgYmFzZSwg
YmFzZSArIHNpemUgLSAxKTsKKwl9CisJLyogZ2V0IG5ldyByYW5nZSBudW0gKi8KKwlucl9yYW5n
ZSA9IDA7CisJZm9yIChpID0gMDsgaSA8IFJBTkdFX05VTTsgaSsrKSB7CisJCWlmICghcmFuZ2Vb
aV0uZW5kKQorCQkJY29udGludWU7CisJCW5yX3JhbmdlKys7CisJfQorCXByaW50ayhLRVJOX0lO
Rk8gIkFmdGVyIFVDIGNoZWNraW5nXG4iKTsKKwlmb3IgKGkgPSAwOyBpIDwgbnJfcmFuZ2U7IGkr
KykKKwkJcHJpbnRrKEtFUk5fSU5GTyAiTVRSUiBNQVAgUEZOOiAlMDE2bHggLSAlMDE2bHhcbiIs
IHJhbmdlW2ldLnN0YXJ0LCByYW5nZVtpXS5lbmQgKyAxKTsKKworCS8qIHNvcnQgdGhlIHJhbmdl
cyAqLworCXNvcnQocmFuZ2UsIG5yX3JhbmdlLCBzaXplb2Yoc3RydWN0IHJlc19yYW5nZSksIGNt
cF9yYW5nZSwgTlVMTCk7CisJcHJpbnRrKEtFUk5fSU5GTyAiQWZ0ZXIgc29ydGluZ1xuIik7CisJ
Zm9yIChpID0gMDsgaSA8IG5yX3JhbmdlOyBpKyspCisJCXByaW50ayhLRVJOX0lORk8gIk1UUlIg
TUFQIFBGTjogJTAxNmx4IC0gJTAxNmx4XG4iLCByYW5nZVtpXS5zdGFydCwgcmFuZ2VbaV0uZW5k
ICsgMSk7CisKKwlyZXR1cm4gbnJfcmFuZ2U7Cit9CisKK3N0YXRpYyBpbnQgX19pbml0IG10cnJf
Y2xlYW51cCh1bnNpZ25lZCBhZGRyZXNzX2JpdHMpCit7CisJdW5zaWduZWQgbG9uZyBpLCBiYXNl
LCBzaXplLCBkZWYsIGR1bW15OworCW10cnJfdHlwZSB0eXBlOworCXN0cnVjdCByZXNfcmFuZ2Ug
cmFuZ2VbUkFOR0VfTlVNXTsKKwlpbnQgbnJfcmFuZ2U7CisKKwkvKiBleHRyYSBvbmUgZm9yIGFs
bCAwICovCisJaW50IG51bVtNVFJSX05VTV9UWVBFUyArIDFdOworCisJaWYgKCFpc19jcHUoSU5U
RUwpIHx8IGVuYWJsZV9tdHJyX2NsZWFudXAgPCAxKQorCQlyZXR1cm4gMDsKKwlyZG1zcihNVFJS
ZGVmVHlwZV9NU1IsIGRlZiwgZHVtbXkpOworCWRlZiAmPSAweGZmOworCWlmIChkZWYgIT0gTVRS
Ul9UWVBFX1VOQ0FDSEFCTEUpCisJCXJldHVybiAwOworCisJLyogY2hlY2sgZW50cmllcyBudW1i
ZXIgKi8KKwltZW1zZXQobnVtLCAwLCBzaXplb2YobnVtKSk7CisJZm9yIChpID0gMDsgaSA8IG51
bV92YXJfcmFuZ2VzOyBpKyspIHsKKwkJbXRycl9pZi0+Z2V0KGksICZiYXNlLCAmc2l6ZSwgJnR5
cGUpOworCQlpZiAodHlwZSA+PSBNVFJSX05VTV9UWVBFUykKKwkJCWNvbnRpbnVlOworCQlpZiAo
IXNpemUpCisJCQl0eXBlID0gTVRSUl9OVU1fVFlQRVM7CisJCW51bVt0eXBlXSsrOworCX0KKwor
CS8qIGNoZWNrIGlmIHdlIGdvdCBVQyBlbnRyaWVzICovCisJaWYgKCFudW1bTVRSUl9UWVBFX1VO
Q0FDSEFCTEVdKQorCQlyZXR1cm4gMDsKKworCS8qIGNoZWNrIGlmIHdlIG9ubHkgaGFkIFdCIGFu
ZCBVQyAqLworCWlmIChudW1bTVRSUl9UWVBFX1dSQkFDS10gKyBudW1bTVRSUl9UWVBFX1VOQ0FD
SEFCTEVdICE9CisJCW51bV92YXJfcmFuZ2VzIC0gbnVtW01UUlJfTlVNX1RZUEVTXSkKKwkJcmV0
dXJuIDA7CisKKwltZW1zZXQocmFuZ2UsIDAsIHNpemVvZihyYW5nZSkpOworCW5yX3JhbmdlID0g
eDg2X2dldF9tdHJyX21lbV9yYW5nZShyYW5nZSwgMCk7CisKKwkvKiBjb252ZXJ0IHJhbmdlcyB0
byB2YXIgcmFuZ2VzIHN0YXRlICovCisJeDg2X3NldHVwX3Zhcl9tdHJycyhyYW5nZSwgbnJfcmFu
Z2UsIGFkZHJlc3NfYml0cyk7CisKKwlyZXR1cm4gMTsKKworfQorCiBzdGF0aWMgaW50IGRpc2Fi
bGVfbXRycl90cmltOwogCiBzdGF0aWMgaW50IF9faW5pdCBkaXNhYmxlX210cnJfdHJpbV9zZXR1
cChjaGFyICpzdHIpCkBAIC03MjksMTggKzEwOTksMjEgQEAgaW50IF9faW5pdCBtdHJyX3RyaW1f
dW5jYWNoZWRfbWVtb3J5KHVucwogICovCiB2b2lkIF9faW5pdCBtdHJyX2JwX2luaXQodm9pZCkK
IHsKKwl1MzIgcGh5c19hZGRyOwogCWluaXRfaWZzKCk7CiAKKwlwaHlzX2FkZHIgPSAzMjsKKwog
CWlmIChjcHVfaGFzX210cnIpIHsKIAkJbXRycl9pZiA9ICZnZW5lcmljX210cnJfb3BzOwogCQlz
aXplX29yX21hc2sgPSAweGZmMDAwMDAwOwkvKiAzNiBiaXRzICovCiAJCXNpemVfYW5kX21hc2sg
PSAweDAwZjAwMDAwOworCQlwaHlzX2FkZHIgPSAzNjsKIAogCQkvKiBUaGlzIGlzIGFuIEFNRCBz
cGVjaWZpYyBNU1IsIGJ1dCB3ZSBhc3N1bWUoaG9wZT8pIHRoYXQKIAkJICAgSW50ZWwgd2lsbCBp
bXBsZW1lbnQgaXQgdG8gd2hlbiB0aGV5IGV4dGVuZCB0aGUgYWRkcmVzcwogCQkgICBidXMgb2Yg
dGhlIFhlb24uICovCiAJCWlmIChjcHVpZF9lYXgoMHg4MDAwMDAwMCkgPj0gMHg4MDAwMDAwOCkg
ewotCQkJdTMyIHBoeXNfYWRkcjsKIAkJCXBoeXNfYWRkciA9IGNwdWlkX2VheCgweDgwMDAwMDA4
KSAmIDB4ZmY7CiAJCQkvKiBDUFVJRCB3b3JrYXJvdW5kIGZvciBJbnRlbCAwRjMzLzBGMzQgQ1BV
ICovCiAJCQlpZiAoYm9vdF9jcHVfZGF0YS54ODZfdmVuZG9yID09IFg4Nl9WRU5ET1JfSU5URUwg
JiYKQEAgLTc1OCw2ICsxMTMxLDcgQEAgdm9pZCBfX2luaXQgbXRycl9icF9pbml0KHZvaWQpCiAJ
CQkgICBkb24ndCBzdXBwb3J0IFBBRSAqLwogCQkJc2l6ZV9vcl9tYXNrID0gMHhmZmYwMDAwMDsJ
LyogMzIgYml0cyAqLwogCQkJc2l6ZV9hbmRfbWFzayA9IDA7CisJCQlwaHlzX2FkZHIgPSAzMjsK
IAkJfQogCX0gZWxzZSB7CiAJCXN3aXRjaCAoYm9vdF9jcHVfZGF0YS54ODZfdmVuZG9yKSB7CkBA
IC03OTEsOCArMTE2NSwxMyBAQCB2b2lkIF9faW5pdCBtdHJyX2JwX2luaXQodm9pZCkKIAlpZiAo
bXRycl9pZikgewogCQlzZXRfbnVtX3Zhcl9yYW5nZXMoKTsKIAkJaW5pdF90YWJsZSgpOwotCQlp
ZiAodXNlX2ludGVsKCkpCisJCWlmICh1c2VfaW50ZWwoKSkgewogCQkJZ2V0X210cnJfc3RhdGUo
KTsKKworCQkJaWYgKG10cnJfY2xlYW51cChwaHlzX2FkZHIpKQorCQkJCW10cnJfaWYtPnNldF9h
bGwoKTsKKworCQl9CiAJfQogfQogCkBAIC04MjksOSArMTIwOCwxMCBAQCBzdGF0aWMgaW50IF9f
aW5pdCBtdHJyX2luaXRfZmluaWFsaXplKHZvCiB7CiAJaWYgKCFtdHJyX2lmKQogCQlyZXR1cm4g
MDsKLQlpZiAodXNlX2ludGVsKCkpCi0JCW10cnJfc3RhdGVfd2FybigpOwotCWVsc2UgeworCWlm
ICh1c2VfaW50ZWwoKSkgeworCQlpZiAoZW5hYmxlX210cnJfY2xlYW51cCA8IDEpCisJCQltdHJy
X3N0YXRlX3dhcm4oKTsKKwl9IGVsc2UgewogCQkvKiBUaGUgQ1BVcyBoYXZlbid0IE1UUlIgYW5k
IHNlZW0gdG8gbm90IHN1cHBvcnQgU01QLiBUaGV5IGhhdmUKIAkJICogc3BlY2lmaWMgZHJpdmVy
cywgd2UgdXNlIGEgdHJpY2t5IG1ldGhvZCB0byBzdXBwb3J0CiAJCSAqIHN1c3BlbmQvcmVzdW1l
IGZvciB0aGVtLgpJbmRleDogbGludXgtMi42L2FyY2gveDg2L2tlcm5lbC9jcHUvbXRyci9tdHJy
LmgKPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PQotLS0gbGludXgtMi42Lm9yaWcvYXJjaC94ODYva2VybmVsL2NwdS9tdHJy
L210cnIuaAorKysgbGludXgtMi42L2FyY2gveDg2L2tlcm5lbC9jcHUvbXRyci9tdHJyLmgKQEAg
LTgxLDYgKzgxLDggQEAgdm9pZCBzZXRfbXRycl9kb25lKHN0cnVjdCBzZXRfbXRycl9jb250ZQog
dm9pZCBzZXRfbXRycl9jYWNoZV9kaXNhYmxlKHN0cnVjdCBzZXRfbXRycl9jb250ZXh0ICpjdHh0
KTsKIHZvaWQgc2V0X210cnJfcHJlcGFyZV9zYXZlKHN0cnVjdCBzZXRfbXRycl9jb250ZXh0ICpj
dHh0KTsKIAordm9pZCBmaWxsX210cnJfdmFyX3JhbmdlKHVuc2lnbmVkIGludCBpbmRleCwKKwkJ
dTMyIGJhc2VfbG8sIHUzMiBiYXNlX2hpLCB1MzIgbWFza19sbywgdTMyIG1hc2tfaGkpOwogdm9p
ZCBnZXRfbXRycl9zdGF0ZSh2b2lkKTsKIAogZXh0ZXJuIHZvaWQgc2V0X210cnJfb3BzKHN0cnVj
dCBtdHJyX29wcyAqIG9wcyk7CkluZGV4OiBsaW51eC0yLjYvRG9jdW1lbnRhdGlvbi9rZXJuZWwt
cGFyYW1ldGVycy50eHQKPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PQotLS0gbGludXgtMi42Lm9yaWcvRG9jdW1lbnRhdGlv
bi9rZXJuZWwtcGFyYW1ldGVycy50eHQKKysrIGxpbnV4LTIuNi9Eb2N1bWVudGF0aW9uL2tlcm5l
bC1wYXJhbWV0ZXJzLnR4dApAQCAtNTk1LDYgKzU5NSwxNiBAQCBhbmQgaXMgYmV0d2VlbiAyNTYg
YW5kIDQwOTYgY2hhcmFjdGVycy4gCiAJCQlTZWUgZHJpdmVycy9jaGFyL1JFQURNRS5lcGNhIGFu
ZAogCQkJRG9jdW1lbnRhdGlvbi9kaWdpZXBjYS50eHQuCiAKKwlkaXNhYmxlX210cnJfY2xlYW51
cCBbWDg2XQorCWVuYWJsZV9tdHJyX2NsZWFudXAgW1g4Nl0KKwkJCVRoZSBrZXJuZWwgdHJpZXMg
dG8gYWRqdXN0IE1UUlIgbGF5b3V0IGZyb20gY29udGludW91cworCQkJdG8gZGlzY3JldGUsIHRv
IG1ha2UgWCBzZXJ2ZXIgZHJpdmVyIGFibGUgdG8gYWRkIFdCCisJCQllbnRyeSBsYXRlci4gVGhp
cyBwYXJhbWV0ZXIgZW5hYmxlcy9kaXNhYmxlcyB0aGF0LgorCisJbXRycl9jaHVua19zaXplPW5u
W0tNR10gW1g4Nl0KKwkJCXVzZWQgZm9yIG10cnIgY2xlYW51cC4gSXQgaXMgbGFyZ2VzdCBjb250
aW5vdXMgY2h1bmsKKwkJCXRoYXQgY291bGQgaG9sZCBob2xlcyBha2EuIFVDIGVudHJpZXMuCisK
IAlkaXNhYmxlX210cnJfdHJpbSBbWDg2LCBJbnRlbCBhbmQgQU1EIG9ubHldCiAJCQlCeSBkZWZh
dWx0IHRoZSBrZXJuZWwgd2lsbCB0cmltIGFueSB1bmNhY2hlYWJsZQogCQkJbWVtb3J5IG91dCBv
ZiB5b3VyIGF2YWlsYWJsZSBtZW1vcnkgcG9vbCBiYXNlZCBvbgpJbmRleDogbGludXgtMi42L2Fy
Y2gveDg2L0tjb25maWcKPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PQotLS0gbGludXgtMi42Lm9yaWcvYXJjaC94ODYvS2Nv
bmZpZworKysgbGludXgtMi42L2FyY2gveDg2L0tjb25maWcKQEAgLTEwMzUsNiArMTAzNSwzMiBA
QCBjb25maWcgTVRSUgogCiAJICBTZWUgPGZpbGU6RG9jdW1lbnRhdGlvbi9tdHJyLnR4dD4gZm9y
IG1vcmUgaW5mb3JtYXRpb24uCiAKK2NvbmZpZyBNVFJSX1NBTklUSVpFUgorCWRlZl9ib29sIHkK
Kwlwcm9tcHQgIk1UUlIgY2xlYW51cCBzdXBwb3J0IgorCWRlcGVuZHMgb24gTVRSUgorCWhlbHAK
KwkgIENvbnZlcnQgTVRSUiBsYXlvdXQgZnJvbSBjb250aW51b3VzIHRvIGRpc2NyZXRlLCBzbyBz
b21lIFggZHJpdmVyCisJICBjb3VsZCBhZGQgV0IgZW50cmllcy4KKworCSAgU2F5IE4gaGVyZSBp
ZiB5b3Ugc2VlIGJvb3R1cCBwcm9ibGVtcyAoYm9vdCBjcmFzaCwgYm9vdCBoYW5nLAorCSAgc3Bv
bnRhbmVvdXMgcmVib290cykuCisKKwkgIENvdWxkIGJlIGRpc2FibGVkIHdpdGggZGlzYWJsZV9t
dHJyX2NsZWFudXAuIEFsc28gbXRycl9jaHVua19zaXplCisJICBjb3VsZCBiZSB1c2VkIHRvIHNl
bmQgbGFyZ2VzdCBtdHJyIGVudHJ5IHNpemUgZm9yIGNvbnRpbnVvdXMgYmxvY2sKKwkgIHRvIGhv
bGQgaG9sZXMgKGFrYS4gVUMgZW50cmllcykKKworCSAgSWYgdW5zdXJlLCBzYXkgWS4KKworY29u
ZmlnIE1UUlJfU0FOSVRJWkVSX0VOQUJMRV9ERUZBVUxUCisJZGVmX2Jvb2wgeQorCXByb21wdCAi
RW5hYmxlIE1UUlIgY2xlYW51cCBieSBkZWZhdWx0IgorCWRlcGVuZHMgb24gTVRSUl9TQU5JVEla
RVIKKwloZWxwCisJICBFbmFibGUgbXRyciBjbGVhbnVwIGJ5IGRlZmF1bHQKKworCSAgSWYgdW5z
dXJlLCBzYXkgWS4KKwogY29uZmlnIFg4Nl9QQVQKIAlib29sCiAJcHJvbXB0ICJ4ODYgUEFUIHN1
cHBvcnQiCg==
------=_Part_6922_4353305.1209436903512--
