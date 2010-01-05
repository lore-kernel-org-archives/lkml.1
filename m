Return-Path: <linux-kernel-owner+w=401wt.eu-S1755821Ab0AEUrk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755821Ab0AEUrk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 15:47:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755571Ab0AEUrj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 15:47:39 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44175
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755519Ab0AEUri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 15:47:38 -0500
Date: Tue, 05 Jan 2010 12:47:42 -0800 (PST)
Message-Id: <20100105.124742.244214607.davem@davemloft.net>
To: andi@firstfloor.org
Cc: heiko.carstens@de.ibm.com, arjan@infradead.org, arnd@arndb.de,
       mingo@elte.hu, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sparc: copy_from_user() should not return -EFAULT
From: David Miller <davem@davemloft.net>
In-Reply-To: <87skakbgy1.fsf@basil.nowhere.org>
References: <20100105053117.6a7c3377@infradead.org>
	<20100105152215.GD5480@osiris.boeblingen.de.ibm.com>
	<87skakbgy1.fsf@basil.nowhere.org>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <andi@firstfloor.org>
Date: Tue, 05 Jan 2010 18:27:18 +0100

> Heiko Carstens <heiko.carstens@de.ibm.com> writes:
> 
>> Subject: [PATCH] sparc: copy_from_user() should not return -EFAULT
>>
>> From: Heiko Carstens <heiko.carstens@de.ibm.com>
>>
>> Callers of copy_from_user() expect it to return the number of bytes
>> it could not copy. In no case it is supposed to return -EFAULT.
>>
>> In case of a detected buffer overflow just return the requested
>> length. In addition one could think of a memset that would clear
>> the size of the target object.
> 
> Ouch! I would expect this is likely exploitable, e.g. in mount

You can rest easy as the problem only exists in 2.6.33-rcX, it got
introduced when I ported over the compile time length validation bits
from x86.
