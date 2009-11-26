Return-Path: <linux-kernel-owner+w=401wt.eu-S1752093AbZKZSqH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752093AbZKZSqH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 13:46:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751842AbZKZSqH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 13:46:07 -0500
Received: from gateway-1237.mvista.com ([206.112.117.35]:4748 "HELO
	imap.sh.mvista.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1750867AbZKZSqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 13:46:05 -0500
Message-ID: <4B0ECD27.7050302@ru.mvista.com>
Date: Thu, 26 Nov 2009 21:47:03 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pata_it8213: MWDMA0 is unsupported
References: <200911261728.36433.bzolnier@gmail.com> <200911261903.01199.bzolnier@gmail.com> <4B0EC52B.2070805@ru.mvista.com> <200911261927.00597.bzolnier@gmail.com> <4B0EC9EA.9000608@ru.mvista.com>
In-Reply-To: <4B0EC9EA.9000608@ru.mvista.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, I wrote:

>>>>>>>> MWDMA0 timings cannot be met with the PIIX based controller
>>>>>>>> programming interface.

>>>>>>>> This change should be safe as this is how we have been doing
>>>>>>>> things in IDE it8213 host driver for years.

>>>>>>>> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>>>>>>>> ---
>>>>>>>> Verified with the documentation (similar case as with pata_efar).

>>>>>>> Uhhh, no...

>>>>>>> Too many damn drivers.

>>>>>>> Too much damn duplication.

>>>>>>> Too much damn subtle differences here and there.

>>>>>>> The hardware is probably fine for MWMDA0 when it comes to 
>>>>>>> pata_{efar,it8213},
>>>>>>> it just not documented properly in the data sheet.

>>>>>>   How so with pata_efar? The active/recovery bitfields are still 
>>>>>> 2-bit wide, no?

>>>>> Yes but when TIMEx bit is disabled we are using XFER_PIO_SLOW timings.

>>>    600 ns cycle vs spec'ed 480 ns? Is it really worth it?

>> 960 ns actually

>    That table you're looking at (probably in the SLC90E66 datasheet?) 
> must be screwed up. 960 ns is used for command cycles, according to 
> Intel's docs, data cycles run at 600 ns...

    Well, after doublke checking 82371AB datasheet has 660 ns, and ICH PRM 
has 900 ns. Not sure where I got what I've cited now, perhaps in some older 
version of PRM... what a mess indeed. :-/

MBR, Sergei
