Return-Path: <linux-kernel-owner+w=401wt.eu-S2993180AbXEBWFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993180AbXEBWFA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 18:05:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766663AbXEBWFA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 18:05:00 -0400
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:35721
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993184AbXEBWEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 18:04:46 -0400
Message-ID: <463918BF.1050904@microgate.com>
Date: Wed, 02 May 2007 17:03:27 -0600
From: Paul Fulghum <paulkf@microgate.com>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tty add compat_ioctl method
References: <1177620717.5060.11.camel@amdx2.microgate.com> <200704270008.58811.arnd@arndb.de> <1178128321.9430.14.camel@amdx2.microgate.com> <200705022355.38975.arnd@arndb.de>
In-Reply-To: <200705022355.38975.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> 
> Looks ok mostly. Just some details:
> ...
>> +#ifdef CONFIG_COMPAT
>> +	long (*compat_ioctl)(struct tty_struct *tty, struct file * file,
>> +			     unsigned int cmd, unsigned long arg);
>> +#endif
> 
> I wouldn't hide this inside of an #ifdef. The structures are all static
> and therefore a single field per driver doesn't add much bload, but
> being able to always assign the .compat_ioctl pointer makes the code
> somewhat nicer

OK

>> --- a/drivers/char/tty_io.c	2006-11-29 15:57:37.000000000 -0600
>> +++ b/drivers/char/tty_io.c	2007-04-30 14:51:01.000000000 -0500
>> @@ -151,6 +151,9 @@ static int tty_open(struct inode *, stru
>>  static int tty_release(struct inode *, struct file *);
>>  int tty_ioctl(struct inode * inode, struct file * file,
>>  	      unsigned int cmd, unsigned long arg);
>> +#ifdef CONFIG_COMPAT
>> +long tty_compat_ioctl(struct file * file, unsigned int cmd, unsigned long arg);
>> +#endif
>>  static int tty_fasync(int fd, struct file * filp, int on);
>>  static void release_mem(struct tty_struct *tty, int idx);
> 
> declarations should never be hidden inside of an #ifdef. If you want to be
> extra clever here, you can do

OK, I have no problem with that.
A declaration without implementation won't generate a warning?

> #ifdef CONFIG_COMPAT
> long tty_compat_ioctl(struct file * file, unsigned int cmd, unsigned long arg);
> #else
> #define tty_compat_ioctl NULL
> #endif
> 
> then you don't need an #ifdef in the code setting the function pointers.

OK

>> +	tty = (struct tty_struct *)file->private_data;
> 
> no need for the cast, ->private_data is void*.

Yes, an easy fix.

--
Paul
