Return-Path: <linux-kernel-owner+w=401wt.eu-S1758379AbZGHSG2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758379AbZGHSG2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 14:06:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754817AbZGHSGW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 14:06:22 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46098
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754007AbZGHSGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 14:06:22 -0400
Date: Wed, 08 Jul 2009 11:06:24 -0700 (PDT)
Message-Id: <20090708.110624.104984745.davem@davemloft.net>
To: michal.simek@petalogix.com
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, mingo@elte.hu,
       arnd@arndb.de, lethal@linux-sh.org, ltp-list@lists.sourceforge.net
Subject: Re: mmap hw behavior
From: David Miller <davem@davemloft.net>
In-Reply-To: <4A54DF6F.1010405@petalogix.com>
References: <4A54D14F.9090101@petalogix.com>
	<20090708.103520.193697491.davem@davemloft.net>
	<4A54DF6F.1010405@petalogix.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <michal.simek@petalogix.com>
Date: Wed, 08 Jul 2009 20:03:27 +0200

> David Miller wrote:
>> From: Michal Simek <michal.simek@petalogix.com>
>> Date: Wed, 08 Jul 2009 19:03:11 +0200
>>
>>   
>>> When I call mmap for that open file with pointer to calloc place
>>> (first parameter, + length zero) it should be one tlb invalidation
>>> for calloc and new tlb which connect open file.  We check it and we
>>> don't have any tlb invalidation that's why I think that kernel do
>>> different thigs.  Or is it there any copying? Or anything different?
>>>     
>>
>> There is no need to tlb flush the calloc area unless that memory area
>> is actually touched by the user application and thus the page is
>> faulted in.
>>   
> That calloc area is filled by any value (in that test). Is it mean that
> for this case when calloc area is touched
> there must be tlb invalidation + remapping?

Yes, if the calloc area is written to by the application, there
should be a tlb flush when the mmap() overrides that virtual region
with a different mapping.
