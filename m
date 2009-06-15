Return-Path: <linux-kernel-owner+w=401wt.eu-S1758469AbZFOMwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758469AbZFOMwT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 08:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754499AbZFOMwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 08:52:09 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:23198 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753654AbZFOMwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 08:52:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=iD51zqKok1LKoyZ1hIZ/MD/9o0Qov4rd6Bdy9gYsfZMUq36h6PXgE5BhyyWnBErDuV
         hr61xyjmm48wDZj/o5ZaWgoE27h4Yok+0uZHXrUXy7sZKeTN5UBrvcSFlAY74CMhLuKR
         bprMZFCU+/dTR+stx4Pim5MVNjgym5axdUjw4=
MIME-Version: 1.0
In-Reply-To: <1245070063.16986.22.camel@pc1117.cambridge.arm.com>
References: <1245070063.16986.22.camel@pc1117.cambridge.arm.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Mon, 15 Jun 2009 08:51:50 -0400
Message-ID: <8bd0f97a0906150551o6de9a29fj64f73d4ccfff7e57@mail.gmail.com>
Subject: Re: kallsyms broken on ARM by commit 17b1f0d
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=00151750e4dabe598a046c628656
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00151750e4dabe598a046c628656
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 15, 2009 at 08:47, Catalin Marinas wrote:
> With the above commit, kallsyms on ARM no longer show correct
> information. That's a trace with this commit:
>
> =C2=A0 =C2=A0[<c007bfec>] _etext+0xffd9bfec/0x126d8
> =C2=A0 =C2=A0[<c00795e4>] _etext+0xffd995e4/0x126d8
> =C2=A0 =C2=A0[<c0147d94>] _etext+0xffe67d94/0x126d8
> =C2=A0 =C2=A0[<c0147f10>] _etext+0xffe67f10/0x126d8
> =C2=A0 =C2=A0[<c01481bc>] _etext+0xffe681bc/0x126d8
> =C2=A0 =C2=A0[<c0148218>] _etext+0xffe68218/0x126d8
> =C2=A0 =C2=A0[<c0143db0>] _etext+0xffe63db0/0x126d8
> =C2=A0 =C2=A0[<c0143e18>] _etext+0xffe63e18/0x126d8
> =C2=A0 =C2=A0[<c007f250>] _etext+0xffd9f250/0x126d8
> =C2=A0 =C2=A0[<c007c238>] _etext+0xffd9c238/0x126d8
> =C2=A0 =C2=A0[<c007c2b8>] _etext+0xffd9c2b8/0x126d8
> =C2=A0 =C2=A0[<c0023dc0>] _etext+0xffd43dc0/0x126d8
>
> and with the commit reverted:
>
> =C2=A0 =C2=A0[<c007bfec>] kmemleak_alloc+0x14c/0x260
> =C2=A0 =C2=A0[<c00795e4>] kmem_cache_alloc+0xd4/0x108
> =C2=A0 =C2=A0[<c0147d94>] tty_ldisc_try_get+0x18/0xb0
> =C2=A0 =C2=A0[<c0147f10>] tty_ldisc_get+0x18/0x40
> =C2=A0 =C2=A0[<c01481bc>] tty_ldisc_reinit+0x28/0x5c
> =C2=A0 =C2=A0[<c0148218>] tty_ldisc_release+0x28/0x3c
> =C2=A0 =C2=A0[<c0143db0>] tty_release_dev+0x3cc/0x428
> =C2=A0 =C2=A0[<c0143e18>] tty_release+0xc/0x14
> =C2=A0 =C2=A0[<c007f250>] __fput+0x104/0x1c4
> =C2=A0 =C2=A0[<c007c238>] filp_close+0x70/0x7c
> =C2=A0 =C2=A0[<c007c2b8>] sys_close+0x74/0xa8
> =C2=A0 =C2=A0[<c0023dc0>] ret_fast_syscall+0x0/0x28
>
> Any idea what went wrong? I haven't looked at your commit in detail.

try this patch (Gentoo mail server is broken atm, so attaching)
-mike

--00151750e4dabe598a046c628656
Content-Type: application/octet-stream; 
	name="0001-kallsyms-fix-inverted-valid-symbol-checking.patch"
Content-Disposition: attachment; 
	filename="0001-kallsyms-fix-inverted-valid-symbol-checking.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fvz6p0r80

RnJvbSBjMWQ0YzIzMTZlZTRkYjdhNTc0N2NmZDljNzQ0YjQyYjY3OWJlYTIwIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNaWtlIEZyeXNpbmdlciA8dmFwaWVyQGdlbnRvby5vcmc+CkRh
dGU6IE1vbiwgMTUgSnVuIDIwMDkgMDc6NTI6NDggLTA0MDAKU3ViamVjdDogW1BBVENIXSBrYWxs
c3ltczogZml4IGludmVydGVkIHZhbGlkIHN5bWJvbCBjaGVja2luZwoKVGhlIHByZXZpb3VzIGNv
bW1pdCAoMTdiMWYwZGUpIGludHJvZHVjZWQgYSBzbGlnaHRseSBicm9rZW4gY29uc29saWRhdGlv
bgpvZiB0aGUgbWVtb3J5IHRleHQgcmFuZ2UgY2hlY2tpbmcuCgpTaWduZWQtb2ZmLWJ5OiBNaWtl
IEZyeXNpbmdlciA8dmFwaWVyQGdlbnRvby5vcmc+Ci0tLQogc2NyaXB0cy9rYWxsc3ltcy5jIHwg
ICAgNiArKystLS0KIDEgZmlsZXMgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCAzIGRlbGV0aW9u
cygtKQoKZGlmZiAtLWdpdCBhL3NjcmlwdHMva2FsbHN5bXMuYyBiL3NjcmlwdHMva2FsbHN5bXMu
YwppbmRleCAzY2I1Nzg5Li42NDM0M2NjIDEwMDY0NAotLS0gYS9zY3JpcHRzL2thbGxzeW1zLmMK
KysrIGIvc2NyaXB0cy9rYWxsc3ltcy5jCkBAIC0xNjcsMTEgKzE2NywxMSBAQCBzdGF0aWMgaW50
IHN5bWJvbF92YWxpZF90cihzdHJ1Y3Qgc3ltX2VudHJ5ICpzKQogCWZvciAoaSA9IDA7IGkgPCBB
UlJBWV9TSVpFKHRleHRfcmFuZ2VzKTsgKytpKSB7CiAJCXRyID0gJnRleHRfcmFuZ2VzW2ldOwog
Ci0JCWlmIChzLT5hZGRyID49IHRyLT5zdGFydCAmJiBzLT5hZGRyIDwgdHItPmVuZCkKLQkJCXJl
dHVybiAwOworCQlpZiAocy0+YWRkciA+PSB0ci0+c3RhcnQgJiYgcy0+YWRkciA8PSB0ci0+ZW5k
KQorCQkJcmV0dXJuIDE7CiAJfQogCi0JcmV0dXJuIDE7CisJcmV0dXJuIDA7CiB9CiAKIHN0YXRp
YyBpbnQgc3ltYm9sX3ZhbGlkKHN0cnVjdCBzeW1fZW50cnkgKnMpCi0tIAoxLjYuMy4xCgo=
--00151750e4dabe598a046c628656--
