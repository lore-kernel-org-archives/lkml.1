Return-Path: <linux-kernel-owner+w=401wt.eu-S1752054AbXEYED5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054AbXEYED5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 00:03:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750724AbXEYEDt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 00:03:49 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:59877 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750715AbXEYEDt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 00:03:49 -0400
Message-ID: <4656602A.3010000@drzeus.cx>
Date: Fri, 25 May 2007 06:03:54 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Make prepare_namespace() wait for devices
References: <4655834F.3050301@drzeus.cx> <20070524170654.5d674474.akpm@linux-foundation.org>
In-Reply-To: <20070524170654.5d674474.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 24 May 2007 14:21:35 +0200
> Pierre Ossman <drzeus-list@drzeus.cx> wrote:
>
>   
>> +	/* wait for any asynchronous scanning to complete */
>> +	if ((ROOT_DEV == 0) && root_wait) {
>> +		printk(KERN_INFO "Waiting for root device %s...\n",
>> +			saved_root_name);
>> +		do {
>> +			while (driver_probe_done() != 0)
>> +				msleep(100);
>> +			ROOT_DEV = name_to_dev_t(saved_root_name);
>> +			if (ROOT_DEV == 0)
>> +				msleep(100);
>> +		} while (ROOT_DEV == 0);
>> +	}
>>     
>
> This seems overly complex.  Can't we simply do
>
>
> 	while (driver_probe_done() || ROOT_DEV == 0)
> 		msleep(100);
>
> ?
>   

How would ROOT_DEV get updated in that loop?

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org

