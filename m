Return-Path: <linux-kernel-owner+w=401wt.eu-S1761634AbXJXRF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761634AbXJXRF0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 13:05:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761840AbXJXRDK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 13:03:10 -0400
Received: from s2.ukfsn.org ([217.158.120.143]:33025 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765877AbXJXRDH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 13:03:07 -0400
From: Nick Warne <nick@ukfsn.org>
Reply-To: nick@ukfsn.org
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: New CD/DVD drive - 80-wire cable detection failure
Date: Wed, 24 Oct 2007 18:03:03 +0100
User-Agent: KMail/1.9.7
Cc: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <200710181832.42906.nick@ukfsn.org> <200710201322.57178.nick@ukfsn.org> <200710240133.08425.bzolnier@gmail.com>
In-Reply-To: <200710240133.08425.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710241803.03955.nick@ukfsn.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bart,

On Wednesday 24 October 2007 00:33:08 Bartlomiej Zolnierkiewicz wrote:
> Hi,
>
> > > hdparm --Istdout /dev/hdd
>
> Thanks, the identify block looks quite "interesting".
[...]
> word 93 is 0x2000
>
> bit 0x4000 is not set despite the fact that ATA spec (>= ATA-5) requires
> it to be set (the device claims ATA/ATAPI-3/4/5/6/7 compatiblity, a bit too
> optimistic since it looks like the firmware was based on ATA/ATAPI-4 spec)
>
> bit 0x2000 is set which would indicate that the 80-wires cable is
> correctly detected by the device
>
> => the device/firmware pair is a good candidate for ivb_list[]

Interesting, I fully understand.

> There seems to be a new firmware (SB01) for this device:
> http://www.samsungodd.com/Lib/popup/Download.asp?path=FW_FWDownload&fname=2
>00710011656260232_SH-S202J_%20SB01.exe
> It would be useful to know whether it has the same problem...

I cannot use this - I haven't used windows at home for a few years, and have 
no way to flash the device up.  It would be interesting though if this does 
make it conform.

> Could you try this patch?
>
> [PATCH] ide: add SH-S202J to ivb_list[]

Thank you!  This works very well!


hdd: ATAPI 48X DVD-ROM DVD-R-RAM CD-R/RW drive, 2048kB Cache<7>hdd: skipping 
word 93 validity check
, UDMA(66)


Many thanks indeed!

Nick

> From the report by Nick Warne.
>
> Cc: Nick Warne <nick@ukfsn.org>
> Cc: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---
>  drivers/ide/ide-iops.c |    3 +++
>  1 file changed, 3 insertions(+)
>
> Index: b/drivers/ide/ide-iops.c
> ===================================================================
> --- a/drivers/ide/ide-iops.c
> +++ b/drivers/ide/ide-iops.c
> @@ -582,9 +582,12 @@ EXPORT_SYMBOL_GPL(ide_in_drive_list);
>  /*
>   * Early UDMA66 devices don't set bit14 to 1, only bit13 is valid.
>   * We list them here and depend on the device side cable detection for
> them. + *
> + * Some optical devices with the buggy firmwares have the same problem.
>   */
>  static const struct drive_list_entry ivb_list[] = {
>  	{ "QUANTUM FIREBALLlct10 05"	, "A03.0900"	},
> +	{ "TSSTcorp CDDVDW SH-S202J"	, "SB00"	},
>  	{ NULL				, NULL		}
>  };



-- 
Free Software Foundation Associate Member 5508
