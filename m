Return-Path: <linux-kernel-owner+w=401wt.eu-S1754554AbYHUBtl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554AbYHUBtl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 21:49:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750819AbYHUBtQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 21:49:16 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:3909 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923AbYHUBtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 21:49:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:references;
        b=ZruXlOjngcuRIvjycQl1j0cWYowZAvaxnVQiCWdEmsBEe6KsUyiVnLokCwr1V8+yTt
         vXpkhvTG8kGTZWBggKcQfneKAWpSBFZ4WpPbPAA1u/wizJ0uAO1/g5nK0b3/qHOTP6Hz
         l7SGohRrL+TQuEiovCRv5MNbs+4Kc1BEgnltE=
Message-ID: <86802c440808201849k6665c395x5a5b871eca55addd@mail.gmail.com>
Date: Wed, 20 Aug 2008 18:49:11 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [Bug 11388] New: 2.6.27-rc3 warns about MTRR range; only 3 of 16gb of memory is usable
Cc: bugme-daemon@bugzilla.kernel.org, linux-kernel@vger.kernel.org,
       j_kernel@hoblitt.com
In-Reply-To: <86802c440808201820w6c684a10y2f1d0f70a344a14a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_16372_22785823.1219283351781"
References: <bug-11388-27@http.bugzilla.kernel.org/>
	 <20080820180405.7f164450.akpm@linux-foundation.org>
	 <86802c440808201820w6c684a10y2f1d0f70a344a14a@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_16372_22785823.1219283351781
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Wed, Aug 20, 2008 at 6:20 PM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> On Wed, Aug 20, 2008 at 6:04 PM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
>>
>> (switched to email.  Please respond via emailed reply-to-all, not via the
>> bugzilla web interface).
>>
>> On Wed, 20 Aug 2008 17:38:59 -0700 (PDT)
>> bugme-daemon@bugzilla.kernel.org wrote:
>>
>>> http://bugzilla.kernel.org/show_bug.cgi?id=11388
>>>
>>>            Summary: 2.6.27-rc3 warns about MTRR range; only 3 of 16gb of
>>>                     memory is usable
>>>            Product: Memory Management
>>>            Version: 2.5
>>>      KernelVersion: 2.6.27-rc3
>>>           Platform: All
>>>         OS/Version: Linux
>>>               Tree: Mainline
>>>             Status: NEW
>>>           Severity: normal
>>>           Priority: P1
>>>          Component: MTTR
>>>         AssignedTo: akpm@osdl.org
>>>         ReportedBy: j_kernel@hoblitt.com
>>>
>>>
>>> Latest working kernel version: 2.4.24.2 (possibly later)
>>> Earliest failing kernel version: 2.6.27-rc3-21328-ga7f5aaf (from netdev-2.6)
>>> Distribution: Gentoo
>>> Hardware Environment: 2x Intel X5482
>>> Software Environment:
>>> Problem Description:
>>>
>>> [    0.000000] WARNING: BIOS bug: CPU MTRRs don't cover all of memory, losing
>>> 13056MB of RAM.
>>> [    0.000000] ------------[ cut here ]------------
>>> [    0.000000] WARNING: at arch/x86/kernel/cpu/mtrr/main.c:1561
>>> mtrr_trim_uncached_memory+0x508/0x550()
>>> [    0.000000] Modules linked in:
>>> [    0.000000] Pid: 0, comm: swapper Not tainted 2.6.27-rc3-21328-ga7f5aaf #8
>>> [    0.000000]
>>> [    0.000000] Call Trace:
>>> [    0.000000]  [<ffffffff80234c3e>] warn_on_slowpath+0x51/0x77
>>> [    0.000000]  [<ffffffff8023570a>] printk+0x4e/0x56
>>> [    0.000000]  [<ffffffff803add02>] sort+0xfa/0x18c
>>> [    0.000000]  [<ffffffff808283d3>] cmp_range+0x0/0x6
>>> [    0.000000]  [<ffffffff80828a47>] mtrr_trim_uncached_memory+0x508/0x550
>>> [    0.000000]  [<ffffffff802178e1>] post_set+0x20/0x3d
>>> [    0.000000]  [<ffffffff80824f99>] setup_arch+0x39d/0x6be
>>> [    0.000000]  [<ffffffff8081e962>] start_kernel+0x74/0x341
>>> [    0.000000]  [<ffffffff8081e394>] x86_64_start_kernel+0xe3/0xe7
>>> [    0.000000]
>>> [    0.000000] ---[ end trace 4eaa2a86a8e2da22 ]---
>>>
>>>
>>> Steps to reproduce:
>>>
>>> This warning isn't present under 2.6.24.2 and the full range of physical memory
>>> is usable.
>>
>> Looks like a post-2.6.26 regression caused by
>> 12031a624af7816ec7660b82be648aa3703b4ebe.
> reg00: base=0xd0000000 (3328MB), size=196864MB: uncachable, count=1
> reg01: base=0xe0000000 (3584MB), size=197120MB: uncachable, count=1
> reg02: base=0x00000000 (   0MB), size=212992MB: write-back, count=1
> reg03: base=0x400000000 (16384MB), size=197120MB: write-back, count=1
> reg04: base=0x420000000 (16896MB), size=196864MB: write-back, count=1
>
> the size mtrr looks crazy.

