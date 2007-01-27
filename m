Return-Path: <linux-kernel-owner+w=401wt.eu-S1751580AbXA0Mtx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751580AbXA0Mtx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 07:49:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751685AbXA0Mtx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 07:49:53 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:41941 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564AbXA0Mtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 07:49:53 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <45BB4A33.4070206@s5r6.in-berlin.de>
Date: Sat, 27 Jan 2007 13:48:51 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.9) Gecko/20070121 SeaMonkey/1.0.7
MIME-Version: 1.0
To: Pieter Palmers <pieterp@joow.be>
CC: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [RFC] cycle timer read extension for raw1394/libraw1394
References: <45BA5CFD.6070900@joow.be> <45BB27AF.7030007@s5r6.in-berlin.de> <45BB2D67.7030608@joow.be>
In-Reply-To: <45BB2D67.7030608@joow.be>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pieter Palmers wrote:
> Stefan Richter wrote:
>> Thus?
>>     preempt_disable();
>>     local_irq_save(flags);
>>
>>     read_cycle_timer;
>>     read_time_of_day;
>>
>>     local_irq_restore(flags);
>>     preempt_enable();
>>
>> in hpsb_read_cycle_timer.
> My main issue was that I still had to figure out how to do this... I'm a
>  very occasional kernel space programmer.

Unfortunately me too, and the level of ieee1394 driver maintenance shows it.

> Thanks for the hint, I'll do it like this.
> 
> I still have to check if I don't introduce a too long non-preemptible
> path though.

It's a simple MMIO read (readl) and the do_gettimeofday, which should be
fine.
-- 
Stefan Richter
-=====-=-=== ---= ==-==
http://arcgraph.de/sr/
