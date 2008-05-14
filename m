Return-Path: <linux-kernel-owner+w=401wt.eu-S1756219AbYENV3y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219AbYENV3y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 17:29:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751378AbYENV3n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 17:29:43 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59667
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750828AbYENV3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 17:29:42 -0400
Date: Wed, 14 May 2008 14:29:32 -0700 (PDT)
Message-Id: <20080514.142932.95610533.davem@davemloft.net>
To: srostedt@redhat.com
Cc: mingo@elte.hu, acme@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2]: sparc64: Add ftrace support.
From: David Miller <davem@davemloft.net>
In-Reply-To: <482AE9E2.6040801@redhat.com>
References: <20080513.220659.95712585.davem@davemloft.net>
	<482AE9E2.6040801@redhat.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>
Date: Wed, 14 May 2008 09:32:18 -0400

> If you add the following in arch/sparc64/kernel/Makefile
> 
> ifdef CONFIG_DYNAMIC_FTRACE
> obj-y += ftrace.o
> # Do not trace the ftrace code itself
> ORIG_CFLAGS := $(KBUILD_CFLAGS)
> KBUILD_CFLAGS = $(if $(filter-out ftrace, $(basename $(notdir $@))), \
> 	$(ORIG_CFLAGS), \
> 	$(subst -pg,,$(ORIG_CFLAGS)))
> endif
> 
> Then you wont need the "notrace" annotations on the functions.

That frankly looks like crap compared to the simple "notrace"
annotations in the *.c file.

This Makefile turd is in fact seemingly multiplying in various
places in the ftrace tree, please reverse this trend.
