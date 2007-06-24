Return-Path: <linux-kernel-owner+w=401wt.eu-S1753985AbXFXXrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985AbXFXXrS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 19:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752327AbXFXXrD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 19:47:03 -0400
Received: from rtr.ca ([64.26.128.89]:3247 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751418AbXFXXrB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 19:47:01 -0400
Message-ID: <467F0272.9070903@rtr.ca>
Date: Sun, 24 Jun 2007 19:46:58 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: Carlo Wood <carlo@alinoe.com>, Justin Piszcz <jpiszcz@lucidpixels.com>,
       Michael Tokarev <mjt@tls.msk.ru>,
       "Dr. David Alan Gilbert" <linux@treblig.org>,
       Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>,
       Manoj Kasichainula <manoj@io.com>, linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: SATA RAID5 speed drop of 100 MB/s
References: <4679B2DE.9090903@garzik.org> <20070622214859.GC6970@alinoe.com> <467CC5C5.6040201@garzik.org> <20070623125316.GB26672@alinoe.com> <467DA1F5.2060306@garzik.org> <467E5C5E.6000706@msgid.tls.msk.ru> <20070624125957.GA28067@gallifrey> <Pine.LNX.4.64.0706241021030.12207@p34.internal.lan> <467E9356.1030200@msgid.tls.msk.ru> <Pine.LNX.4.64.0706241257190.12207@p34.internal.lan> <20070624220723.GA21724@alinoe.com>
In-Reply-To: <20070624220723.GA21724@alinoe.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Carlo Wood wrote:
>
> The following can be observed:
> 
> 1) There is hardly any difference between the two schedulers (noop
>    is a little faster for the bonny test).
> 2) An NCQ depth of 1 is WAY faster on RAID5 (bonnie; around 125 MB/s),
>    the NCQ depth of 2 is by far the slowest for the RAID5 (bonnie;
>    around 40 MB/s). NCQ depths of 3 and higher show no difference,
>    but are also slow (bonnie; around 75 MB/s).
> 3) There is no significant influence of the NCQ depth for non-RAID,
>    either the /dev/sda (hdparm -t) or /dev/sdd disk (hdparm -t and
>    bonnie).
> 4) With a NCQ depth > 1, the hdparm -t measurement of /dev/md7 is
>    VERY unstable. Sometimes it gives the maximum (around 150 MB/s),
>    and sometimes as low as 30 MB/s, seemingly independent of the
>    NCQ depth. Note that those measurement were done on an otherwise
>    unloaded machine in single user mode; and the measurements were
>    all done one after an other. The strong fluctuation of the hdparm
>    results for the RAID device (while the underlaying devices do not
>    show this behaviour) are unexplainable.
> 
>>From the above I conclude that something must be wrong with the
> software RAID implementation - and not just with the harddisks, imho.
> At least, that's what it looks like to me. I am not an expert though ;)

I'm late tuning in here, but:

(1) hdparm issues only a single read at a time, so NCQ won't help it.

(2) WD Raptor drives automatically turn off "read-ahead" when using NCQ,
which totally kills any throughput measurements.  They do this to speed
up random access seeks; dunno if it pays off or not.  Under Windows,
the disk drivers don't use NCQ when performing large I/O operations,
which avoids the performance loss.

(3) Other drives from other brands may have similar issues,
but I have not run into it on them yet.

Cheers

