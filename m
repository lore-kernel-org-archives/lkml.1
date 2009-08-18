Return-Path: <linux-kernel-owner+w=401wt.eu-S1758484AbZHRKL2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758484AbZHRKL2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 06:11:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754329AbZHRKL1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 06:11:27 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:50696 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753633AbZHRKL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 06:11:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=JXGRmtzTyHfxFhDKLntXpgMgQCJMPAUH1gf3zFgF9zK8NMJ64CqNvsC5r79dgDVKM4
         I+mUXwDbOk9WoBF3tG9xQLq2tR389OfKRgCxon/m6Y+qRbmkVyhKWQDBIATDdak5WVC+
         y6UCwWL4g+S+GBQ/xt9RYj5hW5CW2NKcU5dbU=
Message-ID: <4A8A7D38.5020201@gmail.com>
Date: Tue, 18 Aug 2009 12:06:48 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Robert Schwebel <r.schwebel@pengutronix.de>
CC: Johannes Stezenbach <js@sig21.net>,
       Denys Vlasenko <vda.linux@googlemail.com>, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org,
       Arjan van de Ven <arjan@linux.intel.com>,
       Tim Bird <tim.bird@am.sony.com>, kernel@pengutronix.de
Subject: Re: New fast(?)-boot results on ARM
References: <20090814170228.GM13320@pengutronix.de> <1158166a0908141304y70300ab3p899b0d4609efded9@mail.gmail.com> <20090814204305.GA31727@pengutronix.de> <20090815103532.GA5596@sig21.net>
In-Reply-To: <20090815103532.GA5596@sig21.net>
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Stezenbach wrote:
> On Fri, Aug 14, 2009 at 10:43:05PM +0200, Robert Schwebel wrote:
>> On Fri, Aug 14, 2009 at 10:04:57PM +0200, Denys Vlasenko wrote:
>>>> rsc@thebe:~$ microcom | ptx_ts "U-Boot 2.0.0-rc9"
> 
>>>> [  7.137924] <  0.059316> starting udev
>>>> [  7.147925] <  0.010001> mounting tmpfs at /dev
>>>> [  7.182299] <  0.034374> creating static nodes
>>>> [  7.410613] <  0.228314> starting udevd...done
>>>> [  8.811097] <  1.400484> waiting for devices...done
> 
> And suddenly devtmpfs sounds like a good idea ;-)
> 
> We use static device nodes during boot, and later
> setup busybox mdev for hotplug.
> 
> 
> Johannes
> 

Yeah, I agree, do you really need udevd, device file creation at every
start-up in /dev? Usually static devices nodes and mdev for hotplug are
enough or at least you could use a simple script to create only once
time the devices file (mdev -s). About the fs, do you really need a
rootfs with ubifs? I mean, you could "split" your fs. You could use a
read-only fs (SquashFS for example) for your root-fs, ubifs for
permanent storage data (mounted under /data for example) and a ram fs
for volatile data.

Marco
