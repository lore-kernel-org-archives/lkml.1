Return-Path: <linux-kernel-owner+w=401wt.eu-S1758617AbXERGNW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758617AbXERGNW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 02:13:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754343AbXERGNQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 02:13:16 -0400
Received: from smtp01.cdmon.com ([86.109.99.230]:64679 "EHLO smtp01.cdmon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752389AbXERGNP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 02:13:15 -0400
Date: Fri, 18 May 2007 08:15:12 +0200
From: DervishD <lkml@dervishd.net>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: usb-storage nice value
Message-ID: <20070518061512.GA32730@DervishD>
Mail-Followup-To: Stefan Richter <stefanr@s5r6.in-berlin.de>,
	linux-kernel@vger.kernel.org
References: <20070517100308.GA14667@DervishD> <464CB2B3.50506@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <464CB2B3.50506@s5r6.in-berlin.de>
User-Agent: Mutt/1.4.2.2i
Organization: DervishD
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

    Hi Stefan :)

 * Stefan Richter <stefanr@s5r6.in-berlin.de> dixit:
> DervishD wrote:
> >     I'm having problems when reading/writing to external USB harddisks:
> > my *internal* harddisk stalls from time to time, so watching a movie
> > while copying data is a PITA (well, if the movie is bad, the leaps help
> > a bit...).
> 
> If the internal harddisk is source or target of these copy operations...

    Not...
 
> ...
> > is there any way of modifying the pdflush behaviour so
> > large buffered writes are less "agressive" and doesn't block apps which
> > are just reading?
> 
> ...then switching to another IO scheduler might perhaps help.
> 
> # cat /sys/block/hda/queue/scheduler
> 
> # echo deadline > /sys/block/hda/queue/scheduler

    That's another thing I wanted to test, but I'm already using
"deadline" scheduler. How about changing "read_ahead_kb" to a much
higher value so there's plenty of data buffered? The problem seems to
be, according to Alan Cox, that my VIA mobo fills completely the PCI bus
when doing IO bursts, so I can take advantage of that "bug" and fill the
bus when reading.

    My only doubt is if it will affect performance negatively in other
usage patterns (e.g. while writing CD's, since the hard disk will take
the bus on each read operation, and will read more than the current 128
kB).

    Thanks a lot for your answer :)

    Raúl Núñez de Arenas Coronado

-- 
Linux Registered User 88736 | http://www.dervishd.net
It's my PC and I'll cry if I want to... RAmen!
