Return-Path: <linux-kernel-owner+w=401wt.eu-S1752311AbZK0GaV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752311AbZK0GaV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 01:30:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751149AbZK0GaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 01:30:21 -0500
Received: from qw-out-2122.google.com ([74.125.92.27]:19754 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbZK0GaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 01:30:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=lS+TUMI9MKfV/DGkU8I+KHJLE+6dThbYoOooIlYfVGlzVqCTixIq7p+WH3E/aPfpKg
         rRV2efbROtDTChwHU5W7noX4dO11CMpMVU5I15JtRg32hLDtXhp/UmoPaYfoLEMMOHfs
         vZNbmltkE/q1XMbIWdzUM9OXpx3TEIXwENL1k=
MIME-Version: 1.0
In-Reply-To: <20091126164846.GA22709@x200.malnet.ru>
References: <20091126164846.GA22709@x200.malnet.ru>
Date: Fri, 27 Nov 2009 14:30:24 +0800
Message-ID: <2375c9f90911262230s254b677dke129758715a4a305@mail.gmail.com>
Subject: Re: Programs die when max_map_count is too large
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: jengelh@medozas.de, linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=001517576a5245ccfe0479546d67
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001517576a5245ccfe0479546d67
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 27, 2009 at 12:48 AM, Alexey Dobriyan <adobriyan@gmail.com> wro=
te:
>> IMO, the problem is 'sysctl_max_map_count' is actually signed int,
>> while when writing to it, the value is treated as unsigned.
>
> The problem is the loop in simple_strtoul(), some people were so afraid
> to touch so they even came up with strict_* variants.
>
>> A better fix which I could imagine is to fix sysctl to understand
>> signed int's.
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0- =C2=A0 =C2=A0 =C2=A0 int map_count;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0+ =C2=A0 =C2=A0 =C2=A0 unsigned int map_count;
>
> This is incomplete at least.
>

Yeah, perhaps.

I got a better fix, but only for max_map_count. Please check it below.

(Sorr for attatching it, gmail's IMAP sucks.)

----------------->

Make negative values for 'max_map_count' invalid, they are meaningless.
And avoid overflow.

I already tested this.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
-------

--001517576a5245ccfe0479546d67
Content-Type: text/plain; charset=US-ASCII; 
	name="kernel-sysctl-max-map-count-overflow.diff"
Content-Disposition: attachment; 
	filename="kernel-sysctl-max-map-count-overflow.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g2iksysg0

ZGlmZiAtLWdpdCBhL2tlcm5lbC9zeXNjdGwuYyBiL2tlcm5lbC9zeXNjdGwuYwppbmRleCAwZDk0
OWM1Li4yMTIzNjBlIDEwMDY0NAotLS0gYS9rZXJuZWwvc3lzY3RsLmMKKysrIGIva2VybmVsL3N5
c2N0bC5jCkBAIC0xMjQ1LDcgKzEyNDUsOCBAQCBzdGF0aWMgc3RydWN0IGN0bF90YWJsZSB2bV90
YWJsZVtdID0gewogCQkuZGF0YQkJPSAmc3lzY3RsX21heF9tYXBfY291bnQsCiAJCS5tYXhsZW4J
CT0gc2l6ZW9mKHN5c2N0bF9tYXhfbWFwX2NvdW50KSwKIAkJLm1vZGUJCT0gMDY0NCwKLQkJLnBy
b2NfaGFuZGxlcgk9ICZwcm9jX2RvaW50dmVjCisJCS5wcm9jX2hhbmRsZXIJPSAmcHJvY19kb2lu
dHZlY19taW5tYXgsCisJCS5leHRyYTEJCT0gJnplcm8sCiAJfSwKICNlbHNlCiAJewo=
--001517576a5245ccfe0479546d67--
