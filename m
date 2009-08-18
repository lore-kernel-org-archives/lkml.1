Return-Path: <linux-kernel-owner+w=401wt.eu-S932739AbZHRCB2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932739AbZHRCB2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 22:01:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932530AbZHRCB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 22:01:27 -0400
Received: from rtr.ca ([76.10.145.34]:46966 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753278AbZHRCB0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 22:01:26 -0400
Message-ID: <4A8A0B76.1030800@rtr.ca>
Date: Mon, 17 Aug 2009 22:01:26 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Why does stat() return invalid st_dev field for btrfs ??
References: <4A89C1DA.6040601@rtr.ca> <ac3eb2510908171729k2e53914fu6ffe49483310aeba@mail.gmail.com>
In-Reply-To: <ac3eb2510908171729k2e53914fu6ffe49483310aeba@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kay Sievers wrote:
> On Mon, Aug 17, 2009 at 22:47, Mark Lord<lkml@rtr.ca> wrote:
>> Chris / list,
>>
>> stat(2) seems to return invalid major/minor device info
>> for btrfs filesystems.
>>
>> Why?  Is this a bug?
> 
> This is not invalid and not a bug. It's a superblock without a device,
> and expected behavior.
> 
> There is no one-to-one relation from a btrfs mountpoint to a device,
> it's a tree, and therefore therefore there can not be a single
> major/minor.
..

Sure there is for the most common case.
When there is only a single device, stat() should return that device.
When there are several, it should do something different.

But really, it should be using DM/LVM when there are multiple devices.
