Return-Path: <linux-kernel-owner+w=401wt.eu-S933265AbXCANEs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933265AbXCANEs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 08:04:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933276AbXCANEs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 08:04:48 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:57477 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933265AbXCANEs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 08:04:48 -0500
Date: Thu, 1 Mar 2007 14:03:07 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Avi Kivity <avi@qumranet.com>
cc: "Mathiasen, Torben" <Torben.Mathiasen@hp.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       kvm-devel <kvm-devel@lists.sourceforge.net>
Subject: Re: minor device number request for /dev/kvm (kernel-based virtual
 machine)
In-Reply-To: <45E6BFD0.1060003@qumranet.com>
Message-ID: <Pine.LNX.4.61.0703011401370.23355@yvahk01.tjqt.qr>
References: <45975F61.4070506@qumranet.com>
 <93C4769E3BED6B42B7203BD6F065654C08C5D6D3@dmoexc01.emea.cpqcorp.net>
 <45E6BFD0.1060003@qumranet.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 1 2007 13:58, Avi Kivity wrote:
>
> fs/char_dev.c:
>> int register_chrdev(unsigned int major, const char *name,
>>            const struct file_operations *fops)
>> {
>> struct char_device_struct *cd;
>> struct cdev *cdev;
>> char *s;
>> int err = -ENOMEM;
>> 
>> cd = __register_chrdev_region(major, 0, 256, name);
>
> So misc minor numbers under 256 are not supported.
>
> What's the way out?  Increase the region size?  I don't know if that's safe.

If it does not increase memory usage, then possibly:

  __register_chrdev_region(major, 0, (~0U) & MINORMASK, name);
                                  or (1<<MINORMASK)-1 if that's more clear


Jan
-- 
