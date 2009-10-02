Return-Path: <linux-kernel-owner+w=401wt.eu-S1757886AbZJBNlL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757886AbZJBNlL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 09:41:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757864AbZJBNlK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 09:41:10 -0400
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:43502
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757862AbZJBNlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 09:41:09 -0400
X-Greylist: delayed 1136 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Oct 2009 09:41:09 EDT
Message-ID: <4AC5FE11.9060500@microgate.com>
Date: Fri, 02 Oct 2009 08:20:17 -0500
From: Paul Fulghum <paulkf@microgate.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: lenrek@me.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/char/pcmcia/synclink_cs.c: BKL pushdown?
References: <060E5EC8-93F4-4AF1-889F-04A13378CB8D@me.com> <20091002124945.1814a2c3@lxorguk.ukuu.org.uk>
In-Reply-To: <20091002124945.1814a2c3@lxorguk.ukuu.org.uk>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> On Fri, 02 Oct 2009 19:37:21 +0900
> lenrek@me.com wrote:
> 
>> I found the counterpart of function mgslpc_wait_until_sent
>> in drivers/char/synclinkmp.c (wait_until_sent) is modified to
>> issue (un)lock_kernel.  This patch does the same modification.
>>
>> However, I'm afraid similar modifications are necessary further on  
>> functions
>> mgslpc_ioctl and mgslpc_write_room.
> 
> The push down work normally eliminated BKL calls that were demonstrably
> not needed and left it in anywhere that needed thought. Do those
> functions still really need the BKL ?

No, these functions use a device specific spinlock (info->lock)
when needed. Not even mgslpc_wait_until_sent needs BKL.

-- 
Paul Fulghum
MicroGate Systems, Ltd.
=Customer Driven, by Design=
(800)444-1982
(512)345-7791 (Direct)
(512)343-9046 (Fax)
Central Time Zone (GMT -5h)
www.microgate.com
