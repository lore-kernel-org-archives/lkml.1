Return-Path: <linux-kernel-owner+w=401wt.eu-S1757419AbZB0PZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757419AbZB0PZ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 10:25:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754209AbZB0PZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 10:25:16 -0500
Received: from mail.netone.net.tr ([193.192.98.182]:5595 "EHLO
	mail.turknet.net.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754021AbZB0PZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 10:25:14 -0500
Message-ID: <49A805D4.1090304@turknet.net.tr>
Date: Fri, 27 Feb 2009 17:25:08 +0200
From: Tarkan Erimer <tarkan.erimer@turknet.net.tr>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: linux-kernel@vger.kernel.org
Subject: Re: Failover Kernel
References: <49A659D0.2040903@turknet.net.tr> <20090226160311.GT5038@1wt.eu>
In-Reply-To: <20090226160311.GT5038@1wt.eu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Feb 2009 15:25:10.0405 (UTC) FILETIME=[93FA9B50:01C998EF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Willy Tarreau wrote:
> You forgot the most important thing : these two kernels will run on
> the same machine. I'm not even considering how you intend to schedule
> them. However, when a kernel crashes, it's often because of a hard
>   
A similar way as "kdump" did. Just putting a backup kernel into the 
memory and receiving keepalives by primary kernel. In normal conditions, 
backup kernel just will sit in its place, will monitor the status of 
primary kernel (alive or crashed) and will do nothing else more. So, no 
scheduling is required.
> error : bug in a driver, memory corruption, etc...  You cannot sanely
> recover from that. If the driver which crashed started to initiate a
> multi-word command to the device, in a lot of situations you'll need
> a reset to restore it in a known state. Memory corruption is even
> worse, as you cannot even trust the backup kernel.
>
>   
Hardware related issues are exceptions. If there could be a journal; 
maybe, it could be possible to recover sanely where the primary left. Of 
course, it's clear that this system will not work for all the scenarios 
(like bad hardware etc.).
> I'm currently using a backup kernel in our products, and do it with
> the boot loader. Some BIOSes allow you to start a watchdog timer on
> boot. Grub tries to load the first image, otherwise the second one.
> If either image crashes during boot, the hardware watchdog triggers
> and the machine reboots to the other image. That's extremely reliable,
> and relatively simple.
>  
> And using this method, you don't have any compatibility problems between
> your primary and secondary kernels.
>   
Yep, it's very simple way. But the problem is that, as you mentioned, 
watchdog is not supported on all the hardwares. If possible to 
implement, it will be platform/hardware independent system.


