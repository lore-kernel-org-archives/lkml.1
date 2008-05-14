Return-Path: <linux-kernel-owner+w=401wt.eu-S1758366AbYENV6o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758366AbYENV6o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 17:58:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752582AbYENV6f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 17:58:35 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37097 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751539AbYENV6d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 17:58:33 -0400
Message-ID: <482B6075.4030904@redhat.com>
Date: Wed, 14 May 2008 17:58:13 -0400
From: Steven Rostedt <srostedt@redhat.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20071019)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: mingo@elte.hu, acme@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2]: sparc64: Add ftrace support.
References: <20080513.220659.95712585.davem@davemloft.net>	<482AE9E2.6040801@redhat.com> <20080514.142932.95610533.davem@davemloft.net>
In-Reply-To: <20080514.142932.95610533.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Steven Rostedt <srostedt@redhat.com>
> Date: Wed, 14 May 2008 09:32:18 -0400
> 
>> If you add the following in arch/sparc64/kernel/Makefile
>>
>> ifdef CONFIG_DYNAMIC_FTRACE
>> obj-y += ftrace.o
>> # Do not trace the ftrace code itself
>> ORIG_CFLAGS := $(KBUILD_CFLAGS)
>> KBUILD_CFLAGS = $(if $(filter-out ftrace, $(basename $(notdir $@))), \
>> 	$(ORIG_CFLAGS), \
>> 	$(subst -pg,,$(ORIG_CFLAGS)))
>> endif
>>
>> Then you wont need the "notrace" annotations on the functions.
> 
> That frankly looks like crap compared to the simple "notrace"
> annotations in the *.c file.
> 
> This Makefile turd is in fact seemingly multiplying in various
> places in the ftrace tree, please reverse this trend.

I wish it wasn't so ugly. The Makefile scripts allow you to add more 
CFLAGS to specific files but does not have a way to remove generic 
flags. If there was a better way then I would love to do it.

The problem is that adding "notrace" on ever function that needs it, 
also becomes quite messy. Especially when you have files where all 
functions in the file needs a notrace and there is 40 or so small 
functions that this applies to.

To add flags to file foo.c one simply needs to do

CFLAGS_foo.o = -newflags

It would be nice to have something like

CFLAGS_REMOVE_foo.o = -pg

Perhaps that is possible to do. Then the above "Makefile turd" wont be 
so crappy.

-- Steve


