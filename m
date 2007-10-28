Return-Path: <linux-kernel-owner+w=401wt.eu-S1753312AbXJ1WKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312AbXJ1WKi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 18:10:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751287AbXJ1WKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 18:10:30 -0400
Received: from mailgw2.3essentials.com ([66.179.153.59]:1617 "EHLO
	mailgw2.3essentials.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154AbXJ1WK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 18:10:29 -0400
Message-ID: <472508B1.4000809@antonello.org>
Date: Sun, 28 Oct 2007 23:09:53 +0100
From: jack@antonello.org
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: "lists@antonello.org" <lists@antonello.org>,
       Samuel Tardieu <sam@rfc1149.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] backlight dimmer
References: <4724B48D.6090405@antonello.org>	<87y7dndxm3.fsf@willow.rfc1149.net>	<4724FF8F.30306@antonello.org> <20071028143445.4617efd8@laptopd505.fenrus.org>
In-Reply-To: <20071028143445.4617efd8@laptopd505.fenrus.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Sun, 28 Oct 2007 22:30:55 +0100
> "lists@antonello.org" <lists@antonello.org> wrote:
> 
>> Ok,
>>   now checkpatch.pl only complains about a missing signed-off-by.
>> Is this ok for review?
> 
> 
> hi,
> 
> when going over your patch.. is there a reason you introduce yet
> another timeout infrastructure? Is there something wrong with the
> existing ones that maybe should be fixed instead?
> Either way.. please put justification for such new mechanism in the
> patch changelog....
> 
> Greetings,
>    Arjan van de Ven
> 

hi,

i don't think there are similar infrastructures. This timeout is
not quite a timer.

The timeout starts counting when timeout_touch() is first called. At
this point the start() function is executed in non-atomic context.
Then either it is reset if timeout_touch() is called in time (and
thus starts to count again). Else it triggers, and executes the
trigger() function in non-atomic context and it stays idle unless
timeout_touch() is called again.

The non-atomic context is needed to use backlight.c mutexes and
that is enabled with the use of workqueues.

I don't mean to add some new infrastructure to the base kernel, but
it seemed a general functionality to me. In fact it may also be fully
included in backlight.c. Since backlight.h is in include/linux, i was
forced to put timeout.h in include/linux also. But this is just
a temporary fix.

jacopo

