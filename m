Return-Path: <linux-kernel-owner+w=401wt.eu-S932246AbXFEJG0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932246AbXFEJG0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 05:06:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762368AbXFEJGS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 05:06:18 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:33663 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762077AbXFEJGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 05:06:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=DiX5K8htd4RjzhrgZfOOEG4AjMolb+H1kWfy+g8sykemxo/67FsHXtMZYHvwrEHq/Gut1twlufYexAvR0JT3SqsjmeEbm6bKQElCQU4ygVwRT1DANVvJKgPAOTJUznUovxtT4AnFt8+H7Xv2iDZ6qw3EOu8AWuUNMswMaG5xIZE=
Message-ID: <6278d2220706050206q1f50d1b1ncac98b769331988@mail.gmail.com>
Date: Tue, 5 Jun 2007 10:06:15 +0100
From: "Daniel J Blueman" <daniel.blueman@gmail.com>
To: "Mike Richards" <mrmikerich@gmail.com>
Subject: Re: To swap or not to swap?
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 Jun, 05:40, "Mike Richards" <mrmikerich@gmail.com> wrote:
> Here's something that's been bugging me for a while now...
>
> I have several Linux servers that have been given enough RAM that they
> rarely ever use any swap space. For example, here's the typical output
> of uptime and free:
>
> root@veronica$ uptime; free
>  03:55:33 up 225 days, 17:34,  0 users,  load average: 0.09, 0.13, 0.19
>              total       used       free     shared    buffers     cached
> Mem:       2076136    1931288     144848          0     150220     964108
> -/+ buffers/cache:     816960    1259176
> Swap:       524280        156     524124
>
> As you can see, it's been up for the better part of a year and is only
> using 156k of swap. The swappiness is set to the default of 60, so
> there's no reason why the server *shouldn't* be using swap -- it just
> never does.
>
> On some of my older servers with a little less RAM and the 2.4 kernel
> I'll occasionally see the swap go up into the double digits, but even
> this is relatively infrequent. On all the machines with a 2.6 kernel
> and 2GB+ RAM, I've almost never seen more than 1-2MB swap used.
[snip]
> The consensus these days seems to be that since hard drives are so big
> now, go with a gig or more of swap even if you have plenty of RAM.
> However, the way I'm seeing it is this: What's the point of having a
> gig of swap if it only gets used during the worst possible time?

Provided you won't be running an application which will require all
the memory, I've found 256MB swap on small (1GB mem) and larger (8GB)
servers to be adequate, but this clearly depends on what you're
running.

The idea would be to allow linux to swap out cold pages which are
(almost) never accessed while runaway processes get selected by the
OOM killer sooner. You may find 512MB to be more useful on large
untuned servers with lots of processes perhaps.

Daniel
-- 
Daniel J Blueman
