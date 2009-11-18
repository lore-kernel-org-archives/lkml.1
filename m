Return-Path: <linux-kernel-owner+w=401wt.eu-S932439AbZKRVoG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932439AbZKRVoG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 16:44:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932370AbZKRVoF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 16:44:05 -0500
Received: from mx03.syneticon.net ([78.111.66.105]:53574 "EHLO
	mx03.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932351AbZKRVoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 16:44:04 -0500
Message-ID: <4B046AEA.80109@wpkg.org>
Date: Wed, 18 Nov 2009 22:45:14 +0100
From: Tomasz Chmielewski <mangoo@wpkg.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20091009)
MIME-Version: 1.0
To: preining@logic.at, riel@redhat.com, dan.merillat@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.31 - very swap-happy with plenty of free RAM
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Norbert Preining wrote:

> So what normally trashed my system to a quasi halt I tried after a swapoff -a,
> *two* svn up of really big repositories (some Gb), plus starting 
> VirtualBox Windows XP with 1Gb virtual RAM on a 2Gb machine.
> 
> And see hoho, no problem at all. Everything remains responsive and happy.
> The memory was never above 60% in use, but 40% in cache, and all 
> without any problems.
> 
> So that seems to be a real bug.
> 
> I am running currently 2.6.32-rc7, but experienced that already in the
> 31-rc version. Hard to pinpoint exactely where it happens.

Similar here (with 2.6.31.6 kernel).

I have a pretty powerful desktop machine with 8 GB RAM, fast disks with 
RAID-1 etc.

It runs 5 (mostly idle) KVM machines, Firefox, Thunderbird, KDE4, image 
editing program, multiseat X session. Around 6 GB of RAM used when 
caches/buffers are excluded.

Every 10 minutes or so, machine is really unresponsive, load jumps to 10 
or 20. Mouse pointer jumps, it's impossible to change between windows etc.

Do a "swapoff -a", and everything is snappy and responsive as it should, 
there are no more lags.

I noticed that with swap disabled, "Dirty" (in /proc/meminfo) is way 
below 100 MB (usually, 50 MB or so).
With swap enabled, it "Dirty" is usually around 300-500-700 MB, and from 
time to time, the system basically thrashes the disks, and everything is 
unresponsive.
Similar to uncompressing a big tar archive - lots of IO, system 
unresponsive.

BTW, did you try:

echo 0 > /proc/sys/vm/swappiness
swapoff -a
swapon -a


-- 
Tomasz Chmielewski
http://wpkg.org

