Return-Path: <linux-kernel-owner+w=401wt.eu-S1759773AbYCZQyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759773AbYCZQyS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 12:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757552AbYCZQyA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 12:54:00 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49299 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757368AbYCZQx7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 12:53:59 -0400
Message-ID: <47EA7F1D.9@redhat.com>
Date: Wed, 26 Mar 2008 12:51:41 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Emmanuel Florac <eflorac@intellique.com>
CC: Bill Davidsen <davidsen@tmr.com>, linux-kernel@vger.kernel.org
Subject: Re: RAID-1 performance under 2.4 and 2.6
References: <20080325194306.4ac71ff2@galadriel.home>	<47E975F8.3000702@redhat.com>	<47E98108.9000906@tmr.com>	<47E98712.6090203@redhat.com>	<47E98DE4.9000906@tmr.com> <20080326090527.42286e8e@galadriel.home>
In-Reply-To: <20080326090527.42286e8e@galadriel.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Emmanuel Florac wrote:
> Le Tue, 25 Mar 2008 19:42:28 -0400 vous écriviez:
> 
>> And this is what I was saying earlier, there is a trend to blame the 
>> benchmark when in fact the same benchmark runs well on 2.4. 
> 
> As I mentioned, it looks like 2.4 actually buffers write data on RAID-1
> which is inherently bad (after all if I do RAID-1 it's for the sake of
> data integrity, and write caching just counters that).
> However, how bad dd may be, it reflects broadly my problem : on small
> systems using software RAID, IO is overall way better with 2.4 than
> 2.6, especially NFS thruput.
> Though I can substantially enhance 2.6 performance through tweaking
> (playing with read ahead, disk queue length etc), it still lags behind
> 2.4 with defaults settings by a clear margin (10% or more).
> This isn't true - fortunately - of larger systems with 12, 24, 48 disks
> drives, hardware RAID, Fibre Channel and al. 
> 

This sounds more like a VM issue than a RAID issue.  I suspect the 
interesting difference between your small systems and your large systems 
is the amount of RAM, not the storage.  On small systems, the penalty 
for sizing caches incorrectly is much greater, so small systems tend to 
suffer more if the default tunings are a little off.

If you do some VM tuning (particularly in /proc/sys/vm) and find that it 
makes a large difference, please do report it.  Most of the exciting VM 
work is targeted to the high end, not the low end, so it's quite 
possible that the heuristics which choose default VM parameters at boot 
time are no longer as good for small systems as they once were.

-- Chris
