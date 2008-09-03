Return-Path: <linux-kernel-owner+w=401wt.eu-S1755223AbYICSMP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755223AbYICSMP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 14:12:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752765AbYICSLz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 14:11:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54153 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755935AbYICSLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 14:11:54 -0400
Message-ID: <48BED351.1060300@zytor.com>
Date: Wed, 03 Sep 2008 11:11:29 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: device@lanana.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: regarding major number of block extended devt
References: <48BD30F9.6080108@kernel.org> <48BD3313.7090906@kernel.org> <48BD9F36.8000704@zytor.com> <48BE0EDB.20107@kernel.org> <48BEB759.4050503@zytor.com> <48BEB98C.8030303@kernel.org> <48BEBAF0.7070008@zytor.com> <48BEBF34.50006@kernel.org>
In-Reply-To: <48BEBF34.50006@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> H. Peter Anvin wrote:
>> Tejun Heo wrote:
>>> To use ext devt, the system has to use udev for device numbers.  As long
>>> as udev is used, the major number doesn't matter.
>> I'm sorry, but that's simply false.  There is a *lot* of code out there
>> that assumes you can determine what the device is by correlating the
>> major number with /proc/devices.
> 
> Then, we're between the rock and hard place then as there also is a
> lot of code which assumes certain layout of sd or hd minor numbers.
> Keeping only the major numbers doesn't really resolve any problem.  It
> may be able to mask a few but that can be more harmful than helpful.
> 

Thinking about it some more, one invariant this is *guaranteed* to 
violate is:

	partition_number = partition_device - master_device

Code that needs a partition number (which is common enough) are using 
this invariant, because (a) it has held for 17 years and (b) because 
there is still no alternative other that relying on fragile naming 
scheme hacks.

(a) we can't do anything about, but (b) we can, by introducing a 
partition number attribute in sysfs.

I would consider this a precondition for this.

	-hpa
