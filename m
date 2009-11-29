Return-Path: <linux-kernel-owner+w=401wt.eu-S1751346AbZK2FJm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751346AbZK2FJm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 00:09:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751082AbZK2FJm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 00:09:42 -0500
Received: from vitalin.sorra.shikadi.net ([64.71.152.201]:4448 "EHLO
	vitalin.sorra.shikadi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824AbZK2FJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 00:09:41 -0500
X-Greylist: delayed 588 seconds by postgrey-1.27 at vger.kernel.org; Sun, 29 Nov 2009 00:09:41 EST
Message-ID: <4B11FFCE.5050002@shikadi.net>
Date: Sun, 29 Nov 2009 14:59:58 +1000
From: Adam Nielsen <a.nielsen@shikadi.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-GB; rv:1.8.1.22) Gecko/20090809 Thunderbird/2.0.0.22 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: LKML Mailinglist <linux-kernel@vger.kernel.org>
Subject: Why does the disk still thrash when I have no swap?
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

My PC (x86_64) used to have 4GB RAM and 4GB swap.  I found that if I was doing 
something very memory-intensive it would thrash, in that the entire PC would 
grind to a halt while data was moved in and out of swap.  In some cases the PC 
would be unresponsive for over 12 hours when I would just give up and reboot.

To avoid this I decided to upgrade the system to 8GB of RAM and disable swap. 
  I figured the system should work fine without swap given that the total 
available memory hasn't changed, it's just that half of it used to be swap and 
now it's actual RAM.  It's been fine for about a year now.

I was just compiling KDE and had a couple of VirtualBoxes running, which 
appeared to max out my memory - it reached 6.9GB in use.  I say "appeared" to 
max out my memory because the entire system froze again and the disk was 
thrashing, just like it used to when I had swap enabled.

I eventually managed to suspend the compile job which stopped all disk 
activity, and told VirtualBox to grab a snapshot of the running VMs which took 
about 10 minutes (compared to the usual 10 seconds) with the disk being 
hammered the whole time and the system unusable (couldn't move the mouse 
cursor more than a few pixels a minute.)

Does anyone know what could have caused this 'thrash' to occur?  I have 
checked and definitely have swap disabled (/proc/swaps is empty) and I have no 
swap partitions on my disks anyway.  Could it be that the disk cache was 
forced to shrink and suddenly all accesses to the filesystem became unbuffered 
and incredibly slow?  Why would this stop the X11 mouse cursor from moving?

Thanks,
Adam.
