Return-Path: <linux-kernel-owner+w=401wt.eu-S1760540AbZCSVbn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760540AbZCSVbn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 17:31:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755349AbZCSVbe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 17:31:34 -0400
Received: from vms173007pub.verizon.net ([206.46.173.7]:43783 "EHLO
	vms173007pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755143AbZCSVbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 17:31:33 -0400
Message-id: <49C2B994.7040808@acm.org>
Date: Thu, 19 Mar 2009 16:31:00 -0500
From: Corey Minyard <minyard@acm.org>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-version: 1.0
To: Martin Wilck <martin.wilck@fujitsu-siemens.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       openipmi-developer@lists.sourceforge.net
Subject: Re: [PATCH] limit CPU time spent in kipmid
References: <49C27281.4040207@fujitsu-siemens.com>
In-reply-to: <49C27281.4040207@fujitsu-siemens.com>
Content-type: text/plain; charset=ISO-8859-15; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin, thanks for the patch.  I had actually implemented something like 
this before, and it didn't really help very much with the hardware I 
had, so I had abandoned this method.  There's even a comment about it in 
si_sm_result smi_event_handler(). Maybe making it tunable is better, I 
don't know.  But I'm afraid this will kill performance on a lot of systems.

Did you test throughput on this?  The main problem people had without 
kipmid was that things like firmware upgrades took a *long* time; adding 
kipmid improved speeds by an order of magnitude or more.

It's my opinion that if you want this interface to work efficiently with 
good performance, you should design the hardware to be used efficiently 
by using interrupts (which are supported and disable kipmid).  With the 
way the hardware is defined, you cannot have both good performance and 
low CPU usage without interrupts.

It may be possible to add an option to choose between performance and 
efficiency, but it will have to default to performance.

-corey

Martin Wilck wrote:
> Hello Corey, hi everyone,
>
> here is a patch that limits the CPU time spent in kipmid. I know that 
> it was previously stated that current kipmid "works as designed" (e.g. 
> http://lists.us.dell.com/pipermail/linux-poweredge/2008-October/037636.html), 
> yet users are irritated by the high amount of CPU time kipmid may use 
> up on current servers with many sensors, even though it is "nice" CPU 
> time. Moreover, kipmid busy-waiting for the KCS interface to become 
> ready also prevents CPUs from sleeping.
>
> The attached patch was developed and tested on an enterprise 
> distribution kernel where it caused the CPU load of kipmid to drop to 
> essentially 0 while still delivering reliable IPMI communication.
>
> I am looking forward for comments.
> Martin
>

