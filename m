Return-Path: <linux-kernel-owner+w=401wt.eu-S1763473AbYDUQ3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763473AbYDUQ3R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 12:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754610AbYDUQ3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 12:29:05 -0400
Received: from ti-out-0910.google.com ([209.85.142.188]:60749 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754535AbYDUQ3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 12:29:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=RxglCXfHGtDuL8zllgzyEzEnXmJRjYF0i2vHH6GkuwRMG4ybkqHImYd0a/+mOkPkPfrzcjflz/Ycq7wPDFryXKvpkAITyHUN5Mi3fCfrexe8kZ+mbuYPvTcAzOyQMwFk/fxo41wcMMYefmmCBKvHOsblAKdTm0MBVdjoHerSXW8=
Message-ID: <e85b9d30804210928n6bb08f3bqa4e30741798009fa@mail.gmail.com>
Date: Mon, 21 Apr 2008 18:28:58 +0200
From: Matthew <jackdachef@gmail.com>
To: "=?ISO-8859-1?Q?Thomas_B=E4chler?=" <thomas@archlinux.org>
Subject: Re: Linux 2.6.25 (coretemp reads high temperatures)
Cc: "Bart Van Assche" <bart.vanassche@gmail.com>,
       torvalds@linux-foundation.org,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Rudolf Marek" <r.marek@assembler.cz>,
       "Gene Heskett" <gene.heskett@gmail.com>, "Len Brown" <lenb@kernel.org>
In-Reply-To: <480CBC92.4070502@archlinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
References: <e85b9d30804180837y39c52e26i588e4b67c87a5e9d@mail.gmail.com>
	 <200804182151.49021.lenb@kernel.org> <480CBC92.4070502@archlinux.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id m3LGTLEB002531

On Mon, Apr 21, 2008 at 6:10 PM, Thomas BÃ¤chler <thomas@archlinux.org> wrote:> Len Brown schrieb:>>> > Hello Mat,> > I'm not familiar with "coretemp", can you point me to the exact version> > of the application you are running so I can see how it is getting at> > the underlying information?> >>>  I think there is some confusion here: "coretemp" is a kernel module, and> all applications reading it will probably use the lm_sensors libraries. (I> don't think the hwmon module are related to ACPI)>>  $ modinfo coretemp>  filename:       /lib/modules/2.6.25-ARCH/kernel/drivers/hwmon/coretemp.ko>  license:        GPL>  description:    Intel Core temperature monitor>  author:         Rudolf Marek <r.marek@assembler.cz>>  depends:>  vermagic:       2.6.25-ARCH SMP preempt mod_unload>>  That said, I have two Core 2 CPUs (one mobile, one desktop) and the values> coretemp reports have not changed compared to earlier kernel versions> (around 60Â°C when idle on the mobile, much less on the desktop).>>>  > Also, do you see any change with and without kernel built with> CONFIG_THERMAL=y?>>  The values I see from ACPI thermal are also the same as before (this is> funny: they are always about 15Â°C cooler than the coretemp values).>>  So I don't see a regression here, maybe the reporter should try a vanilla> kernel.>>
thermal isn't working on this board (if you mean /proc/acpi/thermal_zone ...)
I also tried a vanilla kernel & it showed the same higher temperature ;(
here the last mail (on lkml it was corrupted) - I don't know if youwere able to read it
>  sure, I'll test-drive the vanilla-kernel, too>>  thanks
ok, tested the vanilla-kernel this morning and it shows the exact hightemperatures (with CONFIG_THERMAL=y)
I've got a question:
when trying to disable thermal it just sits there & won't change:<*> Hardware Monitoring support  ---> -*- Generic Thermal sysfs driver  --->
it seemingly depends on other things:Selected by: ACPI_THERMAL && !X86_VOYAGER && ACPI && ACPI_PROCESSOR
is it safe to disable acpi_processor and acpi or CONFIG_THERMAL ingeneral ? or will it burn down my box ? ;)
I'm asking this because it says/writes:CONFIG_ACPI_THERMAL:                                                    â”‚ â”‚                                                                         â”‚ â”‚ This driver adds support for ACPI thermal zones.  Most mobile and       â”‚ â”‚ some desktop systems support ACPI thermal zones.  It is HIGHLY          â”‚ â”‚ recommended that this option be enabled, as your processor(s)           â”‚ â”‚ may be damaged without it.

thanks
Matÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
