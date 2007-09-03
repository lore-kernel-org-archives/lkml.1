Return-Path: <linux-kernel-owner+w=401wt.eu-S932127AbXICIHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932127AbXICIHw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 04:07:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754284AbXICIHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 04:07:18 -0400
Received: from lilly.ping.de ([83.97.42.2]:3674 "HELO lilly.ping.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932142AbXICIHQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 04:07:16 -0400
Date: Mon, 3 Sep 2007 10:06:41 +0200
From: Patrick Mau <mau@oscar.ping.de>
To: Xavier Bestel <xavier.bestel@free.fr>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: very very strange simultaneous RAID resync on sep 2, 01:06
	CEST (+2)
Message-ID: <20070903080641.GA2074@oscar.prima.de>
References: <1188806170.1131.479.camel@frg-rhel40-em64t-04>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1188806170.1131.479.camel@frg-rhel40-em64t-04>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 03, 2007 at 09:56:10AM +0200, Xavier Bestel wrote:
> Hi,

Hi Xavier

> I have a server running with RAID5 disks, under debian/stable, kernel
> 2.6.18-5-686. Yesterday the RAID resync'd for no apparent reason,
> without even mdamd sending a mail to warn about that:
> 
> Sep  2 01:06:01 awak kernel: md: syncing RAID array md0

[snip]

> I'm still gathering informations (no idea what his disks are, etc.), but
> does anyone have the same problem ? Does anyone know where it can come
> from (debian trouble, md bug, drive firmware problem, rootkit, ..) and
> how I can pinpoint that ?

My debian installation has a system cronjob that will perform a resync
every first Sunday morning at 1:06 AM:

[root@oscar] cat /etc/cron.d/mdadm
...
6 1 * * 0 root [ -x /usr/share/mdadm/checkarray ] && [ $(date +\%d) -le 7 ] && /usr/share/mdadm/checkarray --cron --all --quiet

I did not read the manpage, but my guess is that 'quiet' will suppress
the mail notification.

Regards,
Patrick

