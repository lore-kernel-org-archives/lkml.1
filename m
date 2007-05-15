Return-Path: <linux-kernel-owner+w=401wt.eu-S1759935AbXEOWum@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759935AbXEOWum (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 18:50:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756748AbXEOWug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 18:50:36 -0400
Received: from nz-out-0506.google.com ([64.233.162.228]:21408 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756704AbXEOWuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 18:50:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:references;
        b=M6avXFcgmsDxBb+O1Ns5jY8UeTySgUn4PVV/F3pRB8Zl5eIu6GUqbrpuHz+R9LXDnG5N5TIc7sc0ynFrpPpY617K8LiPA/cWsxA+3BLnEQHI1XxxPdLuu+i6SynHl9aoRwpyXRzYfCpiX04v+xjmOZZC3Txs01I0C/f12mWjUA8=
Message-ID: <d45a3acc0705151550s48af38dfkc6bf2d0696a6aaef@mail.gmail.com>
Date: Wed, 16 May 2007 08:50:34 +1000
From: "andrew hendry" <andrew.hendry@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.22-rc1
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.0.98.0705150855270.16401@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_9421_23234982.1179269434281"
References: <alpine.LFD.0.98.0705121857100.6739@woody.linux-foundation.org>
	 <d45a3acc0705142114t2ed13889p5ed97740782d2821@mail.gmail.com>
	 <alpine.LFD.0.98.0705142135390.6739@woody.linux-foundation.org>
	 <d45a3acc0705142210w3982c14ep8afac73c1352ec7e@mail.gmail.com>
	 <alpine.LFD.0.98.0705150855270.16401@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_9421_23234982.1179269434281
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Yes, putting the extern highstart_pfn back compiles clean for that rand config.

Sorry for the attachment, no access to a patch friendly mailer at work.

Andrew.

On 5/16/07, Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
>
> On Tue, 15 May 2007, andrew hendry wrote:
> >
> > almost, highstart_pfn is used in a few printks
> >
> > arch/i386/mm/discontig.c: In function 'setup_memory':
> > arch/i386/mm/discontig.c:314: error: 'highstart_pfn' undeclared (first
> > use in this function)
> > arch/i386/mm/discontig.c:314: error: (Each undeclared identifier is
> > reported only once
> > arch/i386/mm/discontig.c:314: error: for each function it appears in.)
>
> Gaah. highstart_pfn is declared in <asm/highmem.h>, but that one is
> protected by a
>
>         #ifdef CONFIG_HIGHMEM
>         #include <asm/highmem.h>
>
> in <linux/highmem.h>, so even though we include highmem.h, we never see
> the declaration.
>
> Your config is insane, but anyway, does it compile if you just add back
> the extra "unnecessary" declaration of highstart_pfn?
>
>                 Linus
>

------=_Part_9421_23234982.1179269434281
Content-Type: text/x-patch; name=himem.patch; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: base64
X-Attachment-Id: f_f1qxtktq
Content-Disposition: attachment; filename="himem.patch"

ZGlmZiAtdXByTiAtWCBkb250ZGlmZiBhL2FyY2gvaTM4Ni9tbS9kaXNjb250aWcuYyBiL2FyY2gv
aTM4Ni9tbS9kaXNjb250aWcuYwotLS0gYS9hcmNoL2kzODYvbW0vZGlzY29udGlnLmMJMjAwNy0w
NS0xNSAxNToxOTo0OS4wMDAwMDAwMDAgKzEwMDAKKysrIGIvYXJjaC9pMzg2L21tL2Rpc2NvbnRp
Zy5jCTIwMDctMDUtMTUgMTU6MzU6MjYuMDAwMDAwMDAwICsxMDAwCkBAIC0zMSw2ICszMSw3IEBA
CiAjaW5jbHVkZSA8bGludXgvbW9kdWxlLmg+CiAjaW5jbHVkZSA8bGludXgva2V4ZWMuaD4KICNp
bmNsdWRlIDxsaW51eC9wZm4uaD4KKyNpbmNsdWRlIDxsaW51eC9zd2FwLmg+CiAKICNpbmNsdWRl
IDxhc20vZTgyMC5oPgogI2luY2x1ZGUgPGFzbS9zZXR1cC5oPgpAQCAtOTcsMTQgKzk4LDkgQEAg
dW5zaWduZWQgbG9uZyBub2RlX21lbW1hcF9zaXplX2J5dGVzKGludAogI2VuZGlmCiAKIGV4dGVy
biB1bnNpZ25lZCBsb25nIGZpbmRfbWF4X2xvd19wZm4odm9pZCk7Ci1leHRlcm4gdm9pZCBmaW5k
X21heF9wZm4odm9pZCk7CiBleHRlcm4gdm9pZCBhZGRfb25lX2hpZ2hwYWdlX2luaXQoc3RydWN0
IHBhZ2UgKiwgaW50LCBpbnQpOwogCi1leHRlcm4gc3RydWN0IGU4MjBtYXAgZTgyMDsKLWV4dGVy
biB1bnNpZ25lZCBsb25nIGhpZ2hlbmRfcGZuLCBoaWdoc3RhcnRfcGZuOwotZXh0ZXJuIHVuc2ln
bmVkIGxvbmcgbWF4X2xvd19wZm47Ci1leHRlcm4gdW5zaWduZWQgbG9uZyB0b3RhbHJhbV9wYWdl
czsKLWV4dGVybiB1bnNpZ25lZCBsb25nIHRvdGFsaGlnaF9wYWdlczsKK2V4dGVybiB1bnNpZ25l
ZCBsb25nIGhpZ2hzdGFydF9wZm47CiAKICNkZWZpbmUgTEFSR0VfUEFHRV9CWVRFUyAoUFRSU19Q
RVJfUFRFICogUEFHRV9TSVpFKQogCkBAIC0zNjAsNyArMzU2LDkgQEAgdm9pZCBfX2luaXQgem9u
ZV9zaXplc19pbml0KHZvaWQpCiAJbWF4X3pvbmVfcGZuc1taT05FX0RNQV0gPQogCQl2aXJ0X3Rv
X3BoeXMoKGNoYXIgKilNQVhfRE1BX0FERFJFU1MpID4+IFBBR0VfU0hJRlQ7CiAJbWF4X3pvbmVf
cGZuc1taT05FX05PUk1BTF0gPSBtYXhfbG93X3BmbjsKKyNpZmRlZiBDT05GSUdfSElHSE1FTQog
CW1heF96b25lX3BmbnNbWk9ORV9ISUdITUVNXSA9IGhpZ2hlbmRfcGZuOworI2VuZGlmCiAJLyog
SWYgU1JBVCBoYXMgbm90IHJlZ2lzdGVyZWQgbWVtb3J5LCByZWdpc3RlciBpdCBub3cgKi8KIAlp
ZiAoZmluZF9tYXhfcGZuX3dpdGhfYWN0aXZlX3JlZ2lvbnMoKSA9PSAwKSB7CiAJCWZvcl9lYWNo
X29ubGluZV9ub2RlKG5pZCkgewo=
------=_Part_9421_23234982.1179269434281--
