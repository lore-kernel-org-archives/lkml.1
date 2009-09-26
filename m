Return-Path: <linux-kernel-owner+w=401wt.eu-S1753154AbZIZCvv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154AbZIZCvv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 22:51:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752840AbZIZCvv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 22:51:51 -0400
Received: from mail-yw0-f174.google.com ([209.85.211.174]:49901 "EHLO
	mail-yw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752839AbZIZCvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 22:51:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=EiZKW8E+91w5ENuL3tg8qk7GmtEcCuKBsugarVPjcf7zxZsRagbjzNQrL9Xwhm/tk8
         RjuiQ8SeSMbhtwEQuHmQlTHL+HtxHMoI9SKoetKByKQVLfLNk+3+6k6yAztoQGja4TR+
         uKLByta6gJ2QeMMFI3EE0LVKe2+6AjtQ7cOkI=
Message-ID: <4ABD81C8.7030803@gmail.com>
Date: Fri, 25 Sep 2009 20:51:52 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Ben Ryan <ben@impulse.net.au>
CC: linux-kernel@vger.kernel.org
Subject: Re: USB HDD boot panic (2.6.31)
References: <002701ca3d9b$53250240$f96f06c0$@net.au>
In-Reply-To: <002701ca3d9b$53250240$f96f06c0$@net.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2009 10:47 PM, Ben Ryan wrote:
> I've a question regarding boot from USB-attached IDE HDD under 2.6.31
> (slackware/lilo).
> Searches haven't shed much light on status or resolutions.
> Booting from this device throws:
>
>
> VFS: Cannot open root device "sda1" or unknown-block(0,0)
> Please append a correct "root=" boot option; here are the available
> partitions:
> .
> Kernel panic - not syncing: VFS: Unable to mount root fs on unknown
> block(0,)
>
>
> I notice that there's no /dev/sd(x) devices listed as possible roots in the
> error.
> I've tried a kernel build with all relevant drivers inbuilt (not modules).
> Tested on multiple machines with same result.
> This issue seems to have some history, earlier kernels had patches written
> for genhd.c (but I lack the skills to port them forward).
> Discussion here:
> http://lkml.indiana.edu/hypermail/linux/kernel/0405.0/0224.html
>
>  From what I can gather the USB drivers aren't finished initialising before
> the disks are enumerated and mapped to /dev.
>
> Is this a known, current issue?
> Does anyone have a patch that can help? If so, why isn't it mainlined?
> (Please CC responses!)

For this sort of setup you really need some sort of initrd that will 
wait until the devices are detected before trying to mount the root file 
system, rather than trying to have the kernel mount the root file system 
on the USB HD directly. The problem is that the USB device detection is 
asynchronous and the kernel doesn't really know when all possible USB 
devices have "shown up".
