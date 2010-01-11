Return-Path: <linux-kernel-owner+w=401wt.eu-S1753314Ab0AKMCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314Ab0AKMCR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 07:02:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753280Ab0AKMCQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 07:02:16 -0500
Received: from mail-px0-f174.google.com ([209.85.216.174]:34644 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217Ab0AKMCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 07:02:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=hGe5oi/I/r5nXMepURYYyfAchNbkVLVtEOhGf18GWRTe9jtwrNWsFMiwY6DpdfdoIt
         J2QRZYwNsUtPdRUyaC08NbuMqAiLaYbBkI5Qzh2FYVZqJoVj1wJxyL5zW3EtnZXANaB4
         7M4/6+CeAsWx/JefQrqjveiwlUg/yvGW3usg0=
MIME-Version: 1.0
In-Reply-To: <20100111105126.GD3440@sirena.org.uk>
References: <20100111160232.e37e5393.sfr@canb.auug.org.au>
	 <20100111105126.GD3440@sirena.org.uk>
Date: Mon, 11 Jan 2010 07:02:14 -0500
Message-ID: <771cded01001110402p1d2c475bgdde077f066e7f22d@mail.gmail.com>
Subject: Re: linux-next: mfd tree build failure
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Samuel Ortiz <sameo@linux.intel.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=005045029625e36550047ce24e69
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--005045029625e36550047ce24e69
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 11, 2010 at 5:51 AM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Mon, Jan 11, 2010 at 04:02:32PM +1100, Stephen Rothwell wrote:
>> Hi Sam,
>
>> Today's linux-next build (x86_64_allmodconfig, gcc 4.4.0, binutils
>> 2.19.1) failed like this:
>
>> ERROR: "max8925_set_bits" [drivers/video/backlight/max8925_bl.ko] undefi=
ned!
>> ERROR: "max8925_reg_write" [drivers/video/backlight/max8925_bl.ko] undef=
ined!
>> ERROR: "max8925_reg_read" [drivers/video/backlight/max8925_bl.ko] undefi=
ned!
>> ERROR: "max8925_set_bits" [drivers/regulator/max8925.ko] undefined!
>> ERROR: "max8925_reg_read" [drivers/regulator/max8925.ko] undefined!
>
>> I am not sure what caused this, so I have used the version of the mfd
>> tree from next-20100108 for today.
>
> CCing in Haojian who did the driver. =A0I've not looked but I'd guess tha=
t
> the issue is missing EXPORT_SYMBOL{,_GPL}s on the symbols above.
>

I'm sorry on inconvience. Now I attache the fix.

Samuel,
Could you help to review and merge this patch?

It's not caused by EXPORT_SYMBOL{,_GPL}. If I build in max8925 mfd
driver, issue is resolved.
Regulator subsystem could only be built in. And 8925 regulator driver
calls i2c operations that is defined in mfd driver. If 8925 regulator
is built it and mfd 8925 is built as module, it will cause linking
error.

Thanks
Haojian

--005045029625e36550047ce24e69
Content-Type: text/x-patch; charset=US-ASCII; name="0001-mfd-set-max8925-as-built-in.patch"
Content-Disposition: attachment; 
	filename="0001-mfd-set-max8925-as-built-in.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g4bntwn00

RnJvbSBjYzA4YWFlOTUyMzAyY2JjNDQ0NWY0ZGI0OWZkZmFiNWY5ZDc3OWVkIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBIYW9qaWFuIFpodWFuZyA8aGFvamlhbi56aHVhbmdAbWFydmVs
bC5jb20+CkRhdGU6IE1vbiwgMTEgSmFuIDIwMTAgMTQ6Mzg6MzkgLTA1MDAKU3ViamVjdDogW1BB
VENIXSBtZmQ6IHNldCBtYXg4OTI1IGFzIGJ1aWx0IGluCgpTaW5jZSByZWd1bGF0b3IgbW9kdWxl
IGlzIGFsd2F5cyBidWlsdC1pbiwgTUZEIGRyaXZlciBoYXZlIHRvIGJlIGJ1aWx0IGluLgpJZiBN
RkQgZHJpdmVyIGlzIGJ1aWx0IGFzIG1vZHVsZSwgbGlua2luZyBlcnJvciB3aWxsIG9jY3VyLgoK
U2lnbmVkLW9mZi1ieTogSGFvamlhbiBaaHVhbmcgPGhhb2ppYW4uemh1YW5nQG1hcnZlbGwuY29t
PgotLS0KIGRyaXZlcnMvbWZkL0tjb25maWcgfCAgICAyICstCiAxIGZpbGVzIGNoYW5nZWQsIDEg
aW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL21mZC9L
Y29uZmlnIGIvZHJpdmVycy9tZmQvS2NvbmZpZwppbmRleCA5NGU0ZDVlLi5iODkyYzM4IDEwMDY0
NAotLS0gYS9kcml2ZXJzL21mZC9LY29uZmlnCisrKyBiL2RyaXZlcnMvbWZkL0tjb25maWcKQEAg
LTE4Niw3ICsxODYsNyBAQCBjb25maWcgUE1JQ19BRFA1NTIwCiAKIGNvbmZpZyBNRkRfTUFYODky
NQogCXRyaXN0YXRlICJNYXhpbSBTZW1pY29uZHVjdG9yIE1BWDg5MjUgUE1JQyBTdXBwb3J0Igot
CWRlcGVuZHMgb24gSTJDCisJZGVwZW5kcyBvbiBJMkM9eQogCXNlbGVjdCBNRkRfQ09SRQogCWhl
bHAKIAkgIFNheSB5ZXMgaGVyZSB0byBzdXBwb3J0IGZvciBNYXhpbSBTZW1pY29uZHVjdG9yIE1B
WDg5MjUuIFRoaXMgaXMKLS0gCjEuNS42LjUKCg==
--005045029625e36550047ce24e69--
