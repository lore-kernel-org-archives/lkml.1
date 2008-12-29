Return-Path: <linux-kernel-owner+w=401wt.eu-S1756704AbYL2ABZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756704AbYL2ABZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 19:01:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755269AbYL2ABP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 19:01:15 -0500
Received: from rv-out-0506.google.com ([209.85.198.237]:40318 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755246AbYL2ABO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 19:01:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:references;
        b=ihs1FBST88GxPbKRsMxC2PRUj1ZqgETLY5UFlm/OHGGJkHjxjBp2B6+24lIN1Ii4tb
         xD9y4zu7MzAA/g3B4GiDtF9d5Uq6PkUDbWi6Pvw2Bh/4C88EpU4uuMHXddrwm1TeAmwK
         xD/o73CmSOLIU/z47ceZke4n9+seCYSPMIkv0=
Message-ID: <86802c440812281601j57fe5ecdif4b63b72280c65cd@mail.gmail.com>
Date: Sun, 28 Dec 2008 16:01:13 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [git pull] sparseirq / irq updates for v2.6.29
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "KOSAKI Motohiro" <kosaki.motohiro@gmail.com>,
       linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "Kamalesh Babulal" <kamalesh@linux.vnet.ibm.com>
In-Reply-To: <20081228233028.GA14697@elte.hu>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_45427_17630777.1230508873516"
References: <20081225160741.GA14486@elte.hu> <20081227133240.GA8716@elte.hu>
	 <2f11576a0812270927taef068fobbad997dc5e5aacf@mail.gmail.com>
	 <20081227173839.GA9793@elte.hu>
	 <alpine.LFD.2.00.0812281510370.3082@localhost.localdomain>
	 <20081228232729.GA2158@elte.hu> <20081228233028.GA14697@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_45427_17630777.1230508873516
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Sun, Dec 28, 2008 at 3:30 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Ingo Molnar <mingo@elte.hu> wrote:
>
>>   b2e2fe9: sparseirq: work around __weak alias bug
>
> here's that fix, standalone too. Kamalesh, i think this should finally fix
> the crash you are seeing.
>
>        Ingo
>
> ---------------->
> From b2e2fe99628c4f944c3075258e536197b5a4f3f8 Mon Sep 17 00:00:00 2001
> From: Ingo Molnar <mingo@elte.hu>
> Date: Mon, 29 Dec 2008 00:16:45 +0100
> Subject: [PATCH] sparseirq: work around __weak alias bug
>
> Impact: fix boot crash if the kernel is built with certain GCC versions
>
> GCC has a bug with __weak alias functions: if the functions are in
> the same compilation unit as their call site, GCC can decide to
> inline them - and thus rob the linker of the opportunity to override
> the weak alias with the real thing.
>
> This can lead to the boot crash reported by Kamalesh Babulal:
>
>  ACPI: Core revision 20080926
>  Setting APIC routing to flat
>  BUG: unable to handle kernel NULL pointer dereference at
>  0000000000000000
>  IP: [<ffffffff8021f9a8>] add_pin_to_irq_cpu+0x14/0x74
>  PGD 0
>  Oops: 0000 [#1] SMP
>  [...]
>
> So move the arch_init_chip_data() function from handle.c to manage.c.
>
> Reported-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  kernel/irq/handle.c |    5 -----
>  kernel/irq/manage.c |    9 +++++++++
>  2 files changed, 9 insertions(+), 5 deletions(-)
>

that is not enough.

please check

need one printk, and move two functions into chip.c

YH

------=_Part_45427_17630777.1230508873516
Content-Type: text/x-patch; name=sparse_irq_fix6.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fpad5zot0
Content-Disposition: attachment; filename=sparse_irq_fix6.patch

W1BBVENIXSBzcGFyc2VpcnE6IG12b2UgdHdvIHdlYWsgZnVuY3Rpb25zIHRvIGNoaXAuYwoKSW1w
YWN0OiBmaXggcGFuaWMKCnNvbWUgZ2NjIGNvbXBpbGVyIHdpbGwgcmVtb3ZlIHRoZSB3ZWFrIGds
b2JhbCBibGFuayBmdW5jdGlvbgpMaW51cyBub3RlZCB0aGF0IHdlIGNvdWxkIG1vdmUgdGhvc2Ug
ZnVuY3Rpb24gdG8gb3RoZXIgdW5pdCB0byB3b3JrYXJvdW5kIGl0LgoKdHJ5IHRvIHdvcmthcm91
bmQgaXQ6CjEuIG9uZSB0aW1lIHBhdGg6IGFkZCBwcmludGsKMi4gbXVsdGkgdGltZSBwYXRoOiBt
b3ZlIHRvIGNoaXAuYwoKU2lnbmVkLW9mZi1ieTogWWluZ2hhaSBMdSA8eWluZ2hhaUBrZXJuZWwu
b3JnPgoKZGlmZiAtLWdpdCBhL2luaXQvbWFpbi5jIGIvaW5pdC9tYWluLmMKaW5kZXggZDBjNWUw
Mi4uNmE3YTMwOCAxMDA2NDQKLS0tIGEvaW5pdC9tYWluLmMKKysrIGIvaW5pdC9tYWluLmMKQEAg
LTU0MiwxNCArNTQyLDExIEBAIHZvaWQgX19pbml0IF9fd2VhayB0aHJlYWRfaW5mb19jYWNoZV9p
bml0KHZvaWQpCiB7CiB9CiAKLWludCBfX2luaXQgX193ZWFrIGFyY2hfZWFybHlfaXJxX2luaXQo
dm9pZCkKLXsKLQlyZXR1cm4gMDsKLX0KLQogaW50IF9faW5pdCBfX3dlYWsgZWFybHlfaXJxX2lu
aXQodm9pZCkKIHsKLQlyZXR1cm4gYXJjaF9lYXJseV9pcnFfaW5pdCgpOworCXByaW50ayhLRVJO
X0RFQlVHICJjYWxsaW5nIF9fd2VhayBlYXJseV9pcnFfaW5pdCgpXG4iKTsKKworCXJldHVybiAw
OwogfQogCiBhc21saW5rYWdlIHZvaWQgX19pbml0IHN0YXJ0X2tlcm5lbCh2b2lkKQpkaWZmIC0t
Z2l0IGEva2VybmVsL2lycS9jaGlwLmMgYi9rZXJuZWwvaXJxL2NoaXAuYwppbmRleCBmNjNjNzA2
Li4yYmEwYzg0IDEwMDY0NAotLS0gYS9rZXJuZWwvaXJxL2NoaXAuYworKysgYi9rZXJuZWwvaXJx
L2NoaXAuYwpAQCAtMTgsNiArMTgsMTYgQEAKIAogI2luY2x1ZGUgImludGVybmFscy5oIgogCitp
bnQgX19pbml0IF9fd2VhayBhcmNoX2Vhcmx5X2lycV9pbml0KHZvaWQpCit7CisJcmV0dXJuIDA7
Cit9CisKK2ludCBfX3dlYWsgYXJjaF9pbml0X2NoaXBfZGF0YShzdHJ1Y3QgaXJxX2Rlc2MgKmRl
c2MsIGludCBjcHUpCit7CisJcmV0dXJuIDA7Cit9CisKIC8qKgogICoJZHluYW1pY19pcnFfaW5p
dCAtIGluaXRpYWxpemUgYSBkeW5hbWljYWxseSBhbGxvY2F0ZWQgaXJxCiAgKglAaXJxOglpcnEg
bnVtYmVyIHRvIGluaXRpYWxpemUKZGlmZiAtLWdpdCBhL2tlcm5lbC9pcnEvaGFuZGxlLmMgYi9r
ZXJuZWwvaXJxL2hhbmRsZS5jCmluZGV4IDE1N2MwNGMuLmMyMGRiMGIgMTAwNjQ0Ci0tLSBhL2tl
cm5lbC9pcnEvaGFuZGxlLmMKKysrIGIva2VybmVsL2lycS9oYW5kbGUuYwpAQCAtODYsMTEgKzg2
LDYgQEAgdm9pZCBpbml0X2tzdGF0X2lycXMoc3RydWN0IGlycV9kZXNjICpkZXNjLCBpbnQgY3B1
LCBpbnQgbnIpCiAJCWRlc2MtPmtzdGF0X2lycXMgPSAodW5zaWduZWQgaW50ICopcHRyOwogfQog
Ci1pbnQgX193ZWFrIGFyY2hfaW5pdF9jaGlwX2RhdGEoc3RydWN0IGlycV9kZXNjICpkZXNjLCBp
bnQgY3B1KQotewotCXJldHVybiAwOwotfQotCiBzdGF0aWMgdm9pZCBpbml0X29uZV9pcnFfZGVz
YyhpbnQgaXJxLCBzdHJ1Y3QgaXJxX2Rlc2MgKmRlc2MsIGludCBjcHUpCiB7CiAJbWVtY3B5KGRl
c2MsICZpcnFfZGVzY19pbml0LCBzaXplb2Yoc3RydWN0IGlycV9kZXNjKSk7Cg==
------=_Part_45427_17630777.1230508873516--
