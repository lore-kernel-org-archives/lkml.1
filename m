Return-Path: <linux-kernel-owner+w=401wt.eu-S1754161AbYK0KTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161AbYK0KTV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 05:19:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752500AbYK0KTM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 05:19:12 -0500
Received: from mx2.redhat.com ([66.187.237.31]:59340 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752416AbYK0KTL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 05:19:11 -0500
Message-ID: <492E72D7.9060201@redhat.com>
Date: Thu, 27 Nov 2008 12:13:43 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Alexander van Heukelum <heukelum@fastmail.fm>, lguest@ozlabs.org,
       jeremy@xensource.com, LKML <linux-kernel@vger.kernel.org>,
       Mike Travis <travis@sgi.com>, Cyrill Gorcunov <gorcunov@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       Ingo Molnar <mingo@elte.hu>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Lguest] [PATCH RFC/RFB] x86_64,	i386: interrupt dispatch changes
References: <20081104122839.GA22864@mailshack.com>	<20081104150729.GC21470@localhost>	<20081104170501.GE29626@one.firstfloor.org>	<1225822006.21441.1282961299@webmail.messagingengine.com>	<20081104204400.GC10825@elte.hu>	<1226243805.27361.1283784629@webmail.messagingengine.com> <49178E89.2000307@zytor.com> <492DC13F.8020009@redhat.com> <492DE3EF.8060507@zytor.com>
In-Reply-To: <492DE3EF.8060507@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
>
>> I suspect we could get it down to three bytes, by sharing the last 
>> byte of the four-byte call sequence with the first byte of the next:
>>
>>  66 e8 ff 66 e8 fc 66 e8 f9 66 e8 f6 ...
>>
>> Every three bytes a new stub begins; it's a four-byte call to offset 
>> 0x6703 relative to the beginning of the first stub.
>>
>> Can anyone better 24 bits/stub?
>
> On the entirely silly level...
>
> CC xx

Nice.  Can actually go to zero, by pointing the IDT at (unmapped_area + 
vector), and deducing the vector in the page fault handler from cr2.

-- 
error compiling committee.c: too many arguments to function

