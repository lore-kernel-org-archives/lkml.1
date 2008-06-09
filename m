Return-Path: <linux-kernel-owner+w=401wt.eu-S1757395AbYFIGze@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757395AbYFIGze (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 02:55:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754765AbYFIGz0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 02:55:26 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:58146 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754771AbYFIGz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 02:55:26 -0400
Message-ID: <484CD406.9080607@bull.net>
Date: Mon, 09 Jun 2008 08:56:06 +0200
From: Nadia Derbey <Nadia.Derbey@bull.net>
Organization: BULL/DT/OSwR&D/Linux
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.6) Gecko/20040115
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Manfred Spraul <manfred@colorfullife.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] ipc/sem.c: convert undo structures to struct list_head
References: <200805241637.m4OGb1iL006199@mail.q-ag.de> <483EC50E.1020103@bull.net> <484A9FAB.5090202@colorfullife.com>
In-Reply-To: <484A9FAB.5090202@colorfullife.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Manfred Spraul wrote:
> Nadia Derbey wrote:
> 
>> Manfred Spraul wrote:
>>
>>> The undo structures contain two linked lists, the
>>> attached patch replaces them with generic struct list_head lists.
>>
>>
>> If I'm not wrong the undo list is a singly-linked list.
>> So here we are moving from a set of 4 pointers to a set of 8 pointers.
>> It's true that this makes the code much much more readable and clear, 
>> but I was wondering if it's worth?
>>
> IMHO yes: Everything is allocated on demand and memory is not that 
> expensive.
> 
> With regard to the asserts: I'm a big fan of asserts, I usually use them 
> to document the locking.

And you're completely right: when I see your new semaphore code, we can 
easily see what is the lock needed to protect a given field.

> Perhaps assert_spin_locked() should evalute to a nop() for 
> non-CONFIG_DEBUG builds?

Well, it's unconditionally defined as a BUG_ON(!spin_is_locked())

Regards,
Nadia




