Return-Path: <linux-kernel-owner+w=401wt.eu-S1754033AbYFKMXZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033AbYFKMXZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 08:23:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752245AbYFKMXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 08:23:16 -0400
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:36880 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751056AbYFKMXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 08:23:15 -0400
Message-ID: <484FC3C4.3070800@lwfinger.net>
Date: Wed, 11 Jun 2008 07:23:32 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, vegard.nossum@gmail.com,
       miles.lane@gmail.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: BUG: NULL pointer dereference at 00000000 -- IP: [<f8e783d5>]
 :b43:b43_dma_mapping_error+0x16/0x155
References: <200806101637.11473.mb@bu3sch.de> <200806101650.27180.mb@bu3sch.de> <20080611095844J.fujita.tomonori@lab.ntt.co.jp> <200806111205.10433.mb@bu3sch.de>
In-Reply-To: <200806111205.10433.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Buesch wrote:
> On Wednesday 11 June 2008 02:58:44 FUJITA Tomonori wrote:
>> On Tue, 10 Jun 2008 16:50:26 +0200
>> Michael Buesch <mb@bu3sch.de> wrote:
>>
>>> On Tuesday 10 June 2008 16:42:41 Vegard Nossum wrote:
>>>> This change comes from
>>>>
>>>> commit 353c409463ecba63c3a41a992d3f5fba935eada9
>>>> Author: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
>>>> Date:   Fri May 23 19:02:30 2008 +0000
>>>
>>> Ok, FUJITA Tomonori, please make sure a patch like the following goes
>>> into the same trees that you submitted commit 353c409 to.
>>> Also make sure to check b43legacy. I _guess_ you might have added
>>> the same bug there.
>> Ah, sorry about the bug.
>>
>> From a quick look, mainline needs the same fix too?
>>
>> b43_dma_mapping_error calls unmap_descbuffer() on the failure, which
>> assumes that ring->dev is set up properly.
> 
> Yeah ok. That's an unlikely error path.
> The new bug is in the main path which will always trigger.
> 
> Next time please send _any_ patch for review to me and to the wireless list.
> Please tell me which trees this bug has been merged to. Is it already in
> Linus' tree?

The equivalent line in Linus's tree is "if 
(unlikely(dma_mapping_error(addr)))", thus the error has not reached 
mainline (yet?).

Larry

