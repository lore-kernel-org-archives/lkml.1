Return-Path: <linux-kernel-owner+w=401wt.eu-S1754384AbZFDTXl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754384AbZFDTXl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 15:23:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752309AbZFDTXb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 15:23:31 -0400
Received: from adelie.canonical.com ([91.189.90.139]:49751 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbZFDTXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 15:23:31 -0400
Message-ID: <4A281F33.80606@canonical.com>
Date: Thu, 04 Jun 2009 21:23:31 +0200
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: Matt Fleming <matt@console-pimps.org>
CC: Pierre Ossman <pierre@ossman.eu>, Jens Axboe <axboe@kernel.dk>,
       linux-kernel@vger.kernel.org, Andy Whitcroft <apw@canonical.com>
Subject: Re: [PATCH] mmc: prevent dangling block device from accessing	stale
 queues
References: <4A280BD4.9080908@canonical.com> <20090604202900.57f31d6a@mjolnir.ossman.eu> <4A2819DA.7040603@canonical.com> <20090604191513.GA5702@console-pimps.org>
In-Reply-To: <20090604191513.GA5702@console-pimps.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Fleming wrote:
> On Thu, Jun 04, 2009 at 09:00:42PM +0200, Stefan Bader wrote:
>> Hm, not sure this is what you wanted to know... On the launchpad report 
>> there are logs which I took with lots of printk's enabled. This shows that 
>> after resume the queue receives a request from mmcblk0 (which no longer 
>> exists) but uses the same pointer as mmcblk1 which was just created.
>>
> 
> Maybe I'm missing something, but why is the device instance being
> destroyed during a suspend? E.g why do you have mmcblk0 before suspend and
> mmcblk1 after suspend?

That is the way mmcblock works  (without unsafe resume set) in conjunction with 
( probably ) slow userspace. On suspend the block device is removed. But the 
mount is cleaned by (in that case hald) doing a forced unmount. The timeing 
seems to be that the unmount part is partially done on the way up.

-- 

When all other means of communication fail, try words!


