Return-Path: <linux-kernel-owner+w=401wt.eu-S936621AbYD1XXZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936621AbYD1XXZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 19:23:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935309AbYD1XXM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 19:23:12 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:42400 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934228AbYD1XXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 19:23:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:references;
        b=IFRtWE/D4hi3P2qOlFtuVITebuLvSxddL5YFhW5BCHxCdywOFmG7JseNyPMkusKXMyvx0UIbKrbRBk4hegwPqTnTwQ5nR91n0QoZ12RN0Nq/0go/IensCazK+YH4+EFcNm43yOprQKH16aTxgIA7XOQvzIi/SJ2dPyVp7tDpN3g=
Message-ID: <86802c440804281623m28a5cf5x701580d0f007c097@mail.gmail.com>
Date: Mon, 28 Apr 2008 16:23:06 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Gabriel C" <nix.or.die@googlemail.com>
Subject: Re: [PATCH] x86_32: trim memory by updating e820 v3
Cc: "Mika Fischer" <mika.fischer@zoopnet.de>, "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       "Jesse Barnes" <jesse.barnes@intel.com>, balajirrao@gmail.com,
       "Andi Kleen" <andi@firstfloor.org>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <4816562B.2070905@googlemail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_6517_3252770.1209424986215"
References: <200801192045.17291.yinghai.lu@sun.com>
	 <20080428135351.GF3973@elte.hu> <4815DB15.4070908@zoopnet.de>
	 <4815DE0C.6000802@googlemail.com>
	 <86802c440804281206u6b5086a3h42192b7d36b08325@mail.gmail.com>
	 <481627B7.9060406@googlemail.com> <4816376B.8060907@googlemail.com>
	 <48163F56.70704@googlemail.com>
	 <86802c440804281503q1f9e6f8anb18cd514e89b76fe@mail.gmail.com>
	 <4816562B.2070905@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_6517_3252770.1209424986215
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Mon, Apr 28, 2008 at 3:56 PM, Gabriel C <nix.or.die@googlemail.com> wrote:
>
> Yinghai Lu wrote:
>  > On Mon, Apr 28, 2008 at 2:19 PM, Gabriel C <nix.or.die@googlemail.com> wrote:
>  >> Gabriel C wrote:
>  >>  > Gabriel C wrote:
>  >>  >> Yinghai Lu wrote:
>  >>  >>> On Mon, Apr 28, 2008 at 7:24 AM, Gabriel C <nix.or.die@googlemail.com> wrote:
>  >>  >>>> Mika Fischer wrote:
>  >>  >>>>  > Hi Ingo,
>  >>  >>>>  >
>  >>  >>>>  > I'm having the same problem.
>  >>  >>>>  >
>  >>  >>>>  > Ingo Molnar schrieb:
>  >>  >>>>  >> excellent. So just to make sure: this box never had proper graphics
>  >>  >>>>  >> under Linux (under no previous kernel), due to the way the BIOS has set
>  >>  >>>>  >> up the MTRR's, right?
>  >>  >>>>  >
>  >>  >>>>  > Well, not quite. X still works fine, but since the video memory is
>  >>  >>>>  > overlapped by two of the existing MTRRs, X cannot add a write-combining
>  >>  >>>>  > range for the video memory. That makes X rather slow especially if you
>  >>  >>>>  > use DRI for Compiz etc.
>  >>  >>>>
>  >>  >>>>  Well you are lucky then :)
>  >>  >>>>
>  >>  >>>>  Yeah X 'worked' but it worked as slow as with vesa video driver here.
>  >>  >>> [    0.000000] rangeX: 0000000000000000 - 00000000d0000000
>  >>  >>> [    0.000000] Setting variable MTRR 0, base: 0MB, range: 2048MB, type WB
>  >>  >>> [    0.000000] Setting variable MTRR 1, base: 2048MB, range: 1024MB, type WB
>  >>  >>> [    0.000000] Setting variable MTRR 2, base: 3072MB, range: 256MB, type WB
>  >>  >>> [    0.000000] range0: 00000000cf800000 - 00000000cf800000
>  >>  >>> [    0.000000] range: 00000000cf800000 - 00000000d0000000
>  >>  >>> [    0.000000] Setting variable MTRR 3, base: 3320MB, range: 8MB, type WB
>  >>  >>> [    0.000000] range0: 0000000100000000 - 0000000120000000
>  >>  >>> [    0.000000] Setting variable MTRR 4, base: 4096MB, range: 512MB, type WB
>  >>  >>> [    0.000000] range: 0000000120000000 - 0000000130000000
>  >>  >>> [    0.000000] Setting variable MTRR 5, base: 4608MB, range: 256MB, type WB
>  >>  >>> [    0.000000] hole: 000000012c000000 - 0000000130000000
>  >>  >>> [    0.000000] Setting variable MTRR 6, base: 4800MB, range: 64MB, type UC
>  >>  >>>
>  >>  >>> so your X server need two entries for WB?
>  >>  >>>
>  >>  >>> can you send out /proc/mtrr with booting with disable_mtrr_cleanup?
>  >>  >> I can just not right now , cannot reboot the box yet. In about 1h or so , maybe less.
>  >>  >
>  >>  > Here the output with v3 which is disabled by default:
>  >>  >
>  >>  > --($:~)-- cat /proc/mtrr
>  >>  > reg00: base=0xd0000000 (3328MB), size= 256MB: uncachable, count=1
>  >>  > reg01: base=0xe0000000 (3584MB), size= 512MB: uncachable, count=1
>  >>  > reg02: base=0x00000000 (   0MB), size=4096MB: write-back, count=1
>  >>  > reg03: base=0x100000000 (4096MB), size= 512MB: write-back, count=1
>  >>  > reg04: base=0x120000000 (4608MB), size= 128MB: write-back, count=1
>  >>  > reg05: base=0x128000000 (4736MB), size=  64MB: write-back, count=1
>  >>  > reg06: base=0xcf600000 (3318MB), size=   2MB: uncachable, count=1
>  >>  >
>  >>  > dmesg is saying now :
>  >>  >
>  >>  > [   22.764595] mtrr: type mismatch for d0000000,10000000 old: write-back new: write-combining
>  >>  >
>  >>  >
>  >>  > My card settings in BIOS ( that was default ) are the following :
>  >>  >
>  >>  > DVMT Mode -> DVMT Mode ( possible setting DVMT Mode or Fixed Mode )
>  >>  > DVMT / Memory -> 256MB ( possible settings 128/256 MB or Maximum DVMT )
>  >>  >
>  >>  > Initiate Graphics Adapter -> PEG/PCI ( possible settings IGD , PCI/IGD , PCI/PEG , PEG/IGD )
>  >>  > Internal Graphics Mode Select -> Enabled,8MB ( possible settings Enabled,8MB , Enabled,1MB maybe Disabled I forgot to look)
>  >>  > PEG Port -> Auto ( possible settings Auto , Disabled )
>  >>  > PEG Port Force x1 -> Disabled ( possible settings Enabled , Disabled )
>  >>  >
>  >>  > Of course these settings are only possible when the card is not disabled :)
>  >>  >
>  >>  > I'm gonna try v4 now and enable it. Please let me know if you need more infos.
>  >>
>  >>  Hmm v4 doesn't work anymore here ( I've tested with all possible settings in BIOS ).
>  >>  It takes 6 minutes to boot to :
>  >>
>  >
>  > so you card is using 256M and 8M? 0xd0000000-0xe0000000, where is
>  > another 8M address.
>
>  Looks like this , yes. Is using the 256MB Memory and the 8MB for Graphics Mode Select.
>
>  I'm not really sure why the 8MB are needed , BIOS book doesn't tell me.
>  I could try to disable and see what I get =)
>
>
>
>  >
>  > mtrr by BIOS is very interesting:
>  > before
>  >>  > reg02: base=0x00000000 (   0MB), size=4096MB: write-back, count=1
>  >>  > reg06: base=0xcf600000 (3318MB), size=   2MB: uncachable, count=1
>  >>  > reg00: base=0xd0000000 (3328MB), size= 256MB: uncachable, count=1
>  >>  > reg01: base=0xe0000000 (3584MB), size= 512MB: uncachable, count=1
>  >>  > reg03: base=0x100000000 (4096MB), size= 512MB: write-back, count=1
>  >>  > reg04: base=0x120000000 (4608MB), size= 128MB: write-back, count=1
>  >>  > reg05: base=0x128000000 (4736MB), size=  64MB: write-back, count=1
>  >
>  >
>  > after 256M chunk size got
>  >>  >>> [    0.000000] Setting variable MTRR 0, base: 0MB, range: 2048MB, type WB
>  >>  >>> [    0.000000] Setting variable MTRR 1, base: 2048MB, range: 1024MB, type WB
>  >>  >>> [    0.000000] Setting variable MTRR 2, base: 3072MB, range: 256MB, type WB
>  >>  >>> [    0.000000] Setting variable MTRR 3, base: 3320MB, range: 8MB, type WB
>  >>  >>> [    0.000000] Setting variable MTRR 4, base: 4096MB, range: 512MB, type WB
>  >>  >>> [    0.000000] Setting variable MTRR 5, base: 4608MB, range: 256MB, type WB
>  >>  >>> [    0.000000] Setting variable MTRR 6, base: 4800MB, range: 64MB, type UC
>  >
>  > so the convering is right..., need to spare another entry for your card.
>  >
>  > or we can dumping the
>  >>  >>> [    0.000000] Setting variable MTRR 3, base: 3320MB, range: 8MB, type WB
>  > for extra entra...
>  >
>  > but the mtrr trimming code need to be updated instead of only using highest_pfn
>  >
>  > YH
>  >

