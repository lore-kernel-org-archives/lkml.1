Return-Path: <linux-kernel-owner+w=401wt.eu-S1763455AbXG0ANj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763455AbXG0ANj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 20:13:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755019AbXG0ANa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 20:13:30 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42591
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1758813AbXG0AN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 20:13:29 -0400
Date: Thu, 26 Jul 2007 15:23:52 -0700 (PDT)
Message-Id: <20070726.152352.70218024.davem@davemloft.net>
To: matthew@wil.cx
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, torvalds@osdl.org
Subject: Re: IRQF_DISABLED problem
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070726201355.GP19275@parisc-linux.org>
References: <20070726201355.GP19275@parisc-linux.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthew Wilcox <matthew@wil.cx>
Date: Thu, 26 Jul 2007 14:13:56 -0600

> 
> I noticed that we only look at the first action in the chain when
> determining whether to re-enable local interrupts during handle_IRQ_event.
> But we don't try to exclude sharing interrupts with mixtures of
> IRQF_DISABLED set and clear.  I just tried to do that locally, and one
> of my USB ports disappears, because it shares an interrupt with qla2xxx
> which sets IRQF_DISABLED, and UHCI doesn't.
> 
> Another possibility is to force it if *any* of the handlers want
> IRQF_DISABLED.  This seems to work:

Yes, this is consistent with how we handle sharing, we should
enforce that all the flags on the chain are compatible.
