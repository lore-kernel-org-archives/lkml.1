Return-Path: <linux-kernel-owner+w=401wt.eu-S1752122AbZKSGlu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752122AbZKSGlu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 01:41:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752020AbZKSGlt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 01:41:49 -0500
Received: from mx03.syneticon.net ([78.111.66.105]:51654 "EHLO
	mx03.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990AbZKSGlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 01:41:49 -0500
Message-ID: <4B04E8F6.3000004@wpkg.org>
Date: Thu, 19 Nov 2009 07:43:02 +0100
From: Tomasz Chmielewski <mangoo@wpkg.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20091009)
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: Sven-Haegar Koch <haegar@sdinet.de>, Dan Merillat <dan.merillat@gmail.com>,
       preining@logic.at, riel@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.31 - very swap-happy with plenty of free RAM
References: <4B046AEA.80109@wpkg.org> <c0c067900911181640h64971680l4da14cdbe9fa6d59@mail.gmail.com> <alpine.DEB.2.00.0911190200370.32644@aurora.sdinet.de> <20091119013810.GO9467@discord.disaster>
In-Reply-To: <20091119013810.GO9467@discord.disaster>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Chinner wrote:

>>>> I have a pretty powerful desktop machine with 8 GB RAM, fast disks with
>>>> RAID-1 etc.
>>>> Every 10 minutes or so, machine is really unresponsive, load jumps to 10 or
>>>> 20. Mouse pointer jumps, it's impossible to change between windows etc.
>>> This is the type of hefty workstation many of the core developers
>>> have, running similar workloads, so I'm somewhat surprised that the
>>> default VM settings have this kind of issue.
>>>
>>>> Do a "swapoff -a", and everything is snappy and responsive as it should,
>>>> there are no more lags.
>>> Yes, that's my exact finding.
>>>
>>> Is this weird IO storm happening for anyone else with plenty of memory
>>> (for their taskload?)
>> For me it happend on my laptop. 3gb RAM, and a 1gb VMWare Windows-XP 
>> instance running, plus the usual like firefox, thunderbird, kde4.
>>
>> Without running vmware it did not happen. And since I have now disabled 
>> barriers on the xfs /home partition (on luks crypto lvm) it also does 
>> not happen anymore.
> 
> Yeah, it looks like dm-crypt recently started supporting barriers in
> commit 647c7db14ef9cacc4ccb3683e206b61f0de6dc2b. Hence XFS will have
> detected barriers work at mount time mount and so is now issuing
> them.
> 
> Similarly, raid1 (mirror) has recently gained barrier support so
> the same issue can be seen there.

What is also interesting, that a normal software RAID-1 sync (i.e. from 
a degraded state) does not seem to make any visible effect on system 
responsiveness.

Uncompress a big tar file, or VM writes out lots of data - system 
becomes really unresponsive.


-- 
Tomasz Chmielewski
http://wpkg.org
