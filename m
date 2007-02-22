Return-Path: <linux-kernel-owner+w=401wt.eu-S932755AbXBVHlk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932755AbXBVHlk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 02:41:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932803AbXBVHlk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 02:41:40 -0500
Received: from nommos.sslcatacombnetworking.com ([67.18.224.114]:37996 "EHLO
	nommos.sslcatacombnetworking.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932755AbXBVHlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 02:41:39 -0500
In-Reply-To: <20070221133112.aec2bdac.akpm@linux-foundation.org>
References: <20070221125736.e5ff4206.akpm@linux-foundation.org> <Pine.LNX.4.44L0.0702211621310.3435-100000@iolanthe.rowland.org> <20070221133112.aec2bdac.akpm@linux-foundation.org>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <F2C532BC-C83A-4DD5-BACE-49F8CC11236C@kernel.crashing.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       <linux-usb-devel@lists.sourceforge.net>,
       Pete Zaitcev <zaitcev@redhat.com>, Greg KH <gregkh@suse.de>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
From: Kumar Gala <galak@kernel.crashing.org>
Subject: Re: [linux-usb-devel] 2.6.20 kernel hang with USB drive and vfat doing ftruncate
Date: Thu, 22 Feb 2007 01:40:29 -0600
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


On Feb 21, 2007, at 3:31 PM, Andrew Morton wrote:

> On Wed, 21 Feb 2007 16:22:17 -0500 (EST)
> Alan Stern <stern@rowland.harvard.edu> wrote:
>
>> On Wed, 21 Feb 2007, Andrew Morton wrote:
>>
>>>>> It seems like usb-storage and aio are completely off in the weeds.
>>>>> Ideas?
>>>>
>>>> It seems usb-storage should remove some kmalloc and use mempool 
>>>> () for
>>>> urb...  Is someone working on this? And idea?
>>>
>>> I think Pete said that we're supposed to be using GFP_NOIO in there.
>>
>> We _are_ using it.
>
> How admirably prompt.
>
>>> Not that it'll help much: the VM calls throttle_vm_writeout() for  
>>> GFP_NOIO
>>> and GFP_NOFS allocations, which is a bug.  Because if the caller  
>>> holds
>>> locks which prevent filesystem or IO progress, we deadlock.
>>>
>>> I'll fix the VM if someone else fixes USB ;)
>>
>> What else needs to be fixed?
>
> Would be nice if someone can confirm that this fixes it:

Doesn't seem to help my problem in a quick test, will get more data  
in the morning.

- k
