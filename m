Return-Path: <linux-kernel-owner+w=401wt.eu-S965026AbXCAMAW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965026AbXCAMAW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 07:00:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965028AbXCAMAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 07:00:22 -0500
Received: from il.qumranet.com ([82.166.9.18]:39396 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965026AbXCAMAW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 07:00:22 -0500
Message-ID: <45E6BFD0.1060003@qumranet.com>
Date: Thu, 01 Mar 2007 13:58:08 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: "Mathiasen, Torben" <Torben.Mathiasen@hp.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       kvm-devel <kvm-devel@lists.sourceforge.net>
Subject: Re: minor device number request for /dev/kvm (kernel-based virtual
 machine)
References: <45975F61.4070506@qumranet.com> <93C4769E3BED6B42B7203BD6F065654C08C5D6D3@dmoexc01.emea.cpqcorp.net>
In-Reply-To: <93C4769E3BED6B42B7203BD6F065654C08C5D6D3@dmoexc01.emea.cpqcorp.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mathiasen, Torben wrote:
>>  10 char        Non-serial mice, misc features
>>     nnn = /dev/kvm  kernel-based virtual machine (hardware
>> virtualization extensions)
>>
>>     
>
> Major 10, minor 256 has been assigned to /dev/kvm. Let me know if this is nok okay.
>
>   

It doesn't work.  The culprit appears to be

drivers/char/misc.c:

    register_chrdev(MISC_MAJOR,"misc",&misc_fops)


which in turn means:


fs/char_dev.c:
> int register_chrdev(unsigned int major, const char *name,
>             const struct file_operations *fops)
> {
>     struct char_device_struct *cd;
>     struct cdev *cdev;
>     char *s;
>     int err = -ENOMEM;
>
>     cd = __register_chrdev_region(major, 0, 256, name);

So misc minor numbers under 256 are not supported.

What's the way out?  Increase the region size?  I don't know if that's safe.

-- 
error compiling committee.c: too many arguments to function