please try to test patch with mtrr_chunk_size= 2g; 1g, 512m, 128m. etc.
only for test: i comment out the fill_var_state..

YH

------=_Part_6517_3252770.1209424986215
Content-Type: text/x-patch; name=mtrr_cleanup.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fflodjza0
Content-Disposition: attachment; filename=mtrr_cleanup.patch

W1BBVENIXSB4ODY6IG10cnIgY2xlYW51cCBmb3IgY29udmVydGluZyBjb250aW51b3VzIHRvIGRp
c2NyZXRlIGxheW91dCB2NQoKc29tZSBCSU9TIGxpa2UgdG8gdXNlIGNvbnRpbnVzIE1UUlIgbGF5
b3V0LCBhbmQgbWF5IFggZHJpdmVyIGNhbiBub3QgYWRkCldCIGVudHJpZXMgZm9yIGdyYXBoaWNh
bCBjYXJkcyB3aGVuIDRnIG9yIG1vcmUgUkFNIGluc3RhbGxlZC4KCnRoZSBwYXRjaCB3aWxsIGNo
YW5nZSBNVFJSIHRvIGRpc2NyZXRlLgoKbXRycl9jaHVua19zaXplPSBjb3VsZCBiZSB1c2VkIHRv
IGhhdmUgc21hbGxlciBjb250aW51b3VzIGJsb2NrIHRvIGhvbGQgaG9sZXMuCmRlZmF1bHQgaXMg
MjU2bSwgY291bGQgYmUgc2V0IGFjY29yZGluZyB0byBzaXplIG9mIGdyYXBoaWNzIGNhcmQgbWVt
b3J5LgoKdjI6IGZpeCAtMSBmb3IgVUMgY2hlY2tpbmcKdjM6IGRlZmF1bHQgdG8gZGlzYWJsZSwg
YW5kIG5lZWQgdXNlIGVuYWJsZV9tdHJyX2NsZWFudXAgdG8gZW5hYmxlIHRoaXMgZmVhdHVyZQog
ICAgc2tpcCB0aGUgdmFyIHN0YXRlIGNoYW5nZSB3YXJuaW5nLgogICAgcmVtb3ZlIG5leHRfYmFz
ZWsgaW4gcmFuZ2VfdG9fbXRycigpCnY0OiBjb3JyZWN0IHdhcm5pbmcgbWFzay4KdjU6IENPTkZJ
R19NVFJSX1NBTklUSVpFUgoKU2lnbmVkLW9mZi1ieTogWWluZ2hhaSBMdSA8eWhsdS5rZXJuZWxA
Z21haWwuY29tPgoKSW5kZXg6IGxpbnV4LTIuNi9hcmNoL3g4Ni9rZXJuZWwvY3B1L210cnIvZ2Vu
ZXJpYy5jCj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT0KLS0tIGxpbnV4LTIuNi5vcmlnL2FyY2gveDg2L2tlcm5lbC9jcHUv
bXRyci9nZW5lcmljLmMKKysrIGxpbnV4LTIuNi9hcmNoL3g4Ni9rZXJuZWwvY3B1L210cnIvZ2Vu
ZXJpYy5jCkBAIC0xNTgsNiArMTU4LDIwIEBAIGdldF9tdHJyX3Zhcl9yYW5nZSh1bnNpZ25lZCBp
bnQgaW5kZXgsIHMKIAlyZG1zcihNVFJScGh5c01hc2tfTVNSKGluZGV4KSwgdnItPm1hc2tfbG8s
IHZyLT5tYXNrX2hpKTsKIH0KIAorLyogIGZpbGwgdGhlIE1TUiBwYWlyIHJlbGF0aW5nIHRvIGEg
dmFyIHJhbmdlICAqLwordm9pZCBmaWxsX210cnJfdmFyX3JhbmdlKHVuc2lnbmVkIGludCBpbmRl
eCwKKwkJdTMyIGJhc2VfbG8sIHUzMiBiYXNlX2hpLCB1MzIgbWFza19sbywgdTMyIG1hc2tfaGkp
Cit7CisJc3RydWN0IG10cnJfdmFyX3JhbmdlICp2cjsKKworCXZyID0gbXRycl9zdGF0ZS52YXJf
cmFuZ2VzOworCisJdnJbaW5kZXhdLmJhc2VfbG8gPSBiYXNlX2xvOworCXZyW2luZGV4XS5iYXNl
X2hpID0gYmFzZV9oaTsKKwl2cltpbmRleF0ubWFza19sbyA9IG1hc2tfbG87CisJdnJbaW5kZXhd
Lm1hc2tfaGkgPSBtYXNrX2hpOworfQorCiBzdGF0aWMgdm9pZAogZ2V0X2ZpeGVkX3Jhbmdlcyht
dHJyX3R5cGUgKiBmcnMpCiB7CkluZGV4OiBsaW51eC0yLjYvYXJjaC94ODYva2VybmVsL2NwdS9t
dHJyL21haW4uYwo9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09Ci0tLSBsaW51eC0yLjYub3JpZy9hcmNoL3g4Ni9rZXJuZWwv
Y3B1L210cnIvbWFpbi5jCisrKyBsaW51eC0yLjYvYXJjaC94ODYva2VybmVsL2NwdS9tdHJyL21h
aW4uYwpAQCAtMzcsNiArMzcsNyBAQAogI2luY2x1ZGUgPGxpbnV4L3NtcC5oPgogI2luY2x1ZGUg
PGxpbnV4L2NwdS5oPgogI2luY2x1ZGUgPGxpbnV4L211dGV4Lmg+CisjaW5jbHVkZSA8bGludXgv
c29ydC5oPgogCiAjaW5jbHVkZSA8YXNtL2U4MjAuaD4KICNpbmNsdWRlIDxhc20vbXRyci5oPgpA
QCAtNjA5LDYgKzYxMCwzNjYgQEAgc3RhdGljIHN0cnVjdCBzeXNkZXZfZHJpdmVyIG10cnJfc3lz
ZGV2XwogCS5yZXN1bWUJCT0gbXRycl9yZXN0b3JlLAogfTsKIAorI2lmZGVmIENPTkZJR19NVFJS
X1NBTklUSVpFUgorCisjaWZkZWYgQ09ORklHX01UUlJfU0FOSVRJWkVSX0VOQUJMRV9ERUZBVUxU
CitzdGF0aWMgaW50IGVuYWJsZV9tdHJyX2NsZWFudXAgX19pbml0ZGF0YSA9IDE7CisjZWxzZQor
c3RhdGljIGludCBlbmFibGVfbXRycl9jbGVhbnVwIF9faW5pdGRhdGE7CisjZW5kaWYKKworI2Vs
c2UKKworc3RhdGljIGludCBlbmFibGVfbXRycl9jbGVhbnVwIF9faW5pdGRhdGEgPSAtMTsKKwor
I2VuZGlmCisKK3N0YXRpYyBpbnQgX19pbml0IGRpc2FibGVfbXRycl9jbGVhbnVwX3NldHVwKGNo
YXIgKnN0cikKK3sKKwlpZiAoZW5hYmxlX210cnJfY2xlYW51cCAhPSAtMSkKKwkJZW5hYmxlX210
cnJfY2xlYW51cCA9IDA7CisJcmV0dXJuIDA7Cit9CitlYXJseV9wYXJhbSgiZGlzYWJsZV9tdHJy
X2NsZWFudXAiLCBkaXNhYmxlX210cnJfY2xlYW51cF9zZXR1cCk7CisKK3N0YXRpYyBpbnQgX19p
bml0IGVuYWJsZV9tdHJyX2NsZWFudXBfc2V0dXAoY2hhciAqc3RyKQoreworCWlmIChlbmFibGVf
bXRycl9jbGVhbnVwICE9IC0xKQorCQllbmFibGVfbXRycl9jbGVhbnVwID0gMTsKKwlyZXR1cm4g
MDsKK30KK2Vhcmx5X3BhcmFtKCJlbmJsZV9tdHJyX2NsZWFudXAiLCBlbmFibGVfbXRycl9jbGVh
bnVwX3NldHVwKTsKKworI2RlZmluZSBSQU5HRV9OVU0gMjU2CisKK3N0cnVjdCByZXNfcmFuZ2Ug
eworCXNpemVfdCBzdGFydDsKKwlzaXplX3QgZW5kOworfTsKKworc3RhdGljIHZvaWQgX19pbml0
IHN1YnRyYWN0X3JhbmdlKHN0cnVjdCByZXNfcmFuZ2UgKnJhbmdlLCBzaXplX3Qgc3RhcnQsCisJ
CQkJc2l6ZV90IGVuZCkKK3sKKwlpbnQgaTsKKwlpbnQgajsKKworCWZvciAoaiA9IDA7IGogPCBS
QU5HRV9OVU07IGorKykgeworCQlpZiAoIXJhbmdlW2pdLmVuZCkKKwkJCWNvbnRpbnVlOworCisJ
CWlmIChzdGFydCA8PSByYW5nZVtqXS5zdGFydCAmJiBlbmQgPj0gcmFuZ2Vbal0uZW5kKSB7CisJ
CQlyYW5nZVtqXS5zdGFydCA9IDA7CisJCQlyYW5nZVtqXS5lbmQgPSAwOworCQkJY29udGludWU7
CisJCX0KKworCQlpZiAoc3RhcnQgPD0gcmFuZ2Vbal0uc3RhcnQgJiYgZW5kIDwgcmFuZ2Vbal0u
ZW5kICYmIHJhbmdlW2pdLnN0YXJ0IDwgZW5kICsgMSkgeworCQkJcmFuZ2Vbal0uc3RhcnQgPSBl
bmQgKyAxOworCQkJY29udGludWU7CisJCX0KKworCisJCWlmIChzdGFydCA+IHJhbmdlW2pdLnN0
YXJ0ICYmIGVuZCA+PSByYW5nZVtqXS5lbmQgJiYgcmFuZ2Vbal0uZW5kID4gc3RhcnQgLSAxKSB7
CisJCQlyYW5nZVtqXS5lbmQgPSBzdGFydCAtIDE7CisJCQljb250aW51ZTsKKwkJfQorCisJCWlm
IChzdGFydCA+IHJhbmdlW2pdLnN0YXJ0ICYmIGVuZCA8IHJhbmdlW2pdLmVuZCkgeworCQkJLyog
ZmluZCB0aGUgbmV3IHNwYXJlICovCisJCQlmb3IgKGkgPSAwOyBpIDwgUkFOR0VfTlVNOyBpKysp
IHsKKwkJCQlpZiAocmFuZ2VbaV0uZW5kID09IDApCisJCQkJCWJyZWFrOworCQkJfQorCQkJaWYg
KGkgPCBSQU5HRV9OVU0pIHsKKwkJCQlyYW5nZVtpXS5lbmQgPSByYW5nZVtqXS5lbmQ7CisJCQkJ
cmFuZ2VbaV0uc3RhcnQgPSBlbmQgKyAxOworCQkJfSBlbHNlIHsKKwkJCQlwcmludGsoS0VSTl9F
UlIgInJ1biBvZiBzbG90IGluIHJhbmdlc1xuIik7CisJCQl9CisJCQlyYW5nZVtqXS5lbmQgPSBz
dGFydCAtIDE7CisJCQljb250aW51ZTsKKwkJfQorCX0KK30KKworc3RhdGljIGludCBfX2NwdWlu
aXQgY21wX3JhbmdlKGNvbnN0IHZvaWQgKngxLCBjb25zdCB2b2lkICp4MikKK3sKKwljb25zdCBz
dHJ1Y3QgcmVzX3JhbmdlICpyMSA9IHgxOworCWNvbnN0IHN0cnVjdCByZXNfcmFuZ2UgKnIyID0g
eDI7CisJczY0IHN0YXJ0MSwgc3RhcnQyOworCisJc3RhcnQxID0gcjEtPnN0YXJ0OworCXN0YXJ0
MiA9IHIyLT5zdGFydDsKKworCXJldHVybiBzdGFydDEgLSBzdGFydDI7Cit9CisKK3N0cnVjdCB2
YXJfbXRycl9zdGF0ZSB7CisJdW5zaWduZWQgbG9uZyByYW5nZV9zdGFydGssIHJhbmdlX3NpemVr
OworCXVuc2lnbmVkIGxvbmcgY2h1bmtfc2l6ZWs7CisJdW5zaWduZWQgaW50IHJlZzsKKwl1bnNp
Z25lZCBhZGRyZXNzX2JpdHM7Cit9OworCitzdGF0aWMgdm9pZCBfX2luaXQgc2V0X3Zhcl9tdHJy
KAorCXVuc2lnbmVkIGludCByZWcsIHVuc2lnbmVkIGxvbmcgYmFzZWssIHVuc2lnbmVkIGxvbmcg
c2l6ZWssCisJdW5zaWduZWQgY2hhciB0eXBlLCB1bnNpZ25lZCBhZGRyZXNzX2JpdHMpCit7CisJ
dTMyIGJhc2VfbG8sIGJhc2VfaGksIG1hc2tfbG8sIG1hc2tfaGk7CisJdW5zaWduZWQgYWRkcmVz
c19tYXNrX2hpZ2g7CisKKwlpZiAoIXNpemVrKSB7CisvLwkJZmlsbF9tdHJyX3Zhcl9yYW5nZShy
ZWcsIDAsIDAsIDAsIDApOworCQlyZXR1cm47CisJfQorCisJYWRkcmVzc19tYXNrX2hpZ2ggPSAo
KDF1IDw8IChhZGRyZXNzX2JpdHMgLSAzMnUpKSAtIDF1KTsKKworCWJhc2VfaGkgPSBiYXNlayA+
PiAyMjsKKwliYXNlX2xvICA9IGJhc2VrIDw8IDEwOworCisJaWYgKHNpemVrIDwgNCoxMDI0KjEw
MjQpIHsKKwkJbWFza19oaSA9IGFkZHJlc3NfbWFza19oaWdoOworCQltYXNrX2xvID0gfigoc2l6
ZWsgPDwgMTApIC0gMSk7CisJfSBlbHNlIHsKKwkJbWFza19oaSA9IGFkZHJlc3NfbWFza19oaWdo
ICYgKH4oKHNpemVrID4+IDIyKSAtIDEpKTsKKwkJbWFza19sbyA9IDA7CisJfQorCisJYmFzZV9s
byB8PSB0eXBlOworCW1hc2tfbG8gfD0gMHg4MDA7CisvLwlmaWxsX210cnJfdmFyX3JhbmdlKHJl
ZywgYmFzZV9sbywgYmFzZV9oaSwgbWFza19sbywgbWFza19oaSk7Cit9CisKK3N0YXRpYyB1bnNp
Z25lZCBpbnQgX19pbml0IHJhbmdlX3RvX210cnIodW5zaWduZWQgaW50IHJlZywKKwl1bnNpZ25l
ZCBsb25nIHJhbmdlX3N0YXJ0aywgdW5zaWduZWQgbG9uZyByYW5nZV9zaXplaywKKwl1bnNpZ25l
ZCBjaGFyIHR5cGUsIHVuc2lnbmVkIGFkZHJlc3NfYml0cykKK3sKKwlpZiAoIXJhbmdlX3NpemVr
IHx8IChyZWcgPj0gbnVtX3Zhcl9yYW5nZXMpKQorCQlyZXR1cm4gcmVnOworCisJd2hpbGUgKHJh
bmdlX3NpemVrKSB7CisJCXVuc2lnbmVkIGxvbmcgbWF4X2FsaWduLCBhbGlnbjsKKwkJdW5zaWdu
ZWQgbG9uZyBzaXplazsKKwkJLyogQ29tcHV0ZSB0aGUgbWF4aW11bSBzaXplIEkgY2FuIG1ha2Ug
YSByYW5nZSAqLworCQlpZiAocmFuZ2Vfc3RhcnRrKQorCQkJbWF4X2FsaWduID0gZmZzKHJhbmdl
X3N0YXJ0aykgLSAxOworCQllbHNlCisJCQltYXhfYWxpZ24gPSAzMjsKKwkJYWxpZ24gPSBmbHMo
cmFuZ2Vfc2l6ZWspIC0gMTsKKwkJaWYgKGFsaWduID4gbWF4X2FsaWduKQorCQkJYWxpZ24gPSBt
YXhfYWxpZ247CisKKwkJc2l6ZWsgPSAxIDw8IGFsaWduOworCQlwcmludGsoS0VSTl9JTkZPICJT
ZXR0aW5nIHZhcmlhYmxlIE1UUlIgJWQsIGJhc2U6ICVsZE1CLCByYW5nZTogJWxkTUIsIHR5cGUg
JXNcbiIsCisJCQlyZWcsIHJhbmdlX3N0YXJ0ayA+PiAxMCwgc2l6ZWsgPj4gMTAsCisJCQkodHlw
ZSA9PSBNVFJSX1RZUEVfVU5DQUNIQUJMRSk/IlVDIjoKKwkJCSAgICAoKHR5cGUgPT0gTVRSUl9U
WVBFX1dSQkFDSyk/IldCIjoiT3RoZXIiKQorCQkJKTsKKwkJc2V0X3Zhcl9tdHJyKHJlZysrLCBy
YW5nZV9zdGFydGssIHNpemVrLCB0eXBlLCBhZGRyZXNzX2JpdHMpOworCQlyYW5nZV9zdGFydGsg
Kz0gc2l6ZWs7CisJCXJhbmdlX3NpemVrIC09IHNpemVrOworCQlpZiAocmVnID49IG51bV92YXJf
cmFuZ2VzKQorCQkJYnJlYWs7CisJfQorCXJldHVybiByZWc7Cit9CisKK3N0YXRpYyB2b2lkIF9f
aW5pdCByYW5nZV90b19tdHJyX3dpdGhfaG9sZShzdHJ1Y3QgdmFyX210cnJfc3RhdGUgKnN0YXRl
LCB1bnNpZ25lZCBsb25nIGJhc2VrKQoreworCXVuc2lnbmVkIGxvbmcgaG9sZV9iYXNlaywgaG9s
ZV9zaXplazsKKwl1bnNpZ25lZCBsb25nIHJhbmdlMF9iYXNlaywgcmFuZ2UwX3NpemVrOworCXVu
c2lnbmVkIGxvbmcgcmFuZ2VfYmFzZWssIHJhbmdlX3NpemVrOworCXVuc2lnbmVkIGxvbmcgY2h1
bmtfc2l6ZWs7CisKKwlob2xlX2Jhc2VrID0gMDsKKwlob2xlX3NpemVrID0gMDsKKwljaHVua19z
aXplayA9IHN0YXRlLT5jaHVua19zaXplazsKKwlyYW5nZTBfYmFzZWsgPSBzdGF0ZS0+cmFuZ2Vf
c3RhcnRrOworCisJLyogdHJ5IHRvIGFwcGVuZCBzb21lIHNtYWxsIGhvbGUgKi8KKwlyYW5nZTBf
c2l6ZWsgPSBBTElHTihzdGF0ZS0+cmFuZ2Vfc2l6ZWssIGNodW5rX3NpemVrKTsKKwlpZiAoKHJh
bmdlMF9zaXplayA9PSBzdGF0ZS0+cmFuZ2Vfc2l6ZWspIHx8CisJCSgocmFuZ2UwX2Jhc2VrICsg
cmFuZ2UwX3NpemVrID4gYmFzZWspICYmIGJhc2VrKSkgeworCQkJcHJpbnRrKEtFUk5fSU5GTyAi
cmFuZ2VYOiAlMDE2bHggLSAlMDE2bHhcbiIsIHJhbmdlMF9iYXNlazw8MTAsIChyYW5nZTBfYmFz
ZWsgKyByYW5nZTBfc2l6ZWspPDwxMCk7CisJCQlzdGF0ZS0+cmVnID0gcmFuZ2VfdG9fbXRycihz
dGF0ZS0+cmVnLCByYW5nZTBfYmFzZWssCisJCQkJcmFuZ2UwX3NpemVrLCBNVFJSX1RZUEVfV1JC
QUNLLCBzdGF0ZS0+YWRkcmVzc19iaXRzKTsKKwkJcmV0dXJuOworCX0KKworCXJhbmdlMF9zaXpl
ayAtPSBjaHVua19zaXplazsKKwlyYW5nZV9iYXNlayA9IHJhbmdlMF9iYXNlayArIHJhbmdlMF9z
aXplazsKKwlwcmludGsoS0VSTl9JTkZPICJyYW5nZTA6ICUwMTZseCAtICUwMTZseFxuIiwgcmFu
Z2UwX2Jhc2VrPDwxMCwgKHJhbmdlMF9iYXNlayArIHJhbmdlMF9zaXplayk8PDEwKTsKKwlzdGF0
ZS0+cmVnID0gcmFuZ2VfdG9fbXRycihzdGF0ZS0+cmVnLCByYW5nZTBfYmFzZWssCisJCQlyYW5n
ZTBfc2l6ZWssIE1UUlJfVFlQRV9XUkJBQ0ssIHN0YXRlLT5hZGRyZXNzX2JpdHMpOworCisJcmFu
Z2Vfc2l6ZWsgPSBjaHVua19zaXplazsKKwlpZiAocmFuZ2Vfc2l6ZWsgLSAoc3RhdGUtPnJhbmdl
X3NpemVrIC0gcmFuZ2UwX3NpemVrKSA8IChjaHVua19zaXplayA+PiAxKSkKKwkJaG9sZV9zaXpl
ayA9IHJhbmdlX3NpemVrIC0gKHN0YXRlLT5yYW5nZV9zaXplayAtIHJhbmdlMF9zaXplayk7CisJ
ZWxzZQorCQlyYW5nZV9zaXplayA9IHN0YXRlLT5yYW5nZV9zaXplayAtIHJhbmdlMF9zaXplazsK
KworCXByaW50ayhLRVJOX0lORk8gInJhbmdlOiAlMDE2bHggLSAlMDE2bHhcbiIsIHJhbmdlX2Jh
c2VrPDwxMCwgKHJhbmdlX2Jhc2VrICsgcmFuZ2Vfc2l6ZWspPDwxMCk7CisJc3RhdGUtPnJlZyA9
IHJhbmdlX3RvX210cnIoc3RhdGUtPnJlZywgcmFuZ2VfYmFzZWssCisJCQlyYW5nZV9zaXplaywg
TVRSUl9UWVBFX1dSQkFDSywgc3RhdGUtPmFkZHJlc3NfYml0cyk7CisJaWYgKGhvbGVfc2l6ZWsp
IHsKKwkJcHJpbnRrKEtFUk5fSU5GTyAiaG9sZTogJTAxNmx4IC0gJTAxNmx4XG4iLCBob2xlX2Jh
c2VrPDwxMCwgKGhvbGVfYmFzZWsgKyBob2xlX3NpemVrKTw8MTApOworCQlzdGF0ZS0+cmVnID0g
cmFuZ2VfdG9fbXRycihzdGF0ZS0+cmVnLCBob2xlX2Jhc2VrLAorCQkJCWhvbGVfc2l6ZWssIE1U
UlJfVFlQRV9VTkNBQ0hBQkxFLCBzdGF0ZS0+YWRkcmVzc19iaXRzKTsKKwl9Cit9CisKK3N0YXRp
YyB2b2lkIF9faW5pdCBzZXRfdmFyX210cnJfcmFuZ2Uoc3RydWN0IHZhcl9tdHJyX3N0YXRlICpz
dGF0ZSwgc2l6ZV90IGJhc2VfcGZuLCBzaXplX3Qgc2l6ZV9wZm4pCit7CisJdW5zaWduZWQgbG9u
ZyBiYXNlaywgc2l6ZWs7CisKKwlpZiAoc3RhdGUtPnJlZyA+PSBudW1fdmFyX3JhbmdlcykKKwkJ
cmV0dXJuOworCisJYmFzZWsgPSBiYXNlX3BmbiA8PCAoUEFHRV9TSElGVCAtIDEwKTsKKwlzaXpl
ayA9IHNpemVfcGZuIDw8IChQQUdFX1NISUZUIC0gMTApOworCisJLyogU2VlIGlmIEkgY2FuIG1l
cmdlIHdpdGggdGhlIGxhc3QgcmFuZ2UgKi8KKwlpZiAoKGJhc2VrIDw9IDEwMjQpIHx8IChzdGF0
ZS0+cmFuZ2Vfc3RhcnRrICsgc3RhdGUtPnJhbmdlX3NpemVrID09IGJhc2VrKSkgeworCQl1bnNp
Z25lZCBsb25nIGVuZGsgPSBiYXNlayArIHNpemVrOworCQlzdGF0ZS0+cmFuZ2Vfc2l6ZWsgPSBl
bmRrIC0gc3RhdGUtPnJhbmdlX3N0YXJ0azsKKwkJcmV0dXJuOworCX0KKwkvKiBXcml0ZSB0aGUg
cmFuZ2UgbXRycnMgKi8KKwlpZiAoc3RhdGUtPnJhbmdlX3NpemVrICE9IDApIHsKKwkJcmFuZ2Vf
dG9fbXRycl93aXRoX2hvbGUoc3RhdGUsIGJhc2VrKTsKKworCQlzdGF0ZS0+cmFuZ2Vfc3RhcnRr
ID0gMDsKKwkJc3RhdGUtPnJhbmdlX3NpemVrID0gMDsKKwl9CisJLyogQWxsb2NhdGUgYW4gbXNy
ICovCisJc3RhdGUtPnJhbmdlX3N0YXJ0ayA9IGJhc2VrOworCXN0YXRlLT5yYW5nZV9zaXplayAg
PSBzaXplazsKK30KKworc3RhdGljIHU2NCBtdHJyX2NodW5rX3NpemUgX19pbml0ZGF0YSA9ICgy
NTZVTEw8PDIwKTsKKworc3RhdGljIGludCBfX2luaXQgcGFyc2VfbXRycl9jaHVua19zaXplX29w
dChjaGFyICpwKQoreworCWlmICghcCkKKwkJcmV0dXJuIC1FSU5WQUw7CisJbXRycl9jaHVua19z
aXplID0gbWVtcGFyc2UocCwgJnApOworCXJldHVybiAwOworfQorZWFybHlfcGFyYW0oIm10cnJf
Y2h1bmtfc2l6ZSIsIHBhcnNlX210cnJfY2h1bmtfc2l6ZV9vcHQpOworCitzdGF0aWMgdm9pZCBf
X2luaXQgeDg2X3NldHVwX3Zhcl9tdHJycyhzdHJ1Y3QgcmVzX3JhbmdlICpyYW5nZSwgaW50IG5y
X3JhbmdlLCB1bnNpZ25lZCBhZGRyZXNzX2JpdHMpCit7CisJc3RydWN0IHZhcl9tdHJyX3N0YXRl
IHZhcl9zdGF0ZTsKKwlpbnQgaTsKKworCXZhcl9zdGF0ZS5yYW5nZV9zdGFydGsgPSAwOworCXZh
cl9zdGF0ZS5yYW5nZV9zaXplayA9IDA7CisJdmFyX3N0YXRlLnJlZyA9IDA7CisJdmFyX3N0YXRl
LmFkZHJlc3NfYml0cyA9IGFkZHJlc3NfYml0czsKKwl2YXJfc3RhdGUuY2h1bmtfc2l6ZWsgPSBt
dHJyX2NodW5rX3NpemUgPj4gMTA7CisKKwkvKiBXcml0ZSB0aGUgcmFuZ2UgZXRjICovCisJZm9y
IChpID0gMDsgaSA8IG5yX3JhbmdlOyBpKyspCisJCXNldF92YXJfbXRycl9yYW5nZSgmdmFyX3N0
YXRlLCByYW5nZVtpXS5zdGFydCwgcmFuZ2VbaV0uZW5kIC0gcmFuZ2VbaV0uc3RhcnQgKyAxKTsK
KworCS8qIFdyaXRlIHRoZSBsYXN0IHJhbmdlICovCisJcmFuZ2VfdG9fbXRycl93aXRoX2hvbGUo
JnZhcl9zdGF0ZSwgMCk7CisJcHJpbnRrKEtFUk5fSU5GTyAiRE9ORSB2YXJpYWJsZSBNVFJSc1xu
Iik7CisJLyogQ2xlYXIgb3V0IHRoZSBleHRyYSBNVFJSJ3MgKi8KKwl3aGlsZSAodmFyX3N0YXRl
LnJlZyA8IG51bV92YXJfcmFuZ2VzKQorCQlzZXRfdmFyX210cnIodmFyX3N0YXRlLnJlZysrLCAw
LCAwLCAwLCB2YXJfc3RhdGUuYWRkcmVzc19iaXRzKTsKK30KKworc3RhdGljIGludCBfX2luaXQg
bXRycl9jbGVhbnVwKHVuc2lnbmVkIGFkZHJlc3NfYml0cykKK3sKKwl1bnNpZ25lZCBsb25nIGks
IGJhc2UsIHNpemUsIGRlZiwgZHVtbXk7CisJbXRycl90eXBlIHR5cGU7CisJc3RydWN0IHJlc19y
YW5nZSByYW5nZVtSQU5HRV9OVU1dOworCWludCBucl9yYW5nZTsKKworCS8qIGV4dHJhIG9uZSBm
b3IgYWxsIDAgKi8KKwlpbnQgbnVtW01UUlJfTlVNX1RZUEVTICsgMV07CisKKwlpZiAoIWlzX2Nw
dShJTlRFTCkgfHwgZW5hYmxlX210cnJfY2xlYW51cCA8IDEpCisJCXJldHVybiAwOworCXJkbXNy
KE1UUlJkZWZUeXBlX01TUiwgZGVmLCBkdW1teSk7CisJZGVmICY9IDB4ZmY7CisJaWYgKGRlZiAh
PSBNVFJSX1RZUEVfVU5DQUNIQUJMRSkKKwkJcmV0dXJuIDA7CisKKwkvKiBjaGVjayBlbnRyaWVz
IG51bWJlciAqLworCW1lbXNldChudW0sIDAsIHNpemVvZihudW0pKTsKKwlmb3IgKGkgPSAwOyBp
IDwgbnVtX3Zhcl9yYW5nZXM7IGkrKykgeworCQltdHJyX2lmLT5nZXQoaSwgJmJhc2UsICZzaXpl
LCAmdHlwZSk7CisJCWlmICh0eXBlID49IE1UUlJfTlVNX1RZUEVTKQorCQkJY29udGludWU7CisJ
CWlmICghc2l6ZSkKKwkJCXR5cGUgPSBNVFJSX05VTV9UWVBFUzsKKwkJbnVtW3R5cGVdKys7CisJ
fQorCisJLyogY2hlY2sgaWYgd2UgZ290IFVDIGVudHJpZXMgKi8KKwlpZiAoIW51bVtNVFJSX1RZ
UEVfVU5DQUNIQUJMRV0pCisJCXJldHVybiAwOworCisJLyogY2hlY2sgaWYgd2Ugb25seSBoYWQg
V0IgYW5kIFVDICovCisJaWYgKG51bVtNVFJSX1RZUEVfV1JCQUNLXSArIG51bVtNVFJSX1RZUEVf
VU5DQUNIQUJMRV0gIT0KKwkJbnVtX3Zhcl9yYW5nZXMgLSBudW1bTVRSUl9OVU1fVFlQRVNdKQor
CQlyZXR1cm4gMDsKKworCS8qCisJICogZ2V0IFdCIHJhbmdlcyBhdCBmaXJzdAorCSAqIGFzc3Vt
ZSBCSU9TIGRvbid0IGdpdmUgdXMgb3ZlcmxhcHBpbmcgV0IgZW50cmllcworCSAqIG9yIGFkZCBh
ZGRfcmFuZ2U/CisJICovCisJbWVtc2V0KHJhbmdlLCAwLCBzaXplb2YocmFuZ2UpKTsKKwlucl9y
YW5nZSA9IDA7CisJZm9yIChpID0gMDsgaSA8IG51bV92YXJfcmFuZ2VzOyBpKyspIHsKKwkJbXRy
cl9pZi0+Z2V0KGksICZiYXNlLCAmc2l6ZSwgJnR5cGUpOworCQlpZiAodHlwZSAhPSBNVFJSX1RZ
UEVfV1JCQUNLKQorCQkJY29udGludWU7CisJCXJhbmdlW25yX3JhbmdlXS5zdGFydCA9IGJhc2U7
CisJCXJhbmdlW25yX3JhbmdlXS5lbmQgPSBiYXNlICsgc2l6ZSAtIDE7CisJCW5yX3JhbmdlKys7
CisJfQorCXByaW50ayhLRVJOX0lORk8gIkFmdGVyIFdCIGNoZWNraW5nXG4iKTsKKwlmb3IgKGkg
PSAwOyBpIDwgbnJfcmFuZ2U7IGkrKykKKwkJcHJpbnRrKEtFUk5fSU5GTyAiTVRSUiBNQVAgUEZO
OiAlMDE2bHggLSAlMDE2bHhcbiIsIHJhbmdlW2ldLnN0YXJ0LCByYW5nZVtpXS5lbmQgKyAxKTsK
KworCS8qIHRha2Ugb3V0IFVDIHJhbmdlcyAqLworCWZvciAoaSA9IDA7IGkgPCBudW1fdmFyX3Jh
bmdlczsgaSsrKSB7CisJCW10cnJfaWYtPmdldChpLCAmYmFzZSwgJnNpemUsICZ0eXBlKTsKKwkJ
aWYgKHR5cGUgIT0gTVRSUl9UWVBFX1VOQ0FDSEFCTEUpCisJCQljb250aW51ZTsKKwkJaWYgKCFz
aXplKQorCQkJY29udGludWU7CisJCXN1YnRyYWN0X3JhbmdlKHJhbmdlLCBiYXNlLCBiYXNlICsg
c2l6ZSAtIDEpOworCX0KKwkvKiBnZXQgbmV3IHJhbmdlIG51bSAqLworCW5yX3JhbmdlID0gMDsK
Kwlmb3IgKGkgPSAwOyBpIDwgUkFOR0VfTlVNOyBpKyspIHsKKwkJaWYgKCFyYW5nZVtpXS5lbmQp
CisJCQljb250aW51ZTsKKwkJbnJfcmFuZ2UrKzsKKwl9CisJcHJpbnRrKEtFUk5fSU5GTyAiQWZ0
ZXIgVUMgY2hlY2tpbmdcbiIpOworCWZvciAoaSA9IDA7IGkgPCBucl9yYW5nZTsgaSsrKQorCQlw
cmludGsoS0VSTl9JTkZPICJNVFJSIE1BUCBQRk46ICUwMTZseCAtICUwMTZseFxuIiwgcmFuZ2Vb
aV0uc3RhcnQsIHJhbmdlW2ldLmVuZCArIDEpOworCisJLyogc29ydCB0aGUgcmFuZ2VzICovCisJ
c29ydChyYW5nZSwgbnJfcmFuZ2UsIHNpemVvZihzdHJ1Y3QgcmVzX3JhbmdlKSwgY21wX3Jhbmdl
LCBOVUxMKTsKKwlwcmludGsoS0VSTl9JTkZPICJBZnRlciBzb3J0aW5nXG4iKTsKKwlmb3IgKGkg
PSAwOyBpIDwgbnJfcmFuZ2U7IGkrKykKKwkJcHJpbnRrKEtFUk5fSU5GTyAiTVRSUiBNQVAgUEZO
OiAlMDE2bHggLSAlMDE2bHhcbiIsIHJhbmdlW2ldLnN0YXJ0LCByYW5nZVtpXS5lbmQgKyAxKTsK
KworCS8qIGNvbnZlcnQgcmFuZ2VzIHRvIHZhciByYW5nZXMgc3RhdGUgKi8KKwl4ODZfc2V0dXBf
dmFyX210cnJzKHJhbmdlLCBucl9yYW5nZSwgYWRkcmVzc19iaXRzKTsKKworCXJldHVybiAxOwor
Cit9CisKIHN0YXRpYyBpbnQgZGlzYWJsZV9tdHJyX3RyaW07CiAKIHN0YXRpYyBpbnQgX19pbml0
IGRpc2FibGVfbXRycl90cmltX3NldHVwKGNoYXIgKnN0cikKQEAgLTcyOSwxOCArMTA5MCwyMSBA
QCBpbnQgX19pbml0IG10cnJfdHJpbV91bmNhY2hlZF9tZW1vcnkodW5zCiAgKi8KIHZvaWQgX19p
bml0IG10cnJfYnBfaW5pdCh2b2lkKQogeworCXUzMiBwaHlzX2FkZHI7CiAJaW5pdF9pZnMoKTsK
IAorCXBoeXNfYWRkciA9IDMyOworCiAJaWYgKGNwdV9oYXNfbXRycikgewogCQltdHJyX2lmID0g
JmdlbmVyaWNfbXRycl9vcHM7CiAJCXNpemVfb3JfbWFzayA9IDB4ZmYwMDAwMDA7CS8qIDM2IGJp
dHMgKi8KIAkJc2l6ZV9hbmRfbWFzayA9IDB4MDBmMDAwMDA7CisJCXBoeXNfYWRkciA9IDM2Owog
CiAJCS8qIFRoaXMgaXMgYW4gQU1EIHNwZWNpZmljIE1TUiwgYnV0IHdlIGFzc3VtZShob3BlPykg
dGhhdAogCQkgICBJbnRlbCB3aWxsIGltcGxlbWVudCBpdCB0byB3aGVuIHRoZXkgZXh0ZW5kIHRo
ZSBhZGRyZXNzCiAJCSAgIGJ1cyBvZiB0aGUgWGVvbi4gKi8KIAkJaWYgKGNwdWlkX2VheCgweDgw
MDAwMDAwKSA+PSAweDgwMDAwMDA4KSB7Ci0JCQl1MzIgcGh5c19hZGRyOwogCQkJcGh5c19hZGRy
ID0gY3B1aWRfZWF4KDB4ODAwMDAwMDgpICYgMHhmZjsKIAkJCS8qIENQVUlEIHdvcmthcm91bmQg
Zm9yIEludGVsIDBGMzMvMEYzNCBDUFUgKi8KIAkJCWlmIChib290X2NwdV9kYXRhLng4Nl92ZW5k
b3IgPT0gWDg2X1ZFTkRPUl9JTlRFTCAmJgpAQCAtNzU4LDYgKzExMjIsNyBAQCB2b2lkIF9faW5p
dCBtdHJyX2JwX2luaXQodm9pZCkKIAkJCSAgIGRvbid0IHN1cHBvcnQgUEFFICovCiAJCQlzaXpl
X29yX21hc2sgPSAweGZmZjAwMDAwOwkvKiAzMiBiaXRzICovCiAJCQlzaXplX2FuZF9tYXNrID0g
MDsKKwkJCXBoeXNfYWRkciA9IDMyOwogCQl9CiAJfSBlbHNlIHsKIAkJc3dpdGNoIChib290X2Nw
dV9kYXRhLng4Nl92ZW5kb3IpIHsKQEAgLTc5MSw4ICsxMTU2LDEzIEBAIHZvaWQgX19pbml0IG10
cnJfYnBfaW5pdCh2b2lkKQogCWlmIChtdHJyX2lmKSB7CiAJCXNldF9udW1fdmFyX3Jhbmdlcygp
OwogCQlpbml0X3RhYmxlKCk7Ci0JCWlmICh1c2VfaW50ZWwoKSkKKwkJaWYgKHVzZV9pbnRlbCgp
KSB7CiAJCQlnZXRfbXRycl9zdGF0ZSgpOworCisJCQlpZiAobXRycl9jbGVhbnVwKHBoeXNfYWRk
cikpCisJCQkJbXRycl9pZi0+c2V0X2FsbCgpOworCisJCX0KIAl9CiB9CiAKQEAgLTgyOSw5ICsx
MTk5LDEwIEBAIHN0YXRpYyBpbnQgX19pbml0IG10cnJfaW5pdF9maW5pYWxpemUodm8KIHsKIAlp
ZiAoIW10cnJfaWYpCiAJCXJldHVybiAwOwotCWlmICh1c2VfaW50ZWwoKSkKLQkJbXRycl9zdGF0
ZV93YXJuKCk7Ci0JZWxzZSB7CisJaWYgKHVzZV9pbnRlbCgpKSB7CisJCWlmIChlbmFibGVfbXRy
cl9jbGVhbnVwIDwgMSkKKwkJCW10cnJfc3RhdGVfd2FybigpOworCX0gZWxzZSB7CiAJCS8qIFRo
ZSBDUFVzIGhhdmVuJ3QgTVRSUiBhbmQgc2VlbSB0byBub3Qgc3VwcG9ydCBTTVAuIFRoZXkgaGF2
ZQogCQkgKiBzcGVjaWZpYyBkcml2ZXJzLCB3ZSB1c2UgYSB0cmlja3kgbWV0aG9kIHRvIHN1cHBv
cnQKIAkJICogc3VzcGVuZC9yZXN1bWUgZm9yIHRoZW0uCkluZGV4OiBsaW51eC0yLjYvYXJjaC94
ODYva2VybmVsL2NwdS9tdHJyL210cnIuaAo9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09Ci0tLSBsaW51eC0yLjYub3JpZy9h
cmNoL3g4Ni9rZXJuZWwvY3B1L210cnIvbXRyci5oCisrKyBsaW51eC0yLjYvYXJjaC94ODYva2Vy
bmVsL2NwdS9tdHJyL210cnIuaApAQCAtODEsNiArODEsOCBAQCB2b2lkIHNldF9tdHJyX2RvbmUo
c3RydWN0IHNldF9tdHJyX2NvbnRlCiB2b2lkIHNldF9tdHJyX2NhY2hlX2Rpc2FibGUoc3RydWN0
IHNldF9tdHJyX2NvbnRleHQgKmN0eHQpOwogdm9pZCBzZXRfbXRycl9wcmVwYXJlX3NhdmUoc3Ry
dWN0IHNldF9tdHJyX2NvbnRleHQgKmN0eHQpOwogCit2b2lkIGZpbGxfbXRycl92YXJfcmFuZ2Uo
dW5zaWduZWQgaW50IGluZGV4LAorCQl1MzIgYmFzZV9sbywgdTMyIGJhc2VfaGksIHUzMiBtYXNr
X2xvLCB1MzIgbWFza19oaSk7CiB2b2lkIGdldF9tdHJyX3N0YXRlKHZvaWQpOwogCiBleHRlcm4g
dm9pZCBzZXRfbXRycl9vcHMoc3RydWN0IG10cnJfb3BzICogb3BzKTsKSW5kZXg6IGxpbnV4LTIu
Ni9Eb2N1bWVudGF0aW9uL2tlcm5lbC1wYXJhbWV0ZXJzLnR4dAo9PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09Ci0tLSBsaW51
eC0yLjYub3JpZy9Eb2N1bWVudGF0aW9uL2tlcm5lbC1wYXJhbWV0ZXJzLnR4dAorKysgbGludXgt
Mi42L0RvY3VtZW50YXRpb24va2VybmVsLXBhcmFtZXRlcnMudHh0CkBAIC01OTUsNiArNTk1LDE2
IEBAIGFuZCBpcyBiZXR3ZWVuIDI1NiBhbmQgNDA5NiBjaGFyYWN0ZXJzLiAKIAkJCVNlZSBkcml2
ZXJzL2NoYXIvUkVBRE1FLmVwY2EgYW5kCiAJCQlEb2N1bWVudGF0aW9uL2RpZ2llcGNhLnR4dC4K
IAorCWRpc2FibGVfbXRycl9jbGVhbnVwIFtYODZdCisJZW5hYmxlX210cnJfY2xlYW51cCBbWDg2
XQorCQkJVGhlIGtlcm5lbCB0cmllcyB0byBhZGp1c3QgTVRSUiBsYXlvdXQgZnJvbSBjb250aW51
b3VzCisJCQl0byBkaXNjcmV0ZSwgdG8gbWFrZSBYIHNlcnZlciBkcml2ZXIgYWJsZSB0byBhZGQg
V0IKKwkJCWVudHJ5IGxhdGVyLiBUaGlzIHBhcmFtZXRlciBlbmFibGVzL2Rpc2FibGVzIHRoYXQu
CisKKwltdHJyX2NodW5rX3NpemU9bm5bS01HXSBbWDg2XQorCQkJdXNlZCBmb3IgbXRyciBjbGVh
bnVwLiBJdCBpcyBsYXJnZXN0IGNvbnRpbm91cyBjaHVuaworCQkJdGhhdCBjb3VsZCBob2xkIGhv
bGVzIGFrYS4gVUMgZW50cmllcy4KKwogCWRpc2FibGVfbXRycl90cmltIFtYODYsIEludGVsIGFu
ZCBBTUQgb25seV0KIAkJCUJ5IGRlZmF1bHQgdGhlIGtlcm5lbCB3aWxsIHRyaW0gYW55IHVuY2Fj
aGVhYmxlCiAJCQltZW1vcnkgb3V0IG9mIHlvdXIgYXZhaWxhYmxlIG1lbW9yeSBwb29sIGJhc2Vk
IG9uCkluZGV4OiBsaW51eC0yLjYvYXJjaC94ODYvS2NvbmZpZwo9PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09Ci0tLSBsaW51
eC0yLjYub3JpZy9hcmNoL3g4Ni9LY29uZmlnCisrKyBsaW51eC0yLjYvYXJjaC94ODYvS2NvbmZp
ZwpAQCAtMTAzNSw2ICsxMDM1LDMyIEBAIGNvbmZpZyBNVFJSCiAKIAkgIFNlZSA8ZmlsZTpEb2N1
bWVudGF0aW9uL210cnIudHh0PiBmb3IgbW9yZSBpbmZvcm1hdGlvbi4KIAorY29uZmlnIE1UUlJf
U0FOSVRJWkVSCisJZGVmX2Jvb2wgeQorCXByb21wdCAiTVRSUiBjbGVhbnVwIHN1cHBvcnQiCisJ
ZGVwZW5kcyBvbiBNVFJSCisJaGVscAorCSAgQ29udmVydCBNVFJSIGxheW91dCBmcm9tIGNvbnRp
bnVvdXMgdG8gZGlzY3JldGUsIHNvIHNvbWUgWCBkcml2ZXIKKwkgIGNvdWxkIGFkZCBXQiBlbnRy
aWVzLgorCisJICBTYXkgTiBoZXJlIGlmIHlvdSBzZWUgYm9vdHVwIHByb2JsZW1zIChib290IGNy
YXNoLCBib290IGhhbmcsCisJICBzcG9udGFuZW91cyByZWJvb3RzKS4KKworCSAgQ291bGQgYmUg
ZGlzYWJsZWQgd2l0aCBkaXNhYmxlX210cnJfY2xlYW51cC4gQWxzbyBtdHJyX2NodW5rX3NpemUK
KwkgIGNvdWxkIGJlIHVzZWQgdG8gc2VuZCBsYXJnZXN0IG10cnIgZW50cnkgc2l6ZSBmb3IgY29u
dGludW91cyBibG9jaworCSAgdG8gaG9sZCBob2xlcyAoYWthLiBVQyBlbnRyaWVzKQorCisJICBJ
ZiB1bnN1cmUsIHNheSBZLgorCitjb25maWcgTVRSUl9TQU5JVElaRVJfRU5BQkxFX0RFRkFVTFQK
KwlkZWZfYm9vbCB5CisJcHJvbXB0ICJFbmFibGUgTVRSUiBjbGVhbnVwIGJ5IGRlZmF1bHQiCisJ
ZGVwZW5kcyBvbiBNVFJSX1NBTklUSVpFUgorCWhlbHAKKwkgIEVuYWJsZSBtdHJyIGNsZWFudXAg
YnkgZGVmYXVsdAorCisJICBJZiB1bnN1cmUsIHNheSBZLgorCiBjb25maWcgWDg2X1BBVAogCWJv
b2wKIAlwcm9tcHQgIng4NiBQQVQgc3VwcG9ydCIK
------=_Part_6517_3252770.1209424986215--
