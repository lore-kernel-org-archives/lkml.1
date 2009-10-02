Return-Path: <linux-kernel-owner+w=401wt.eu-S1754244AbZJBONB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754244AbZJBONB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 10:13:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753501AbZJBONA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 10:13:00 -0400
Received: from asmtpout012.mac.com ([17.148.16.87]:35537 "EHLO
	asmtpout012.mac.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487AbZJBOM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 10:12:59 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Cc: lenrek@me.com
Message-id: <0358338D-E697-4D44-96A8-E7107D50F77E@me.com>
From: lenrek@me.com
To: linux-kernel@vger.kernel.org
In-reply-to: <4AC5FE11.9060500@microgate.com>
Subject: Re: [PATCH] drivers/char/pcmcia/synclink_cs.c: BKL pushdown?
Date: Fri, 02 Oct 2009 23:12:52 +0900
References: <060E5EC8-93F4-4AF1-889F-04A13378CB8D@me.com>
 <20091002124945.1814a2c3@lxorguk.ukuu.org.uk> <4AC5FE11.9060500@microgate.com>
X-Mailer: Apple Mail (2.936)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 2009/10/02, at 22:20, Paul Fulghum wrote:

> Alan Cox wrote:
>> On Fri, 02 Oct 2009 19:37:21 +0900
>> lenrek@me.com wrote:
>>
>>> I found the counterpart of function mgslpc_wait_until_sent
>>> in drivers/char/synclinkmp.c (wait_until_sent) is modified to
>>> issue (un)lock_kernel.  This patch does the same modification.
>>>
>>> However, I'm afraid similar modifications are necessary further on
>>> functions
>>> mgslpc_ioctl and mgslpc_write_room.
>>
>> The push down work normally eliminated BKL calls that were  
>> demonstrably
>> not needed and left it in anywhere that needed thought. Do those
>> functions still really need the BKL ?
>
> No, these functions use a device specific spinlock (info->lock)
> when needed. Not even mgslpc_wait_until_sent needs BKL.

How about the BKL calls in synclinkmp.c, synclink.c, and synclink_gt.c?
Can they be safely eliminated?
