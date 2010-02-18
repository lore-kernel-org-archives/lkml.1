Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042Ab0BRJ3R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 04:29:17 -0500
Received: from one.firstfloor.org ([213.235.205.2]:50281 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509Ab0BRJ3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 04:29:14 -0500
Date: Thu, 18 Feb 2010 10:29:07 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Zachary Amsden <zamsden@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
       Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH] x86 rwsem optimization extreme
Message-ID: <20100218092907.GC5964@basil.fritz.box>
References: <1266443901-3646-1-git-send-email-zamsden@redhat.com> <alpine.LFD.2.00.1002171403160.4141@localhost.localdomain> <4B7C7BE4.9050908@zytor.com> <alpine.LFD.2.00.1002171743200.4141@localhost.localdomain> <4B7C9F0A.1080708@zytor.com> <4B7CC14F.7000802@redhat.com> <87iq9v55em.fsf@basil.nowhere.org> <4B7CF95A.4040706@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B7CF95A.4040706@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 17, 2010 at 10:24:58PM -1000, Zachary Amsden wrote:
>>
>> Zachary Amsden<zamsden@redhat.com>  writes
>>> Incidentally, the cost of putting all the rwsem code inline, using the
>>> straightforward approach, for git-tip, using defconfig on x86_64 is
>>> 3565 bytes / 20971778 bytes total, or 0.0168%, using gcc 4.4.3.
>>>      
>> The nice advantage of putting lock code inline is that it gets
>> accounted to the caller in all profilers.
>>
>> -Andi
>>
>>    
>
> Unfortunately, only for the uncontended case.  The hot case still ends up 
> in a call to the lock text section.

I removed those some time ago because it breaks unwinding.
Did that get undone?

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
