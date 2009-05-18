Return-Path: <linux-kernel-owner+w=401wt.eu-S1754885AbZERTSt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885AbZERTSt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 15:18:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751605AbZERTSl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 15:18:41 -0400
Received: from mailout02.t-online.de ([194.25.134.17]:34644 "EHLO
	mailout02.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbZERTSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 15:18:41 -0400
Date: Mon, 18 May 2009 21:12:07 +0200
From: Martin Lottermoser <Martin.Lottermoser@t-online.de>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: PATA DMA problem leading to kernel panic on reading movie DVDs
Message-ID: <20090518191207.GA7531@wanza.invalid>
References: <20090517091224.GA8280@wanza.invalid> <4A10509C.603@gmail.com> <200905172135.10136.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200905172135.10136.bzolnier@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ID: GWxvUqZF8h2pmHyApYx82FjjobkZLvnAZDeEJzeGEO12X6Zo3+nDKsgbLfupdCDgGk
X-TOI-MSGID: f3d08477-48f9-4c78-89f5-5b8bafc5b300
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, May 17, 2009 at 09:35:09PM +0200, Bartlomiej Zolnierkiewicz wrote:
> Martin, this is one of ATAPI drives which support UDMA66 but have broken
> cable detection.  Since 2.6.26 we have a special quirk for it ide (commit
> 3ced5c49bd2d1f2c7f769e3a54385883de63a652) and subsequent one in libata
> (commit e9f3340673c1da32041f2a282b166c72cd78632e).
> 
> In your system's case the cable detection doesn't seem to work properly
> which in turn results in all kind of later problems.
> 
> It could be that the quirk itself needs to be revised (I wonder if it was
> originally tested with 40-wires cable) or maybe we need some other cable
> detection fix...
> 
> Please:
> 
> * send 'hdparm --Istdout /dev/hdc' output
> 
> * try 2.6.30-rc6 (maybe 2.6.29.3 oops has been fixed already and we just
>   need to backport it)
> 
> also connecting the drive using 80-wires cable and getting another hdparm
> output (+ seeing if it helps the other problems) would be very useful.

I've done that now as well. Test runs with Debian's 2.6.26 and with 2.6.30-rc6
show no problems: no disabling of DMA, no kernel panic.

The hdparm output ("hdparm --Istdout") is the same for a 40-wire cable and an
80-wire cable (checked under 2.6.26).

This indicates that your hypothesis above that it's a cable detection problem
is correct.

Just out of curiosity: is this a bug on the drive's side or in the kernel?
Or in other words: if the output of "hdparm -I" shows the drive as attached
to be able to support UDMA4, is this a statement passed through unmodified
from the drive or is this a deduction made by the kernel? I ask because
under 2.6.22.9 and 2.6.23.14 I got a message that "host side 80-wire cable
detection failed".

Should anyone find a fix to correct/circumvent this problem in the kernel,
I'ld be willing to test it on my system; just send a patch file or tell me
where to pick it up.

Regards,
Martin Lottermoser
-- 
Martin Lottermoser             Martin.Lottermoser at _REMOVE_t-online.de
Greifswaldstrasse 28
38124 Braunschweig             http://home.vrweb.de/martin.lottermoser
Germany
