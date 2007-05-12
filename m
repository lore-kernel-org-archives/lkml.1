Return-Path: <linux-kernel-owner+w=401wt.eu-S1757163AbXELFFq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757163AbXELFFq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 01:05:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755691AbXELFFk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 01:05:40 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:32285 "EHLO
	asav11.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755200AbXELFFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 01:05:39 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhQuABToREZKhRO4W2dsb2JhbACPdh0NBREB
From: Dmitry Torokhov <dtor@insightbb.com>
To: "Yin,Fengwei" <yfw.kernel@gmail.com>
Subject: Re: Is this a preempt issue in drivers/input/evdev.c
Date: Sat, 12 May 2007 01:05:40 -0400
User-Agent: KMail/1.9.3
Cc: linux-kernel@vger.kernel.org
References: <1178939925.14713.16.camel@localhost.localdomain>
In-Reply-To: <1178939925.14713.16.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705120105.40699.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Friday 11 May 2007 23:18, Yin,Fengwei wrote:
> 
> So if the evdev_release() is preempted at the point marked by another
> process which will open the evdev, which will make operation sequence
> like:
> 
>    --evdev->open in evdev_release()
>          -----> preempted
> 	                            evdev->open++ and input_open_devie()
> 	 <----- reschedule 
> 	input_close_device()
> 
> Should we introduce a mutex here? Or do I miss something? Thanks.
> 

Locking is completely absent in evdev. There was a patch introducing
locking in recent -mm's but it got dropped. I need to refresh it.

-- 
Dmitry
