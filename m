Return-Path: <linux-kernel-owner+w=401wt.eu-S1759465AbZFLWjA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759465AbZFLWjA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 18:39:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754383AbZFLWiw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 18:38:52 -0400
Received: from ey-out-1920.google.com ([74.125.78.145]:45822 "EHLO
	ey-out-1920.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752253AbZFLWiv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 18:38:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=IbHG3+1Q9Vs9v/TPl6FjiG2LkTt+4l3byJ6NwbttkQwwKjEDnFLr9nT/5PszmJoRtQ
         TKbDzrePLaXkTI4HI8tnYhwRZnfpxXeT8cbhZOJruQI64yMNK6PYXqr5WFqaRyC2308z
         wW/3GpLb8oVVApk7/CDaBFQv/KKH8+e77GWmo=
MIME-Version: 1.0
In-Reply-To: <4A32CCDA.20802@f2s.com>
References: <1244139157-16404-1-git-send-email-philipp.zabel@gmail.com>
	 <1244139157-16404-8-git-send-email-philipp.zabel@gmail.com>
	 <4A32CCDA.20802@f2s.com>
Date: Sat, 13 Jun 2009 00:38:52 +0200
Message-ID: <74d0deb30906121538xc3d8110qc1fa6144959d6b1d@mail.gmail.com>
Subject: Re: [PATCH 7/7] mmc: tmio_mmc: allow compilation for ASIC3
From: pHilipp Zabel <philipp.zabel@gmail.com>
To: ian@mnementh.co.uk
Cc: linux-kernel@vger.kernel.org, Pierre Ossman <pierre@ossman.eu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 12, 2009 at 11:47 PM, Ian molton<spyro@f2s.com> wrote:
> Does this patch actually _do_ anything? wont the asic3 driver need modifying
> to use tmio_mmc before this patch is useful?

That's right, this patch only allows tmio-mmc to be compiled on ASIC3
based devices. The needed changes to ASIC3
(http://patchwork.kernel.org/patch/28000/ et al) are queued in the MFD
tree.

> Is the idea that this patch go in and asic3 MFDs migrate gradually?

The idea was that this patch is applied after tmio-mmc is ASIC3-ready,
so that it doesn't matter whether the MFD or MMC tree gets merged
first. If the ASIC3 MFD changes come first, at least tmio-mmc won't be
built (for CONFIG_MFD_ASIC3) until the tmio-mmc modifications are in.

> If so then I'll ack it.
>
> Philipp Zabel wrote:
>>
>> Now tmio_mmc is able to drive the MMC/SD cell in ASIC3.
>>
>> Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
>> Cc: Pierre Ossman <pierre@ossman.eu>
>> Cc: Ian Molton <spyro@f2s.com>
>> ---
>>  drivers/mmc/host/Kconfig    |    4 ++--
>>  drivers/mmc/host/tmio_mmc.c |    2 +-
>>  2 files changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
>> index b4cf691..9aae7f5 100644
>> --- a/drivers/mmc/host/Kconfig
>> +++ b/drivers/mmc/host/Kconfig
>> @@ -237,7 +237,7 @@ config MMC_SDRICOH_CS
>>   config MMC_TMIO
>>        tristate "Toshiba Mobile IO Controller (TMIO) MMC/SD function
>> support"
>> -       depends on MFD_TMIO
>> +       depends on MFD_TMIO || MFD_ASIC3
>>        help
>>          This provides support for the SD/MMC cell found in TC6393XB,
>> -         T7L66XB and also ipaq ASIC3
>> +         T7L66XB and also HTC ASIC3.
>> diff --git a/drivers/mmc/host/tmio_mmc.c b/drivers/mmc/host/tmio_mmc.c
>> index 9f6e180..9f68c2f 100644
>> --- a/drivers/mmc/host/tmio_mmc.c
>> +++ b/drivers/mmc/host/tmio_mmc.c
>> @@ -10,7 +10,7 @@
>>  *
>>  * Driver for the MMC / SD / SDIO cell found in:
>>  *
>> - * TC6393XB TC6391XB TC6387XB T7L66XB
>> + * TC6393XB TC6391XB TC6387XB T7L66XB ASIC3
>>  *
>>  * This driver draws mainly on scattered spec sheets, Reverse engineering
>>  * of the toshiba e800  SD driver and some parts of the 2.4 ASIC3 driver
>> (4 bit
>
>

regards
Philipp
