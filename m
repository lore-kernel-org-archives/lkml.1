Return-Path: <linux-kernel-owner+w=401wt.eu-S1757418AbYFTR0d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757418AbYFTR0d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 13:26:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756958AbYFTR0E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 13:26:04 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43246
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756926AbYFTR0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 13:26:01 -0400
Date: Fri, 20 Jun 2008 10:26:01 -0700 (PDT)
Message-Id: <20080620.102601.06998427.davem@davemloft.net>
To: mpatocka@redhat.com
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org, agk@redhat.com
Subject: Re: stack overflow on Sparc64
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0806201143110.8789@engineering.redhat.com>
References: <Pine.LNX.4.64.0806171954060.2560@engineering.redhat.com>
	<20080617.210159.141238856.davem@davemloft.net>
	<Pine.LNX.4.64.0806201143110.8789@engineering.redhat.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>
Date: Fri, 20 Jun 2008 11:47:12 -0400 (EDT)

> I took another few traces (to track the whole stack content) and there is 
> another problem: nested interrupts. Does Sparc64 limit them somehow?

Two levels should be the deepest you will ever see, and this is
equivalent to what you get on other platforms.

That path occurs when softirq processing re-enabled HW interrupts when
returning from the top-level interrupt.
