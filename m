Return-Path: <linux-kernel-owner+w=401wt.eu-S1755274AbYFNHVH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274AbYFNHVH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 03:21:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752399AbYFNHUw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 03:20:52 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:54128 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910AbYFNHUv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 03:20:51 -0400
Message-ID: <48537149.4040102@garzik.org>
Date: Sat, 14 Jun 2008 03:20:41 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Komuro <komurojun-mbn@nifty.com>
CC: Tejun Heo <htejun@gmail.com>,
       Dominik Brodowski <linux@dominikbrodowski.net>, jgarzik@redhat.com,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-pcmcia <linux-pcmcia@lists.infradead.org>,
       Kristoffer Ericson <kristoffer.ericson@gmail.com>
Subject: Re: [KERNEL 2.6.26-rc4]  bugreport : pata_pcmcia with Sandisk Extreme
 III 8GB
References: <20080528225049.9a134e0d.Kristoffer.Ericson@Gmail.com>	<20080528222740.GB20893@isilmar.linta.de>	<20080530135728.be02d3dc.Kristoffer.Ericson@Gmail.com>	<20080607223716.7d142072.komurojun-mbn@nifty.com>	<20080611072029.GB28692@comet.dominikbrodowski.net> <20080614120055.ad8fbee0.komurojun-mbn@nifty.com>
In-Reply-To: <20080614120055.ad8fbee0.komurojun-mbn@nifty.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Komuro wrote:
> Dear Tejun
> 
>>>>>> pcmcia: registering new device pcmcia1.1
>>>>>> 1.1: GetNextTuple: No more items
>>>>>> pata_pcmcia: probe of 1.1 failed with error -12
> 
> The patch "libata: kill hotplug related race condition"
> introduced the pata_pcmcia error.
> 
> Please fix this problem.
> 
> 
> Best Regards
> Komuro
> 
>>> f046519fc85a8fdf6a058b4ac9d897cdee6f3e52 is first bad commit
> commit f046519fc85a8fdf6a058b4ac9d897cdee6f3e52
> Author: Tejun Heo <htejun@gmail.com>
> Date:   Mon May 19 01:15:08 2008 +0900
> 
>     libata: kill hotplug related race condition
>     
>     Originally, whole reset processing was done while the port is frozen
>     and SError was cleared during @postreset().  This had two race
>     conditions.  1: hotplug could occur after reset but before SError is
>     cleared and libata won't know about it.  2: hotplug could occur after
>     all the reset is complete but before the port is thawed.  As all
>     events are cleared on thaw, the hotplug event would be lost.

Interesting!  Thanks for the diagnosis...

	Jeff



