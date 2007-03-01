Return-Path: <linux-kernel-owner+w=401wt.eu-S933276AbXCANHU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933276AbXCANHU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 08:07:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933287AbXCANHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 08:07:20 -0500
Received: from il.qumranet.com ([82.166.9.18]:56159 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933276AbXCANHT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 08:07:19 -0500
Message-ID: <45E6CF82.9090001@qumranet.com>
Date: Thu, 01 Mar 2007 15:05:06 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
CC: "Mathiasen, Torben" <Torben.Mathiasen@hp.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       kvm-devel <kvm-devel@lists.sourceforge.net>
Subject: Re: minor device number request for /dev/kvm (kernel-based virtual
 machine)
References: <45975F61.4070506@qumranet.com> <93C4769E3BED6B42B7203BD6F065654C08C5D6D3@dmoexc01.emea.cpqcorp.net> <45E6BFD0.1060003@qumranet.com> <Pine.LNX.4.61.0703011401370.23355@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0703011401370.23355@yvahk01.tjqt.qr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Mar 1 2007 13:58, Avi Kivity wrote:
>   
>> fs/char_dev.c:
>>     
>>> int register_chrdev(unsigned int major, const char *name,
>>>            const struct file_operations *fops)
>>> {
>>> struct char_device_struct *cd;
>>> struct cdev *cdev;
>>> char *s;
>>> int err = -ENOMEM;
>>>
>>> cd = __register_chrdev_region(major, 0, 256, name);
>>>       
>> So misc minor numbers under 256 are not supported.
>>
>> What's the way out?  Increase the region size?  I don't know if that's safe.
>>     
>
> If it does not increase memory usage, then possibly:
>
>   __register_chrdev_region(major, 0, (~0U) & MINORMASK, name);
>                                   or (1<<MINORMASK)-1 if that's more clear
>
>   

I'm more worried about something in the chardev bowels not supporting 
 >8bit minors well.


-- 
error compiling committee.c: too many arguments to function

