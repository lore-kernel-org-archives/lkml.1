Return-Path: <linux-kernel-owner+w=401wt.eu-S1031203AbXDQRBd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031203AbXDQRBd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 13:01:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031204AbXDQRBd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 13:01:33 -0400
Received: from smtp4-g19.free.fr ([212.27.42.30]:57881 "EHLO smtp4-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031203AbXDQRBc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 13:01:32 -0400
Message-ID: <4624FD66.8000305@free.fr>
Date: Tue, 17 Apr 2007 19:01:26 +0200
From: John Sigler <linux.kernel@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061108 SeaMonkey/1.0.6
MIME-Version: 1.0
CC: linux-kernel@vger.kernel.org
Subject: Re: Disabling x86 System Management Mode
References: <46235447.3080000@free.fr> <p73odlo55q2.fsf@bingen.suse.de> <4624FA85.9010704@free.fr>
In-Reply-To: <4624FA85.9010704@free.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

John Sigler wrote:

> static int hello_init(void)
> {
>   int i;
>   int *lat;
>   printk(KERN_ALERT "INIT\n");
>   lat = kmalloc(MAX * sizeof *lat, GFP_KERNEL);
>   if (lat == NULL) return -1;
>   for (i=0; i < MAX; ++i) lat[i] = 0;
>   for (i=0; i < 5; ++i) foo();
>   for (i=0; i < N; ++i)
>   {
>     unsigned count, res;
>     set_current_state(TASK_INTERRUPTIBLE);
>     schedule_timeout(1);
>     foo();
>     local_irq_disable();
>     count = foo();
>     local_irq_enable();
>     res = count >> 8;
>     if (res < MAX) ++lat[res]; else printk(KERN_ALERT "OUT OF RANGE\n");
>   }
> 
>   for (i=0; i < MAX; ++i)
>     if (lat[i] != 0) printk(KERN_ALERT "%d %d\n", i<<8, lat[i]);

kfree(lat);

>   return 0;
> }

