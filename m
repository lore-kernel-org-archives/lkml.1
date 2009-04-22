Return-Path: <linux-kernel-owner+w=401wt.eu-S1753899AbZDVA2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899AbZDVA2S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 20:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751554AbZDVA2E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 20:28:04 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38729
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751356AbZDVA2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 20:28:02 -0400
Date: Tue, 21 Apr 2009 17:27:54 -0700 (PDT)
Message-Id: <20090421.172754.210369267.davem@davemloft.net>
To: hpa@zytor.com
Cc: rdreier@cisco.com, h.mitake@gmail.com, mingo@elte.hu, tglx@linutronix.de,
       rpjday@crashcourse.ca, linux-kernel@vger.kernel.org
Subject: Re: arch/x86/Kconfig selects invalid HAVE_READQ, HAVE_WRITEQ vars
From: David Miller <davem@davemloft.net>
In-Reply-To: <49EE19E0.8040405@zytor.com>
References: <49EE0013.6010008@zytor.com>
	<adaab69x6nd.fsf@cisco.com>
	<49EE19E0.8040405@zytor.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@zytor.com>
Date: Tue, 21 Apr 2009 12:09:20 -0700

> Do you really expect driver authors to type writeq_nonatomic() for
> every register reference?

They'll write local driver macros, as every driver does
to save typing.  It also allows to get rid of the
redundant "foop->regs" in every register access too.

Look at what all of these drivers do:

#define nr64(reg)		readq(np->regs + (reg))
#define nw64(reg, val)		writeq((val), np->regs + (reg))

So nobody actually types readq() for every register access,
just as they don't type foop->regs for every register access
either :-)
