Return-Path: <linux-kernel-owner+w=401wt.eu-S1762763AbXJMSF4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762763AbXJMSF4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 14:05:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932634AbXJMSFZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 14:05:25 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:62115 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761989AbXJMSFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 14:05:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=gkY/0ESekg2nwwpPBVm5P9Bah5+9DM8HYmWSpdMk/dfK/nIajy6k++/cD56fdbY9s43RfHTQCwBs7M07qBggR4QBvK8BMi/QBPIBzqCTpPwqjAtY6UgLz2VE0Lz49R9AHA299tSpW5nP+U2baM2stKsESnW5lYM/gshIXPRPBpY=
Message-ID: <64bb37e0710131105m7c64fca0kb71f3955170e8bec@mail.gmail.com>
Date: Sat, 13 Oct 2007 20:05:19 +0200
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: "Jeff Garzik" <jeff@garzik.org>
Subject: Re: 2.6.23-mm1
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, "Kuan Luo" <kluo@nvidia.com>,
       "Peer Chen" <pchen@nvidia.com>
In-Reply-To: <47110500.8050503@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071011213126.cf92efb7.akpm@linux-foundation.org>
	 <20071012013729.ada2127b.akpm@linux-foundation.org>
	 <64bb37e0710130101y7fb8e4c0lf214fd821e8305ed@mail.gmail.com>
	 <4710A407.3070000@garzik.org>
	 <64bb37e0710130503haa66d6eu93e75ecdc78ac866@mail.gmail.com>
	 <4710B7C5.5050403@garzik.org>
	 <64bb37e0710130732p303547e3n54cfa9dac34c53b5@mail.gmail.com>
	 <64bb37e0710130740u78613f83wbd4f43d073bbe13d@mail.gmail.com>
	 <64bb37e0710130813le68c48dve36f8473b197b84b@mail.gmail.com>
	 <47110500.8050503@garzik.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13/07, Jeff Garzik <jeff@garzik.org> wrote:
> Torsten Kaiser wrote:
> > 3 boots, all worked. So I'm very sure that was the bug, but I will now
> > do a little load testing...
> >
> > The only strange thing about 2.6.23-mm1 is, that it takes ~4 second
> > more to boot.
>
> So, you basically applied the attached patch?
>
> Yeah, absence of qc_defer for an NCQ-capable chip would do it.

Yes. The system seems to work correctly now.

The only thing I noted during load testing (updating Gentoo ==
compiling and installing) was, that there seems to be memory leak.
After ~2h 2.5 of my 4Gb where gone. But there where to many things
going on to pinpoint it... (NFSv4 over eth1394?)

> diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
> index cf5c85e..240a892 100644
> --- a/drivers/ata/sata_nv.c
> +++ b/drivers/ata/sata_nv.c
> @@ -554,6 +554,7 @@ static const struct ata_port_operations nv_swncq_ops = {
>         .bmdma_start            = ata_bmdma_start,
>         .bmdma_stop             = ata_bmdma_stop,
>         .bmdma_status           = ata_bmdma_status,
> +       .qc_defer               = ata_std_qc_defer,
>         .qc_prep                = nv_swncq_qc_prep,
>         .qc_issue               = nv_swncq_qc_issue,
>         .freeze                 = nv_mcp55_freeze,
>
>
