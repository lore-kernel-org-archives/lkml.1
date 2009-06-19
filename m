Return-Path: <linux-kernel-owner+w=401wt.eu-S1754811AbZFSN07@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811AbZFSN07 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 09:26:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752769AbZFSN0v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 09:26:51 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:18795 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303AbZFSN0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 09:26:50 -0400
Message-ID: <4A3B9219.3020803@hp.com>
Date: Fri, 19 Jun 2009 09:26:49 -0400
From: jim owens <jowens@hp.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Will Newton <will.newton@gmail.com>
CC: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: Mounting sysfs early
References: <87a5b0800906190415o1c70b6basfde98269dbacd00e@mail.gmail.com>
In-Reply-To: <87a5b0800906190415o1c70b6basfde98269dbacd00e@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Will Newton wrote:
> Hi all,
> 
> I currently have a problem with a driver that loads firmware from
> userland. The boot process happens in this order:
> 
> 1. Extract initramfs
> 2. Load drivers
> 3. Run init
> 
> Unfortunately it appears that step 2 is calling the hotplug helper
> which tries to load firmware via sysfs, but sysfs is not mounted until
> I have run init so the driver fails to initialise. What is the
> recommended way to avoid this situation? Do I have to somehow build
> the firmware into the kernel or can I get sysfs mounted before drivers
> begin loading?

you did not say what distro and kernel, but I would expect
sysfs is mounted before step 2 by the intrd.  this is what I
see in a rhel 4.3 I am testing.

what you might be really seeing is

http://bugzilla.kernel.org/show_bug.cgi?id=13178

which I am currently debugging.

jim
