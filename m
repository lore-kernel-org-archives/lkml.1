Return-Path: <linux-kernel-owner+w=401wt.eu-S1751752AbXBVSVd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751752AbXBVSVd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 13:21:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751750AbXBVSVd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 13:21:33 -0500
Received: from nommos.sslcatacombnetworking.com ([67.18.224.114]:53663 "EHLO
	nommos.sslcatacombnetworking.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751748AbXBVSVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 13:21:31 -0500
In-Reply-To: <F2C532BC-C83A-4DD5-BACE-49F8CC11236C@kernel.crashing.org>
References: <20070221125736.e5ff4206.akpm@linux-foundation.org> <Pine.LNX.4.44L0.0702211621310.3435-100000@iolanthe.rowland.org> <20070221133112.aec2bdac.akpm@linux-foundation.org> <F2C532BC-C83A-4DD5-BACE-49F8CC11236C@kernel.crashing.org>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <0305C117-1099-49EA-B0F3-C0E31E18A19A@kernel.crashing.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       USB development list <linux-usb-devel@lists.sourceforge.net>,
       Pete Zaitcev <zaitcev@redhat.com>, Greg KH <gregkh@suse.de>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
From: Kumar Gala <galak@kernel.crashing.org>
Subject: Re: [linux-usb-devel] 2.6.20 kernel hang with USB drive and vfat doing ftruncate
Date: Thu, 22 Feb 2007 12:20:06 -0600
To: Andrew Morton <akpm@linux-foundation.org>
X-Mailer: Apple Mail (2.752.2)
X-PopBeforeSMTPSenders: kumar-chaos@kgala.com,kumar-statements@kgala.com,kumar@kgala.com
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - nommos.sslcatacombnetworking.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [0 0] / [47 12]
X-AntiAbuse: Sender Address Domain - kernel.crashing.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>>> Not that it'll help much: the VM calls throttle_vm_writeout()  
>>>> for GFP_NOIO
>>>> and GFP_NOFS allocations, which is a bug.  Because if the caller  
>>>> holds
>>>> locks which prevent filesystem or IO progress, we deadlock.
>>>>
>>>> I'll fix the VM if someone else fixes USB ;)
>>>
>>> What else needs to be fixed?
>>
>> Would be nice if someone can confirm that this fixes it:
>
> Doesn't seem to help my problem in a quick test, will get more data  
> in the morning.

Well, I didn't realize the patch you sent via mm-commits and the one  
here are actually different.  I noticed that mm-commits one has:

+       if ((gfp_mask & (__GFP_FS|__GFP_IO)) != __GFP_FS|__GFP_IO) {

vs

+       if ((gfp_mask & (__GFP_FS|__GFP_IO)) != (__GFP_FS|__GFP_IO)) {

The second seems to make more sense.  I tested with the first last  
night which didn't help.

With the proper patch in place things look good.  Is this a candidate  
for 2.6.20-stable?

- k
