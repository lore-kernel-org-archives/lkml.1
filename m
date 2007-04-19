Return-Path: <linux-kernel-owner+w=401wt.eu-S1031241AbXDSNbD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031241AbXDSNbD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 09:31:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031243AbXDSNbC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 09:31:02 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:11013 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031241AbXDSNbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 09:31:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=gaVe+uLGiHSahz+PFeGykiQya3XYudoUJ69j0siYMkaZtcoXcvt4AGbQCI2PEv4zadhHYH8bb29tGExDwjZcPSxwQM4m13lyX1wJRYOOQ+bnG8CJWWZGNHbYSd3UKYc8wKqREZTq4emOiqoECoFUx/SXFm8bR7itNv//aeNOq+0=
Message-ID: <414cba4e0704190630j3a64fbd3yf0f55ad9fa16a6fd@mail.gmail.com>
Date: Thu, 19 Apr 2007 15:30:56 +0200
From: emisca <emisca.ml@gmail.com>
To: "Chuck Ebbert" <cebbert@redhat.com>
Subject: Re: Loud "pop" coming from hard drive on reboot
Cc: "Robert Hancock" <hancockr@shaw.ca>, "Tejun Heo" <htejun@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, "Mark Lord" <liml@rtr.ca>
In-Reply-To: <4626A8E6.9010502@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fa.nTNVZ3bPe8773+gVV7CvcwBT5zY@ifi.uio.no>
	 <fa.r8VLu18GDND9EByYV/EX2mH9V88@ifi.uio.no>
	 <fa.30Zxf5IYhdVc+I5v0caKmHH3HmE@ifi.uio.no>
	 <fa.EFm9zBLufsOlxdviaZmnBDcbYgY@ifi.uio.no>
	 <fa.TBFIUvjBaGbwUHy5JUiGJpvOeMI@ifi.uio.no>
	 <fa.jDn5j5GVDwXXnVYH74vVT3m+Gq8@ifi.uio.no> <4626A303.80208@shaw.ca>
	 <4626A8E6.9010502@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From the debian etch 4.0 /etc/init.d/halt script:

        # Don't shut down drives if we're using RAID.
        hddown="-h"
        if grep -qs '^md.*active' /proc/mdstat
        then
                hddown=""
        fi

        # If INIT_HALT=HALT don't poweroff.
        poweroff="-p"
        if [ "$INIT_HALT" = "HALT" ]
        then
                poweroff=""
        fi

        # Make it possible to not shut down network interfaces,
        # needed to use wake-on-lan
        netdown="-i"
        if [ "$NETDOWN" = "no" ]; then
                netdown=""
        fi

        log_action_msg "Will now halt"
        halt -d -f $netdown $poweroff $hddown

So it will always call halt -d when doing shutdown. I've also noticed
that doing suspend to disk, the drive don't spins up two times. Next
shutdown I'll try to remove the -d option and I'll report what it
does....

2007/4/19, Chuck Ebbert <cebbert@redhat.com>:
> Robert Hancock wrote:
> > Tejun Heo wrote:
> >> This really isn't a regression.  It's been always like that with libata.
> >>  libata doesn't make devices go into standby mode and shutdown(8) does
> >> it for libata.  The problem here is that libata does issue
> >> SYNCHRONIZE_CACHE on shutdown.  So, the sequence of event is...
> >>
> >> 1. shutdown(8) issues SYNCHRONIZE_CACHE followed by STANDBY_NOW
> >
> > This part is presumably distribution dependent. I have never seen Fedora
> > or CentOS shut down drives on power down from the shutdown script/utility..
> >
>
> Some distro shutdown scripts must be doing "halt -h" at shutdown time.
>
> -n : don't sync cache (default is to sync)
> -h : put harddrives in standby (default is no standby)
>
> And BTW not put them in sleep instead of standby (whether it's
> the halt program or the kernel?) They won't wake up from that
> until they're reset.
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
