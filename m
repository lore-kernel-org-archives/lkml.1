Return-Path: <linux-kernel-owner+w=401wt.eu-S1756886AbZIVRmc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756886AbZIVRmc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 13:42:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756738AbZIVRma
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 13:42:30 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:48364 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755502AbZIVRm1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 13:42:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=LTvl5niqRtsyIcb79AvZK10924bJICnpzh60+7c5F5l+QFedLbtrExjECoLLOpEjAO
         4zymIgjIlrOagi6yKqldSk2y8Df0gIv2pltWoJ4i0xq8yHtykUfRsVt9Kqsix7KcuFMH
         MXiGbIhaWPBKDPciH8U51chQxw/pmeuvP9Yyo=
MIME-Version: 1.0
In-Reply-To: <19128.52482.184096.558888@pilspetsen.it.uu.se>
References: <55a4f86e0909212101s3097a1e3yf225f3e165ff0bea@mail.gmail.com>
	 <19128.52482.184096.558888@pilspetsen.it.uu.se>
Date: Tue, 22 Sep 2009 10:42:30 -0700
Message-ID: <55a4f86e0909221042h37977c59y4b137380b3d2a1b3@mail.gmail.com>
Subject: Re: libATA SATA errors on DVD bad sectors...
From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Later you write that ata12 connects to a Promise SATA300 TX4.
> In that case, port_status 0x20280000 means:
> - Overrun Error
> - Drive Error
> - Packet Command Cycle
> which means that the drive set its error status flag and raised an interrupt which prematurely terminated a data transfer.

Yes, the code in question is here:
http://lxr.linux.no/linux+v2.6.31/drivers/ata/sata_promise.c#L748

> The obvious next experiment would be to swap the drives and see how the Lite-On behaves on the ICH9 and the LG behaves on the TX4.

Yup, did that earlier this morning.  The controller is the cause, not
the drives. (ie. getting the same error on ata12 even though it's now
the LG, the LiteOn on AHCI is now kernel error message free, still
giving IO errors of course)

>  > Would it make sense to add this somewhere into the code as a 'bad sector' error condition and not perform a hard reset?
>
> The sata_promise driver upon seeing the port_status above sets AC_ERR_HSM and AC_ERR_DEV, and performs a soft reset. Apparently libata-eh follows up with a hard(er) reset, which doesn't surprise me given the HSM and DEV errors.

> So things actually work Ok with the Lite-On on the TX4, and you're mainly concerned about log messages and potential performance loss?

Yes, putting the LiteOn on the AHCI controller seems to speed stuff up
a fair bit (some 20-25% or so).
OTOH, I'd prefer to keep the blu-ray drive on AHCI, since the TX4
controller is just a measly PCI controller.

- Maciej
