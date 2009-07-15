Return-Path: <linux-kernel-owner+w=401wt.eu-S1753095AbZGOJTY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753095AbZGOJTY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 05:19:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752185AbZGOJTY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 05:19:24 -0400
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:49429 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089AbZGOJTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 05:19:23 -0400
Message-ID: <4A5D9EB7.30603@linux.vnet.ibm.com>
Date: Wed, 15 Jul 2009 11:17:43 +0200
From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sysfs: fix hardlink count on device_move
References: <4A5CAA9F.1050302@linux.vnet.ibm.com> <20090714160447.GA1933@suse.de>
In-Reply-To: <20090714160447.GA1933@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Tue, Jul 14, 2009 at 05:56:15PM +0200, Peter Oberparleiter wrote:
>> From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
>>
>> Update directory hardlink count when moving kobjects to a new parent.
>> Fixes the following problem which occurs when several devices are
>> moved to the same parent and then unregistered:
>>
>>> ls -laF /sys/devices/css0/defunct/
>>> total 0
>>> drwxr-xr-x 4294967295 root root    0 2009-07-14 17:02 ./
>>> drwxr-xr-x        114 root root    0 2009-07-14 17:02 ../
>>> drwxr-xr-x          2 root root    0 2009-07-14 17:01 power/
>>> -rw-r--r--          1 root root 4096 2009-07-14 17:01 uevent
>> Signed-off-by: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
> 
> Thanks for the patch.
> 
> Is this something new in 2.6.31-rc, or does it also show up in .30
> and/or .27?

This is an old problem that existed since the introduction of 
sysfs_move_dir() in 2.6.20.

