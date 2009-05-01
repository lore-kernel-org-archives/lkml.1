Return-Path: <linux-kernel-owner+w=401wt.eu-S1764398AbZEAWa5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764398AbZEAWa5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 18:30:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757740AbZEAWar
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 18:30:47 -0400
Received: from zcars04e.nortel.com ([47.129.242.56]:35701 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755616AbZEAWaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 18:30:46 -0400
Message-ID: <49FB780F.3030800@nortel.com>
Date: Fri, 01 May 2009 16:30:39 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Karl Pickett <karl.pickett@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: scheduler performance issue with irq load in 2.6.27
References: <f9be06770905011103lc43e5c5g62dc34671e9fcb47@mail.gmail.com>
In-Reply-To: <f9be06770905011103lc43e5c5g62dc34671e9fcb47@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 May 2009 22:30:44.0094 (UTC) FILETIME=[774499E0:01C9CAAC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Karl Pickett wrote:
> Running a server work load here.  Two e1000e nics, irqs set to cpu 2
> and cpu 3 by irqbalanced.  One proxy process that has 2 worker
> threads.
> Kernel 2.6.27.21-170.ns6.fc10.i686, (fedora 10 rebuilt with cut down config).
> 
> With no affinity settings.  Note how cpu1 is almost completely idle.
> Mbps = 730
> Cpu0  :  8.3%us, 14.7%sy,  0.0%ni, 74.7%id,  0.0%wa,  0.0%hi,  2.3%si,  0.0%st
> Cpu1  :  0.7%us,  2.7%sy,  0.0%ni, 96.3%id,  0.0%wa,  0.0%hi,  0.3%si,  0.0%st
> Cpu2  : 10.7%us, 25.1%sy,  0.0%ni, 13.7%id,  0.0%wa,  6.0%hi, 44.5%si,  0.0%st
> Cpu3  : 15.0%us, 28.3%sy,  0.0%ni, 23.0%id,  0.0%wa,  4.3%hi, 29.3%si,  0.0%st
> 
> 
> Setting the proxy threads affinity to cpu 0-1.  Note the cpu usage is
> more even and the box
> can handle more speed.
> Mbps = 850
> Cpu0  : 15.0%us, 36.3%sy,  0.0%ni, 41.7%id,  0.0%wa,  0.0%hi,  7.0%si,  0.0%st
> Cpu1  : 14.7%us, 38.7%sy,  0.0%ni, 39.0%id,  0.0%wa,  0.0%hi,  7.7%si,  0.0%st
> Cpu2  :  0.0%us,  0.0%sy,  0.0%ni, 38.2%id,  0.0%wa,  4.7%hi, 57.1%si,  0.0%st
> Cpu3  :  0.0%us,  0.3%sy,  0.0%ni, 61.8%id,  0.0%wa,  2.0%hi, 35.9%si,  0.0%st
> 
> I'm not seeing any thing I can tune scheduler wise here.


/proc/sys/kernel/sched_domain/cpuX/domainY/imbalance_pct

If you set that to something like 110 or so, it will increase the 
likelihood of balancing across cpus.

You may need to enable a config option, can't remember.

Chris
