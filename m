Return-Path: <linux-kernel-owner+w=401wt.eu-S1757385AbZFSNMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757385AbZFSNMh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 09:12:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752134AbZFSNMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 09:12:30 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:31456 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124AbZFSNM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 09:12:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=dQEGKCfycny/WoUCefA6bF9GdN/y+MJWHP0zyhHUcTB/Wf79P+37J9huvXM+RkWENq
         Jpltn+ZkW+5gVR9EdjYidmu26Cs3Er0X/FLrJ+88tqO+BKeo9MWpLz3DNCFGPzQUW4LE
         RjIn+z0KuajdnFTqs6lZ0FF8YPYJ8p6/SK5ic=
MIME-Version: 1.0
In-Reply-To: <200906191433.34608.arnd@arndb.de>
References: <1244980878-2124-1-git-send-email-vapier@gentoo.org> 
	<200906191105.37732.arnd@arndb.de> <8bd0f97a0906190342s4261e85di9aa746058cbef9be@mail.gmail.com> 
	<200906191433.34608.arnd@arndb.de>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Fri, 19 Jun 2009 09:12:12 -0400
Message-ID: <8bd0f97a0906190612n687cdbbt1e752997acb68e49@mail.gmail.com>
Subject: Re: [PATCH 05/17] Blackfin: convert to generic checksum code
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       Michal Simek <monstr@monstr.eu>, Paul Mundt <lethal@linux-sh.org>
Content-Type: multipart/mixed; boundary=001e680f1c28f20ac3046cb346d2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001e680f1c28f20ac3046cb346d2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On Fri, Jun 19, 2009 at 08:33, Arnd Bergmann wrote:
> On Friday 19 June 2009, Mike Frysinger wrote:
>> On Fri, Jun 19, 2009 at 05:05, Arnd Bergmann wrote:
>> > x86 and blackfin are both little-endian, so your variant is correct
>> > there. They add the 0x01 to the low byte of the 16-bit word, while
>> > on big-endian machines, you have to add it to the high byte.
>>
>> can we think of enough simple examples to through together an optional
>> boot-time self test ?
>
> sounds like a good idea.

how about the attached

> lib/checksum.c: Fix another endianess bug

hrm, still not quite :/

the attached test code shows failures in every case
-mike

--001e680f1c28f20ac3046cb346d2
Content-Type: text/x-csrc; charset=US-ASCII; name="checksum-selftest.c"
Content-Disposition: attachment; filename="checksum-selftest.c"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fw4x6ol10

