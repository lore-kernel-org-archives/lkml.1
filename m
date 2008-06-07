Return-Path: <linux-kernel-owner+w=401wt.eu-S1761776AbYFGOse@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761776AbYFGOse (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 10:48:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760673AbYFGOsQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 10:48:16 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:3990 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759792AbYFGOsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 10:48:15 -0400
Message-ID: <484A9FAB.5090202@colorfullife.com>
Date: Sat, 07 Jun 2008 16:48:11 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Nadia Derbey <Nadia.Derbey@bull.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] ipc/sem.c: convert undo structures to struct list_head
References: <200805241637.m4OGb1iL006199@mail.q-ag.de> <483EC50E.1020103@bull.net>
In-Reply-To: <483EC50E.1020103@bull.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nadia Derbey wrote:
> Manfred Spraul wrote:
>> The undo structures contain two linked lists, the
>> attached patch replaces them with generic struct list_head lists.
>
> If I'm not wrong the undo list is a singly-linked list.
> So here we are moving from a set of 4 pointers to a set of 8 pointers.
> It's true that this makes the code much much more readable and clear, 
> but I was wondering if it's worth?
>
IMHO yes: Everything is allocated on demand and memory is not that 
expensive.

With regard to the asserts: I'm a big fan of asserts, I usually use them 
to document the locking.
Perhaps assert_spin_locked() should evalute to a nop() for 
non-CONFIG_DEBUG builds?

--
    Manfred
