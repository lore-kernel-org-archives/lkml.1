Return-Path: <linux-kernel-owner+w=401wt.eu-S1762473AbXGUIku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762473AbXGUIku (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 04:40:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932127AbXGUIkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 04:40:17 -0400
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:38565 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761798AbXGUIkO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 04:40:14 -0400
Date: Sat, 21 Jul 2007 10:40:52 +0200
From: Sebastian Siewior <sebastian@breakpoint.cc>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] compat_ioctl requires CONFIG_BLOCK
Message-ID: <20070721084052.GA6247@ayoka.breakpoint.cc>
References: <20070720225817.050195257@ayoka.breakpoint.cc> <200707210108.58478.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <200707210108.58478.arnd@arndb.de>
X-Key-Id: FE3F4706
X-Key-Fingerprint: FFDA BBBB 3563 1B27 75C9  925B 98D5 5C1C FE3F 4706
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Breakpoint-Spam-Score: -1.4
X-Breakpoint-Spam-Level: -
X-Breakpoint-Spam-Status: No , -1.4 points, 5.0 required,  ALL_TRUSTED=-1.44
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Arnd Bergmann | 2007-07-21 01:08:57 [+0200]:

>On Saturday 21 July 2007, Sebastian Siewior wrote:
>> 
>> Got with randconfig
>> include/linux/loop.h:66: error: expected specifier-qualifier-list before
>> 'request_queue_t'
>> make[1]: *** [fs/compat_ioctl.o] Error 1
>> 
>> parts of compat ioctl require CONFIG_BLOCK to be set.
>> 
>> Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>
>> Index: b/fs/compat_ioctl.c
>> ===================================================================
>> --- a/fs/compat_ioctl.c
>> +++ b/fs/compat_ioctl.c
>> @@ -63,7 +63,9 @@
>>  #include <linux/wireless.h>
>>  #include <linux/atalk.h>
>>  #include <linux/blktrace_api.h>
>> +#ifdef CONFIG_BLOCK
>>  #include <linux/loop.h>
>> +#endif
>
>Adding #ifdef around an #include is considered bad style. Better just
>make loop.h compile without any conditionals. Does the below
>patch work for you?
>
Yes it does.

>	Arnd <><

Sebastian

>
>--- a/include/linux/loop.h
>+++ b/include/linux/loop.h
>@@ -63,7 +63,7 @@ struct loop_device {
> 	struct task_struct	*lo_thread;
> 	wait_queue_head_t	lo_event;
> 
>-	request_queue_t		*lo_queue;
>+	struct request_queue	*lo_queue;
> 	struct gendisk		*lo_disk;
> 	struct list_head	lo_list;
> };