LyoKICogTmV0d29ya2luZyBjaGVja3N1bSBzZWxmIGNoZWNrcy4KICoKICogTGljZW5zZWQgdW5k
ZXIgdGhlIEdQTC0yLgogKi8KCiNkZWZpbmUgcHJfZm10KGZtdCkgImNzdW0tc2VsZnRlc3Q6ICIg
Zm10CgojaW5jbHVkZSA8bGludXgva2VybmVsLmg+CiNpbmNsdWRlIDxuZXQvY2hlY2tzdW0uaD4K
CmV4dGVybiB1bnNpZ25lZCBzaG9ydCBkb19jc3VtKGNvbnN0IHVuc2lnbmVkIGNoYXIgKmJ1ZmYs
IGludCBsZW4pOwoKc3RydWN0IGRvX2NzdW1fZGF0YSB7Cgl1bnNpZ25lZCBzaG9ydCByZXQ7Cgl1
bnNpZ25lZCBjaGFyICpidWY7CglpbnQgbGVuOwp9OwojZGVmaW5lIERPX0NTVU1fREFUQShfbnVt
LCBfcmV0KSBcCnsJXAoJLnJldCA9IF9yZXQsIFwKCS5idWYgPSBkb19jc3VtX2RhdGEjI19udW0s
IFwKCS5sZW4gPSBBUlJBWV9TSVpFKGRvX2NzdW1fZGF0YSMjX251bSksIFwKfQpzdGF0aWMgdW5z
aWduZWQgY2hhciBfX2luaXRkYXRhIGRvX2NzdW1fZGF0YTFbXSA9IHsKCTB4MjAsCn07CnN0YXRp
YyB1bnNpZ25lZCBjaGFyIF9faW5pdGRhdGEgZG9fY3N1bV9kYXRhMltdID0gewoJMHgwZCwgMHgw
YSwKfTsKc3RhdGljIHVuc2lnbmVkIGNoYXIgX19pbml0ZGF0YSBkb19jc3VtX2RhdGEzW10gPSB7
CgkweGZmLCAweGZiLCAweDAxLAp9OwpzdGF0aWMgdW5zaWduZWQgY2hhciBfX2luaXRkYXRhIGRv
X2NzdW1fZGF0YTVbXSA9IHsKCTB4NjcsIDB4NzIsIDB4NWQsIDB4MGQsIDB4MDAsCn07CnN0YXRp
YyB1bnNpZ25lZCBjaGFyIF9faW5pdGRhdGEgZG9fY3N1bV9kYXRhN1tdID0gewoJMHgyMCwgMHgy
MCwgMHgyMCwgMHgzNSwgMHgzNywgMHgyMCwgMHgyMCwKfTsKc3RhdGljIHVuc2lnbmVkIGNoYXIg
X19pbml0ZGF0YSBkb19jc3VtX2RhdGEyNTVbXSA9IHsKCTB4MjAsIDB4MzQsIDB4MzQsIDB4MzQs
IDB4MjAsIDB4NTMsIDB4MjAsIDB4MjAsIDB4MjAsIDB4MjAsIDB4MmQsCgkweDJmLCAweDYyLCAw
eDY5LCAweDZlLCAweDJmLCAweDczLCAweDY4LCAweDIwLCAweDBkLCAweDBhLCAweDIwLAoJMHgy
MCwgMHgzMSwgMHgzMCwgMHgzNSwgMHgyMCwgMHg3MiwgMHg2ZiwgMHg2ZiwgMHg3NCwgMHgyMCwg
MHgyMCwKCTB4MjAsIDB4MjAsIDB4MjAsIDB4MjAsIDB4MjAsIDB4MjAsIDB4MzQsIDB4MzQsIDB4
MjAsIDB4NTMsIDB4MjAsCgkweDIwLCAweDIwLCAweDIwLCAweDJmLCAweDczLCAweDYyLCAweDY5
LCAweDZlLCAweDJmLCAweDY5LCAweDZlLAoJMHg2NSwgMHg3NCwgMHg2NCwgMHgyMCwgMHgwZCwg
MHgwYSwgMHgyMCwgMHgyMCwgMHgzMSwgMHgzMCwgMHgzNiwKCTB4MjAsIDB4NzIsIDB4NmYsIDB4
NmYsIDB4NzQsIDB4MjAsIDB4MjAsIDB4MjAsIDB4MjAsIDB4MjAsIDB4MjAsCgkweDIwLCAweDM0
LCAweDMzLCAweDM2LCAweDIwLCAweDUzLCAweDIwLCAweDIwLCAweDIwLCAweDIwLCAweDJmLAoJ
MHg3MywgMHg2MiwgMHg2OSwgMHg2ZSwgMHgyZiwgMHg3MywgMHg3OSwgMHg3MywgMHg2YywgMHg2
ZiwgMHg2NywKCTB4NjQsIDB4MjAsIDB4MmQsIDB4NmUsIDB4MjAsIDB4MGQsIDB4MGEsIDB4MjAs
IDB4MjAsIDB4MzEsIDB4MzAsCgkweDM3LCAweDIwLCAweDcyLCAweDZmLCAweDZmLCAweDc0LCAw
eDIwLCAweDIwLCAweDIwLCAweDIwLCAweDIwLAoJMHgyMCwgMHgyMCwgMHgzNCwgMHgzMywgMHgz
MiwgMHgyMCwgMHg1MiwgMHgyMCwgMHgyMCwgMHgyMCwgMHgyMCwKCTB4MmYsIDB4NzMsIDB4NjIs
IDB4NjksIDB4NmUsIDB4MmYsIDB4NmIsIDB4NmMsIDB4NmYsIDB4NjcsIDB4NjQsCgkweDIwLCAw
eDJkLCAweDZlLCAweDIwLCAweDBkLCAweDBhLCAweDIwLCAweDIwLCAweDMxLCAweDMwLCAweDM4
LAoJMHgyMCwgMHg3MiwgMHg2ZiwgMHg2ZiwgMHg3NCwgMHgyMCwgMHgyMCwgMHgyMCwgMHgyMCwg
MHgyMCwgMHgyMCwKCTB4MjAsIDB4MjAsIDB4MzMsIDB4MzIsIDB4MjAsIDB4NTMsIDB4MjAsIDB4
MjAsIDB4MjAsIDB4MjAsIDB4MmYsCgkweDYyLCAweDY5LCAweDZlLCAweDJmLCAweDc3LCAweDYx
LCAweDc0LCAweDYzLCAweDY4LCAweDY0LCAweDZmLAoJMHg2NywgMHg2NCwgMHgyMCwgMHgyZCwg
MHg2NiwgMHgyMCwgMHgyZCwgMHg3MywgMHgyMCwgMHgwZCwgMHgwYSwKCTB4MjAsIDB4MjAsIDB4
MzEsIDB4MzAsIDB4MzksIDB4MjAsIDB4NzIsIDB4NmYsIDB4NmYsIDB4NzQsIDB4MjAsCgkweDIw
LCAweDIwLCAweDIwLCAweDIwLCAweDIwLCAweDIwLCAweDIwLCAweDM1LCAweDM2LCAweDIwLCAw
eDUyLAoJMHgyMCwgMHgyMCwgMHgyMCwgMHgyMCwgMHgyZiwgMHg2MiwgMHg2OSwgMHg2ZSwgMHgy
ZiwgMHg3NCwgMHg2NSwKCTB4NmMsIDB4NmUsIDB4NjUsIDB4NzQsIDB4NjQsIDB4MjAsIDB4MGQs
IDB4MGEsIDB4MjAsIDB4MjAsIDB4MzEsCgkweDMxLCAweDMwLCAweDIwLCAweDcyLCAweDZmLCAw
eDZmLCAweDc0LCAweDIwLCAweDIwLCAweDIwLCAweDIwLAoJMHgyMCwgMHgyMAp9OwpzdGF0aWMg
c3RydWN0IGRvX2NzdW1fZGF0YSBfX2luaXRkYXRhIGRvX2NzdW1fZGF0YVtdID0gewoJRE9fQ1NV
TV9EQVRBKDEsIDB4MDAyMCksCglET19DU1VNX0RBVEEoMiwgMHhmYzAwKSwKCURPX0NTVU1fREFU
QSgzLCAweDBhMGQpLAoJRE9fQ1NVTV9EQVRBKDUsIDB4N2ZjNCksCglET19DU1VNX0RBVEEoNywg
MHg3NTk3KSwKCURPX0NTVU1fREFUQSgyNTUsIDB4NGY5NiksCn07CgpzdGF0aWMgaW50IF9faW5p
dCBkb19jc3VtX3NlbGZ0ZXN0KHZvaWQpCnsKCWludCBpLCByZXQ7Cgl1bnNpZ25lZCBzaG9ydCB0
cmV0OwoKCXJldCA9IDA7Cglmb3IgKGkgPSAwOyBpIDwgQVJSQVlfU0laRShkb19jc3VtX2RhdGEp
OyArK2kpIHsKCQl0cmV0ID0gZG9fY3N1bShkb19jc3VtX2RhdGFbaV0uYnVmLCBkb19jc3VtX2Rh
dGFbaV0ubGVuKTsKCQlpZiAodHJldCAhPSBkb19jc3VtX2RhdGFbaV0ucmV0KSB7CgkJCXByX2Vy
cigiJXM6IHRlc3QgJWk6ICUjeCAhPSAlI3g6IEZBSUxcbiIsCgkJCQlfX2Z1bmNfXywgaSwgdHJl
dCwgZG9fY3N1bV9kYXRhW2ldLnJldCk7CgkJCXJldCA9IDE7CgkJfQoJfQoKCXJldHVybiByZXQ7
Cn0KCnN0YXRpYyBpbnQgX19pbml0IGNzdW1fc2VsZnRlc3RfaW5pdCh2b2lkKQp7CglpbnQgcmV0
ID0gZG9fY3N1bV9zZWxmdGVzdCgpOwoKCWlmICghcmV0KQoJCXByX2luZm8oImFsbCB0ZXN0cyBw
YXNzZWQhXG4iKTsKCglyZXR1cm4gMDsKfQptb2R1bGVfaW5pdChjc3VtX3NlbGZ0ZXN0X2luaXQp
Owo=
--001e680f1c28f20ac3046cb346d2--
