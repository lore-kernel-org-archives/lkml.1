Return-Path: <linux-kernel-owner+w=401wt.eu-S1755305AbZHRIkH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305AbZHRIkH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 04:40:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753590AbZHRIkH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 04:40:07 -0400
Received: from mail-qy0-f196.google.com ([209.85.221.196]:57814 "EHLO
	mail-qy0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994AbZHRIkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 04:40:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=dza3MpGjeIPrbojEf0pPqGl407xnZYycWVT4riRBpIxo51vgUFZcDKhWK6D0TvdI9l
         S/E5/xhdLlk+rX2n/JotQuNEDwXg0VZAf4YRqvKWD9VdE53TcYPVdmPB09swsmS5yBo6
         2iMcnHlGDdK6Xf1QCxaUreGxlcdOm3VS4rEd4=
MIME-Version: 1.0
In-Reply-To: <4A7A106B.2070809@mnementh.co.uk>
References: <Pine.LNX.4.64.0907170842050.4731@axis700.grange>
	 <4A71F2A5.4060206@mnementh.co.uk>
	 <aec7e5c30908021952j7947b513w7d62f2c4d87bd3c5@mail.gmail.com>
	 <4A787C2C.5070000@mnementh.co.uk>
	 <aec7e5c30908041908p568f413albef7dede3fd2cb83@mail.gmail.com>
	 <4A798A4B.4000901@mnementh.co.uk>
	 <Pine.LNX.4.64.0908051702180.5802@axis700.grange>
	 <4A7A08FE.5000909@mnementh.co.uk>
	 <Pine.LNX.4.64.0908060045320.9219@axis700.grange>
	 <4A7A106B.2070809@mnementh.co.uk>
Date: Tue, 18 Aug 2009 17:40:03 +0900
Message-ID: <aec7e5c30908180140n3d46c9c0i33560b2e09ad3f9d@mail.gmail.com>
Subject: Re: MMC: Make the configuration memory resource optional
From: Magnus Damm <magnus.damm@gmail.com>
To: Ian Molton <ian@mnementh.co.uk>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       pHilipp Zabel <philipp.zabel@gmail.com>,
       Paul Mundt <lethal@linux-sh.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel@vger.kernel.org, Pierre Ossman <drzeus@drzeus.cx>
Content-Type: multipart/mixed; boundary=001636418539f767e304716676e6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001636418539f767e304716676e6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi Ian!

On Thu, Aug 6, 2009 at 8:06 AM, Ian Molton<ian@mnementh.co.uk> wrote:
> Ok, so then your controller (unless it uses a different scheme altogether
> for the card clock divider) probably has a max card clock of 12MHz and a min
> of 24/512MHz.

Allright, I've now tested the tmio_mmc driver on a ms7724se board. In
the current configuration the tmio_mmc block is driven by a 83 Mhz
clock. We can change the frequency of this clock but it will affect
other hardware blocks as well so I'd rather not unless I really have
to.

> I'm fine with that. If someone who _has_ this hardware could get a 'scope on
> the card clock and see what frequencies actually appear out there, I'd
> _really_ appreciate it.

I've done some measurements with my Fluke 123 Scopemeter. It's limited
to 20 MHz so I didn't measure all combinations. I hooked it up to pin
5 of CN7 on the ms7724se board. In total I did 7 measurements, with
XSHIFT from 0 to 6. One line per measurement below. The number on the
far right is the value from the scope.

using clock 162760 (162760, 83333332) [162760] 0x0180 -> 162.7 kHz
using clock 325520 (162760, 83333332) [325520] 0x0140 -> 0.326 MHz
using clock 651040 (162760, 83333332) [651040] 0x0120 -> 0.651 MHz
using clock 1302080 (162760, 83333332) [1302080] 0x0110 -> 01.30 MHz
using clock 2604160 (162760, 83333332) [2604160] 0x0108 -> 02.61 MHz
using clock 5208320 (162760, 83333332) [5208320] 0x0104 -> 05.21 MHz
using clock 10416640 (162760, 83333332) [10416640] 0x0102 -> 10.42 MHz

Everything seems to work as expected what I can tell. The frequencies match.

I've attached a patch which shows details of the printouts. Hopefully
it includes all you need.

FYI, I needed to modify the tmio_mmc driver to change the
dev->num_resources check in probe from 3 to 2 to support the SuperH
hardware. Can you please roll in that change and send an updated
version of your "MMC / MFD / Clocks" patch whenever you have time?

Thanks for your help!

Cheers,

/ magnus

--001636418539f767e304716676e6
Content-Type: application/octet-stream; 
	name="linux-2.6.32-pre-sh-se7724-tmio-measure-hack-20090818.patch"
Content-Disposition: attachment; 
	filename="linux-2.6.32-pre-sh-se7724-tmio-measure-hack-20090818.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fyidmy380

LS0tIDAwMDcvZHJpdmVycy9tbWMvaG9zdC90bWlvX21tYy5jCisrKyB3b3JrL2RyaXZlcnMvbW1j
L2hvc3QvdG1pb19tbWMuYwkyMDA5LTA4LTE4IDE3OjAzOjIyLjAwMDAwMDAwMCArMDkwMApAQCAt
MzUsMTMgKzM1LDE2IEBACiAKICNpbmNsdWRlICJ0bWlvX21tYy5oIgogCisjZGVmaW5lIFhTSElG
VCA2CisjZGVmaW5lIFhMSU1JVCAoMTYyNzYwIDw8IFhTSElGVCkKKwogc3RhdGljIHZvaWQgdG1p
b19tbWNfc2V0X2Nsb2NrKHN0cnVjdCB0bWlvX21tY19ob3N0ICpob3N0LCBpbnQgbmV3X2Nsb2Nr
KQogewogCXUzMiBjbGsgPSAwLCBjbG9jazsKIAogCWlmIChuZXdfY2xvY2spIHsKIAkJZm9yIChj
bG9jayA9IGhvc3QtPm1tYy0+Zl9taW4sIGNsayA9IDB4ODAwMDAwODA7Ci0JCQluZXdfY2xvY2sg
Pj0gKGNsb2NrPDwxKTsgY2xrID4+PSAxKQorCQkgICAgIChjbG9jayA8IFhMSU1JVCkgJiYgKG5l
d19jbG9jayA+PSAoY2xvY2s8PDEpKTsgY2xrID4+PSAxKQogCQkJY2xvY2sgPDw9IDE7CiAJCWNs
ayB8PSAweDEwMDsKIAl9CkBAIC00OSw2ICs1MiwxMCBAQCBzdGF0aWMgdm9pZCB0bWlvX21tY19z
ZXRfY2xvY2soc3RydWN0IHRtCiAJaWYoaG9zdC0+c2V0X25vX2Nsa19kaXYpCiAJCWhvc3QtPnNl
dF9ub19jbGtfZGl2KE5VTEwsIChjbGs+PjIyKSAmIDEpOwogCisJcHJpbnRrKCJ1c2luZyBjbG9j
ayAlZCAoJWQsICVkKSBbJWRdIDB4JTA0eFxuIiwKKwkgICAgICAgY2xvY2ssIGhvc3QtPm1tYy0+
Zl9taW4sIGhvc3QtPm1tYy0+Zl9tYXgsIFhMSU1JVCwKKwkgICAgICAgY2xrICYgMHgxZmYpOwor
CiAJc2RfY3RybF93cml0ZTE2KGhvc3QsIENUTF9TRF9DQVJEX0NMS19DVEwsIGNsayAmIDB4MWZm
KTsKIH0KIAo=
--001636418539f767e304716676e6--
