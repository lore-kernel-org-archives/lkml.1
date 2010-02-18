Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189Ab0BRIZe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 03:25:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31418 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752118Ab0BRIZd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 03:25:33 -0500
Message-ID: <4B7CF95A.4040706@redhat.com>
Date: Wed, 17 Feb 2010 22:24:58 -1000
From: Zachary Amsden <zamsden@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
       Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH] x86 rwsem optimization extreme
References: <1266443901-3646-1-git-send-email-zamsden@redhat.com>	<alpine.LFD.2.00.1002171403160.4141@localhost.localdomain>	<4B7C7BE4.9050908@zytor.com>	<alpine.LFD.2.00.1002171743200.4141@localhost.localdomain>	<4B7C9F0A.1080708@zytor.com> <4B7CC14F.7000802@redhat.com> <87iq9v55em.fsf@basil.nowhere.org>
In-Reply-To: <87iq9v55em.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> Zachary Amsden<zamsden@redhat.com>  writes
>> Incidentally, the cost of putting all the rwsem code inline, using the
>> straightforward approach, for git-tip, using defconfig on x86_64 is
>> 3565 bytes / 20971778 bytes total, or 0.0168%, using gcc 4.4.3.
>>      
> The nice advantage of putting lock code inline is that it gets
> accounted to the caller in all profilers.
>
> -Andi
>
>    

Unfortunately, only for the uncontended case.  The hot case still ends 
up in a call to the lock text section.

Zach
