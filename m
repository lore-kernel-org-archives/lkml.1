Return-Path: <linux-kernel-owner+w=401wt.eu-S1754159AbYK0AFG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159AbYK0AFG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 19:05:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752727AbYK0AEw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 19:04:52 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54929 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752531AbYK0AEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 19:04:51 -0500
Message-ID: <492DE3EF.8060507@zytor.com>
Date: Wed, 26 Nov 2008 16:03:59 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Alexander van Heukelum <heukelum@fastmail.fm>, lguest@ozlabs.org,
       jeremy@xensource.com, LKML <linux-kernel@vger.kernel.org>,
       Mike Travis <travis@sgi.com>, Cyrill Gorcunov <gorcunov@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       Ingo Molnar <mingo@elte.hu>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Lguest] [PATCH RFC/RFB] x86_64,	i386: interrupt dispatch changes
References: <20081104122839.GA22864@mailshack.com>	<20081104150729.GC21470@localhost>	<20081104170501.GE29626@one.firstfloor.org>	<1225822006.21441.1282961299@webmail.messagingengine.com>	<20081104204400.GC10825@elte.hu>	<1226243805.27361.1283784629@webmail.messagingengine.com> <49178E89.2000307@zytor.com> <492DC13F.8020009@redhat.com>
In-Reply-To: <492DC13F.8020009@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> 
>> Here is a prototype patch of the compressed IRQ stubs -- this patch
>> compresses them down to 7 stubs per 32-byte cache line (or part of cache
>> line) at the expense of a back-to-back jmp which has the potential of
>> being ugly on some pipelines (we can only get 4 stubs into 32 bytes
>> without that).
> 
> You could actually get 4-byte stubs, using a 16-bit call (66 e8 ww ww).  
> But it would be slower, since we won't be pairing it with a ret.
> 

Yes, I would consider that a theoretical exercise only :)

> I suspect we could get it down to three bytes, by sharing the last byte 
> of the four-byte call sequence with the first byte of the next:
> 
>  66 e8 ff 66 e8 fc 66 e8 f9 66 e8 f6 ...
> 
> Every three bytes a new stub begins; it's a four-byte call to offset 
> 0x6703 relative to the beginning of the first stub.
> 
> Can anyone better 24 bits/stub?

On the entirely silly level...

CC xx

	-hpa
