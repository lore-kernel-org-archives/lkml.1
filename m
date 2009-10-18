Return-Path: <linux-kernel-owner+w=401wt.eu-S1754207AbZJRDIk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207AbZJRDIk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 23:08:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754165AbZJRDIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 23:08:39 -0400
Received: from mail-iw0-f178.google.com ([209.85.223.178]:64680 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754133AbZJRDIj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 23:08:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=X6AcyIXQBRL9PrSdUd1XcDwctuBGvWt/ONhuqN2vvgPdjyWh/nblTtzSqehUxSDjND
         NxZTzTDW2rIiitivw9m6ZF70yiBFmoT4ph1Sd+BwtuTiGBLN67LQ0fVPwUxepooiV1nj
         smB4R/nEDN4Mk2GSUBLoQZ0dzdOYB72Lp4rbU=
MIME-Version: 1.0
In-Reply-To: <200910171654.03344.bzolnier@gmail.com>
References: <200910152137.58164.IvDoorn@gmail.com> <200910152204.16407.IvDoorn@gmail.com> 
	<200910171654.03344.bzolnier@gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Sun, 18 Oct 2009 14:08:23 +1100
Message-ID: <646765f40910172008r1309126fla6897d4289004934@mail.gmail.com>
Subject: Re: [PATCH 2/2] rt2x00: Implement support for rt2800pci
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Ivo van Doorn <ivdoorn@gmail.com>, John Linville <linville@tuxdriver.com>,
       linux-wireless@vger.kernel.org, users@host1.serialmonkey.com,
       Alban Browaeys <prahal@yahoo.com>,
       Benoit PAPILLAULT <benoit.papillault@free.fr>,
       Felix Fietkau <nbd@openwrt.org>,
       Luis Correia <luis.f.correia@gmail.com>,
       Mattias Nissler <mattias.nissler@gmx.de>,
       Mark Asselstine <asselsm@gmail.com>,
       Xose Vazquez Perez <xose.vazquez@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 18, 2009 at 01:54, Bartlomiej Zolnierkiewicz
<bzolnier@gmail.com> wrote:
> Now to the less happy part..
>
> I also used the opportunity to take a closer look at this driver and
> it seems that it needlessly adds around 2 KLOC to kernel by duplicating
> the common content of rt2800usb.h to rt2800pci.h instead of moving it
> to the shared header (like it is done in the staging crap drivers):
>
> $ wc -l drivers/net/wireless/rt2x00/rt2800usb.h drivers/net/wireless/rt2x00/rt2800pci.h
>  1951 drivers/net/wireless/rt2x00/rt2800usb.h
>  1960 drivers/net/wireless/rt2x00/rt2800pci.h
>  3911 total
>
> $ diff -u drivers/net/wireless/rt2x00/rt2800usb.h drivers/net/wireless/rt2x00/rt2800pci.h|diffstat
>  rt2800pci.h |  213 +++++++++++++++++++++++++++++++-----------------------------
>  1 file changed, 111 insertions(+), 102 deletions(-)
>
> Similarly it looks like most of the code between rt2800usb.c and rt2800pci.c
> could also be shared (up to another 2 KLOC saved) by adding abstraction layer
> for accessing chipset registers over different buses (again like it is done
> in staging crap drivers):
>
> $ wc -l drivers/net/wireless/rt2x00/rt2800usb.c drivers/net/wireless/rt2x00/rt2800pci.c
>  3077 drivers/net/wireless/rt2x00/rt2800usb.c
>  3323 drivers/net/wireless/rt2x00/rt2800pci.c
>  6400 total
>
> $ diff -u drivers/net/wireless/rt2x00/rt2800usb.c drivers/net/wireless/rt2x00/rt2800pci.c|diffstat
>  rt2800pci.c | 2190 +++++++++++++++++++++++++++++++++---------------------------
>  1 file changed, 1218 insertions(+), 972 deletions(-)

Nobody else has said it, so:

Patches welcome!

Your points with the vendor drivers apply here too - consolidating the
common parts of the drivers will enhance readability, and make
development easier, and mean that, with your help, these might get to
a everyday usable state quicker.

And remember that this is a preliminary release of the code. There's
still a long way to go.

Thanks,

-- 

Julian Calaby

Email: julian.calaby@gmail.com
.Plan: http://sites.google.com/site/juliancalaby/
