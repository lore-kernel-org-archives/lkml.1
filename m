Return-Path: <linux-kernel-owner+w=401wt.eu-S1753325AbXC2J1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325AbXC2J1m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 05:27:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753323AbXC2J1m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 05:27:42 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:53491 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753325AbXC2J1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 05:27:41 -0400
X-Greylist: delayed 1883 seconds by postgrey-1.27 at vger.kernel.org; Thu, 29 Mar 2007 05:27:40 EDT
X-Sasl-enc: CLDZHoEHmKqhTFi1xCC6YPw3RvrV0c1bPqG+mx4VYeS1 1175158577
Date: Thu, 29 Mar 2007 05:56:12 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Neil Brown <neilb@suse.de>, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org
Subject: Re: Software RAID (non-preempt) server blocking question. (2.6.20.4)
Message-ID: <20070329085612.GA19278@khazad-dum.debian.net>
References: <Pine.LNX.4.64.0703270557360.31853@p34.internal.lan> <17931.23488.160031.119117@notabene.brown> <Pine.LNX.4.64.0703290410260.32099@p34.internal.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703290410260.32099@p34.internal.lan>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F 1CDB 0FE3
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Mar 2007, Justin Piszcz wrote:
> >Did you look at "cat /proc/mdstat" ?? What sort of speed was the check
> >running at?
> Around 44MB/s.
> 
> I do use the following optimization, perhaps a bad idea if I want other 
> processes to 'stay alive'?
> 
> echo "Setting minimum resync speed to 200MB/s..."
> echo "This improves the resync speed from 2.1MB/s to 44MB/s"
> echo 200000 > /sys/block/md0/md/sync_speed_min
> echo 200000 > /sys/block/md1/md/sync_speed_min
> echo 200000 > /sys/block/md2/md/sync_speed_min
> echo 200000 > /sys/block/md3/md/sync_speed_min
> echo 200000 > /sys/block/md4/md/sync_speed_min

md RAID1 resync reacts *extremely* badly to CFQ.  Just a data point, you may
want to check on it.  Might mean other RAID types also get screwed, and also
that md "check" is also disturbed by CFQ (or disturbs CFQ, whatever).

I reverted everything here to non-CFQ while the RAID did its resync (which
fixed all issues immediately), and we went back to 2.6.16.x later for other
reasons.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