please apply attached patch and boot with show_msr=1 to dump the msr
(including mtrr)

YH

------=_Part_16372_22785823.1219283351781
Content-Type: text/x-patch; name=debug_extra_print_out_msr_x.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fk4pqq530
Content-Disposition: attachment; filename=debug_extra_print_out_msr_x.patch

W1BBVENIXSB4ODZfNjQ6IHByaW50b3V0IG1zcgoKY29tbWFuZGxpbmUgc2hvd19tc3I9MSBmb3Ig
YnNwLCBzaG93X21zcj0zMiBmb3IgYWxsIDMyIGNwdXMuCgpTaWduZWQtb2ZmLWJ5OiBZaW5naGFp
IEx1IDx5aGx1Lmtlcm5lbEBnbWFpbC5jb20+CgotLS0KIGFyY2gveDg2L2tlcm5lbC9jcHUvY29t
bW9uXzY0LmMgfCAgIDQ2ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysK
IGluY2x1ZGUvYXNtLXg4Ni9tc3IuaCAgICAgICAgICAgfCAgIDIzICsrKysrKysrKysrKysrKysr
KysrCiAyIGZpbGVzIGNoYW5nZWQsIDY5IGluc2VydGlvbnMoKykKCkluZGV4OiBsaW51eC0yLjYv
YXJjaC94ODYva2VybmVsL2NwdS9jb21tb25fNjQuYwo9PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09Ci0tLSBsaW51eC0yLjYu
b3JpZy9hcmNoL3g4Ni9rZXJuZWwvY3B1L2NvbW1vbl82NC5jCisrKyBsaW51eC0yLjYvYXJjaC94
ODYva2VybmVsL2NwdS9jb21tb25fNjQuYwpAQCAtNDMwLDYgKzQzMCw0OSBAQCBzdGF0aWMgX19p
bml0IGludCBzZXR1cF9ub2NsZmx1c2goY2hhciAqCiB9CiBfX3NldHVwKCJub2NsZmx1c2giLCBz
ZXR1cF9ub2NsZmx1c2gpOwogCitzdHJ1Y3QgbXNyX3JhbmdlIHsKKwl1bnNpZ25lZCBtaW47CisJ
dW5zaWduZWQgbWF4OworfTsKKworc3RhdGljIHN0cnVjdCBtc3JfcmFuZ2UgbXNyX3JhbmdlX2Fy
cmF5W10gX19jcHVpbml0ZGF0YSA9IHsKKwl7IDB4MDAwMDAwMDAsIDB4MDAwMDA0MTh9LAorCXsg
MHhjMDAwMDAwMCwgMHhjMDAwMDQwYn0sCisJeyAweGMwMDEwMDAwLCAweGMwMDEwMTQyfSwKKwl7
IDB4YzAwMTEwMDAsIDB4YzAwMTEwM2J9LAorfTsKKworc3RhdGljIHZvaWQgX19jcHVpbml0IHBy
aW50X2NwdV9tc3Iodm9pZCkKK3sKKwl1bnNpZ25lZCBpbmRleDsKKwl1NjQgdmFsOworCWludCBp
OworCXVuc2lnbmVkIGluZGV4X21pbiwgaW5kZXhfbWF4OworCisJZm9yIChpID0gMDsgaSA8IEFS
UkFZX1NJWkUobXNyX3JhbmdlX2FycmF5KTsgaSsrKSB7CisJCWluZGV4X21pbiA9IG1zcl9yYW5n
ZV9hcnJheVtpXS5taW47CisJCWluZGV4X21heCA9IG1zcl9yYW5nZV9hcnJheVtpXS5tYXg7CisJ
CWZvciAoaW5kZXggPSBpbmRleF9taW47IGluZGV4IDwgaW5kZXhfbWF4OyBpbmRleCsrKSB7CisJ
CQlpZiAocmRtc3JsX2FtZF9zYWZlKGluZGV4LCAmdmFsKSkKKwkJCQljb250aW51ZTsKKwkJCXBy
aW50ayhLRVJOX0lORk8gIiBNU1IlMDh4OiAlMDE2bGx4XG4iLCBpbmRleCwgdmFsKTsKKwkJfQor
CX0KK30KKworc3RhdGljIGludCBzaG93X21zciBfX2NwdWluaXRkYXRhOworc3RhdGljIF9faW5p
dCBpbnQgc2V0dXBfc2hvd19tc3IoY2hhciAqYXJnKQoreworCWludCBudW07CisKKwlnZXRfb3B0
aW9uKCZhcmcsICZudW0pOworCisJaWYgKG51bSA+IDApCisJCXNob3dfbXNyID0gbnVtOworCXJl
dHVybiAxOworfQorX19zZXR1cCgic2hvd19tc3I9Iiwgc2V0dXBfc2hvd19tc3IpOworCiB2b2lk
IF9fY3B1aW5pdCBwcmludF9jcHVfaW5mbyhzdHJ1Y3QgY3B1aW5mb194ODYgKmMpCiB7CiAJaWYg
KGMtPng4Nl9tb2RlbF9pZFswXSkKQEAgLTQzOSw2ICs0ODIsOSBAQCB2b2lkIF9fY3B1aW5pdCBw
cmludF9jcHVfaW5mbyhzdHJ1Y3QgY3B1CiAJCXByaW50ayhLRVJOX0NPTlQgIiBzdGVwcGluZyAl
MDJ4XG4iLCBjLT54ODZfbWFzayk7CiAJZWxzZQogCQlwcmludGsoS0VSTl9DT05UICJcbiIpOwor
CisJaWYgKGMtPmNwdV9pbmRleCA8IHNob3dfbXNyKQorCQlwcmludF9jcHVfbXNyKCk7CiB9CiAK
IHN0YXRpYyBfX2luaXQgaW50IHNldHVwX2Rpc2FibGVjcHVpZChjaGFyICphcmcpCkluZGV4OiBs
aW51eC0yLjYvaW5jbHVkZS9hc20teDg2L21zci5oCj09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0KLS0tIGxpbnV4LTIuNi5v
cmlnL2luY2x1ZGUvYXNtLXg4Ni9tc3IuaAorKysgbGludXgtMi42L2luY2x1ZGUvYXNtLXg4Ni9t
c3IuaApAQCAtNjMsNiArNjMsMjIgQEAgc3RhdGljIGlubGluZSB1bnNpZ25lZCBsb25nIGxvbmcg
bmF0aXZlXwogCXJldHVybiBFQVhfRURYX1ZBTCh2YWwsIGxvdywgaGlnaCk7CiB9CiAKK3N0YXRp
YyBpbmxpbmUgdW5zaWduZWQgbG9uZyBsb25nIG5hdGl2ZV9yZWFkX21zcl9hbWRfc2FmZSh1bnNp
Z25lZCBpbnQgbXNyLAorCQkJCQkJICAgICAgaW50ICplcnIpCit7CisJREVDTEFSRV9BUkdTKHZh
bCwgbG93LCBoaWdoKTsKKworCWFzbSB2b2xhdGlsZSgiMjogcmRtc3IgOyB4b3IgJTAsJTBcbiIK
KwkJICAgICAiMTpcblx0IgorCQkgICAgICIuc2VjdGlvbiAuZml4dXAsXCJheFwiXG5cdCIKKwkJ
ICAgICAiMzogIG1vdiAlMywlMCA7IGptcCAxYlxuXHQiCisJCSAgICAgIi5wcmV2aW91c1xuXHQi
CisJCSAgICAgX0FTTV9FWFRBQkxFKDJiLCAzYikKKwkJICAgICA6ICI9ciIgKCplcnIpLCBFQVhf
RURYX1JFVCh2YWwsIGxvdywgaGlnaCkKKwkJICAgICA6ICJjIiAobXNyKSwgIkQiICgweDljNWEy
MDNhKSwgImkiICgtRUZBVUxUKSk7CisJcmV0dXJuIEVBWF9FRFhfVkFMKHZhbCwgbG93LCBoaWdo
KTsKK30KKwogc3RhdGljIGlubGluZSB2b2lkIG5hdGl2ZV93cml0ZV9tc3IodW5zaWduZWQgaW50
IG1zciwKIAkJCQkgICAgdW5zaWduZWQgbG93LCB1bnNpZ25lZCBoaWdoKQogewpAQCAtMTU4LDYg
KzE3NCwxMyBAQCBzdGF0aWMgaW5saW5lIGludCByZG1zcmxfc2FmZSh1bnNpZ25lZCBtCiAJKnAg
PSBuYXRpdmVfcmVhZF9tc3Jfc2FmZShtc3IsICZlcnIpOwogCXJldHVybiBlcnI7CiB9CitzdGF0
aWMgaW5saW5lIGludCByZG1zcmxfYW1kX3NhZmUodW5zaWduZWQgbXNyLCB1bnNpZ25lZCBsb25n
IGxvbmcgKnApCit7CisJaW50IGVycjsKKworCSpwID0gbmF0aXZlX3JlYWRfbXNyX2FtZF9zYWZl
KG1zciwgJmVycik7CisJcmV0dXJuIGVycjsKK30KIAogI2RlZmluZSByZHRzY2wobG93KQkJCQkJ
CVwKIAkoKGxvdykgPSAodTMyKW5hdGl2ZV9yZWFkX3RzYygpKQo=
------=_Part_16372_22785823.1219283351781--
