Return-Path: <linux-kernel-owner+w=401wt.eu-S1753035AbXBKGEF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753035AbXBKGEF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 01:04:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753093AbXBKGEF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 01:04:05 -0500
Received: from wasp.net.au ([203.190.192.17]:39788 "EHLO wasp.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753035AbXBKGEE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 01:04:04 -0500
Message-ID: <45CEB1C9.5010103@wasp.net.au>
Date: Sun, 11 Feb 2007 10:03:53 +0400
From: Brad Campbell <brad@wasp.net.au>
User-Agent: Thunderbird 1.5.0.9 (X11/20070104)
MIME-Version: 1.0
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
CC: Alex Dubov <oakad@yahoo.com>, linux-kernel@vger.kernel.org
Subject: Re: Recent and not-so problems with tifm_sd driver - one more
References: <113489.35158.qm@web36703.mail.mud.yahoo.com> <45CDC22B.6040408@drzeus.cx>
In-Reply-To: <45CDC22B.6040408@drzeus.cx>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Ossman wrote:
> Alex Dubov wrote:
>> One more problem (you may already know about it) - I was contacted by somebody from the hald
>> project and indeed I can confirm that on 2.6.20 kernel hald fails to take action on card
>> insertion. I can't see anything in my code so this may be a general mmc problem.
>> The problem is described here:
>> http://lists.freedesktop.org/archives/hal/2007-January/006960.html
>>
> 
> Odd. This might be the whole sysfs restructuring thing causing problems. Can you
> check if that user has CONFIG_SYSFS_DEPRECATED on?

I've tested both with and without CONFIG_SYSFS_DEPRECATED on, both fail the same way.
hald reports that the device has no parent and decides to ignore it.

I've also tested both combinations against hal from ubuntu 6.06LTS and a more recent version

brad@bklaptop2:~$ hald --version
HAL package version: 0.5.8.1

Again with and without CONFIG_SYSFS_DEPRECATED and all combinations fail.
Hal appears to go looking for /sys/block/mmcblk0/mmcblk0p1/range

When it can't find it, it then looks for the parent of that to check what would be 
/sys/block/mmcblk0/range, Complains it can't find a parent for /sys/block/mmcblk0/mmcblk0p1 and just 
proceeds to ignore the event.

Brad
--
"Human beings, who are almost unique in having the ability
to learn from the experience of others, are also remarkable
for their apparent disinclination to do so." -- Douglas Adams
