Return-Path: <linux-kernel-owner+w=401wt.eu-S1760841AbYEMWaM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760841AbYEMWaM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 18:30:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757181AbYEMW34
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 18:29:56 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43166
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757132AbYEMW3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 18:29:54 -0400
Date: Tue, 13 May 2008 15:29:49 -0700 (PDT)
Message-Id: <20080513.152949.155579984.davem@davemloft.net>
To: mathieu.desnoyers@polymtl.ca
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [PATCH]: Sparc64 immediate values
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080513123615.GA29334@Krystal>
References: <20080513.044011.204136790.davem@davemloft.net>
	<20080513123615.GA29334@Krystal>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Date: Tue, 13 May 2008 08:36:15 -0400

> However, it does not protect from having a thread preempted in the
> middle of this instruction sequence and therefore to see incoherent
> values.

Yes, that makes such schemes unworkable, how hum...

> Are there non-maskable interrupts on sparc64 ?

Yes, and no.  When the PSTATE_IE bit is cleared in the
processor state register, no interrupts whatsoever are
recognized by the processor.  This is off only during
trap entry/exit sequences, and some other special bits
of code.

> The one thing we could do to allow such updates without using
> stop_machine is to create something similar to the read seqlock using
> immediate values.

Yes I saw such suggestions in the comments of the immediate code,
you don't have to describe such things all over again.

Doing something so heavy like this in the "fast path" is completely
pointless in my opinion.

Better to keep brainstorming on a scheme that works without adding any
instructions to the immediate load sequence.  If you add instructions,
fetching the instructions themselves become just as expensive, if not
moreso, than the load we are eliminating.
