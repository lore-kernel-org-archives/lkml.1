Return-Path: <linux-kernel-owner+w=401wt.eu-S1764876AbYBGBJe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764876AbYBGBJe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 20:09:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758396AbYBGBJY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 20:09:24 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60327 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758349AbYBGBJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 20:09:23 -0500
Message-ID: <47AA5A3D.9070707@zytor.com>
Date: Wed, 06 Feb 2008 17:09:17 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Hasan Rashid <hasan@digitalpath.net>
CC: "'Maxim Levitsky'" <maximlevitsky@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Access MSR functions in userspace?
References: <200802070059.m170xqHv008164@terminus.zytor.com>
In-Reply-To: <200802070059.m170xqHv008164@terminus.zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hasan Rashid wrote:
> I am using kernel 2.4.32. Inside msr.c it is trying to register cpu/msr as
> shown here.
> 
> int __init msr_init(void)
> {
>   if (register_chrdev(MSR_MAJOR, "cpu/msr", &msr_fops)) {
>     printk(KERN_ERR "msr: unable to get major %d for msr\n",
> 	   MSR_MAJOR);
>     return -EBUSY;
>   }
>   
>   return 0;
> }
> 
> I did use the MAKEDEV script with the tools but since the msr module isn't
> trying to register at any of those locations, they don't work. 

Nonsense.  All that matters is major:minor.

> There is only one processor on my board, I am going to register device under
> cpu/0/msr and see if that solves the issue.

It's irrelevant where it "registers" (on your kernel it only affects 
/proc/devices, nothing else, unless you're using devfs, in which case, 
well, don't.)  The MAKEDEV script with the tools creates the appropriate 
device entries.

	-hpa
