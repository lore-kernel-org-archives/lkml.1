Return-Path: <linux-kernel-owner+w=401wt.eu-S1752130Ab0ATJ6G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130Ab0ATJ6G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 04:58:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751634Ab0ATJ6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 04:58:05 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:30068 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877Ab0ATJ6A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 04:58:00 -0500
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Date: Wed, 20 Jan 2010 10:57:08 +0100
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCH/RFC v1 0/2] Human readable performance event	description in
 sysfs
In-reply-to: <1263978999.4283.823.camel@laptop>
To: Peter Zijlstra <peterz@infradead.org>, Tomasz Fujak <t.fujak@samsung.com>
Cc: jpihet@mvista.com, p.osciak@samsung.com, jamie.iles@picochip.com,
       will.deacon@arm.com, linux-kernel@vger.kernel.org,
       kyungmin.park@samsung.com, mingo@elte.hu,
       linux-arm-kernel@lists.infradead.org, m.szyprowski@samsung.com
Message-id: <op.u6tslipz7p4s8u@pikus>
Organization: Samsung Electronics
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.10 (Linux)
References: <1263978706-15499-1-git-send-email-t.fujak@samsung.com>
 <1263978999.4283.823.camel@laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> The following patches provide a sysfs entry with hardware event human
>> readable description in the form of "0x%llx\t%lld-%lld\t%s\t%s" %
>> (event_value, minval, maxval, name, description) and means to populate
>> the file.
>>
>> The intended use is twofold: for users to read the list directly and
>> for tools (like perf).

On Wed, 20 Jan 2010 10:16:39 +0100, Peter Zijlstra <peterz@infradead.org> wrote:
> Why do this in kernel space? Listing available events seems like
> something we can do from userspace just fine.

IMO kernel knows better what hardware it's running on and user space
should not care and if this list were to be kept in user space it
would have to detect the processor it's running on and act accordingly.

Also, keeping the list in user space could lead to different software
maintaining separate lists which would get out of sync.  I think it's
easier to update a single list in kernel then wait till all the
software packages update theirs.

This also means that different tools would use different names and
descriptions for the events which would only increase confusion.

Moreover, since kernel already does the hard work of detecting CPU
it may provide a list as well.

But I'm just a humble coder, what do I know... ;)

-- 
Best regards,                                           _     _
  .o. | Liege of Serenely Enlightened Majesty of       o' \,=./ `o
  ..o | Computer Science,  Michał "mina86" Nazarewicz     (o o)
  ooo +---[mina86@mina86.com]---[mina86@jabber.org]---ooO--(_)--Ooo--
