Return-Path: <linux-kernel-owner+w=401wt.eu-S1756425AbYAHXGa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756425AbYAHXGa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 18:06:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754330AbYAHXGL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 18:06:11 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58958
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754137AbYAHXGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 18:06:09 -0500
Date: Tue, 08 Jan 2008 15:06:09 -0800 (PST)
Message-Id: <20080108.150609.43522839.davem@davemloft.net>
To: mingo@elte.hu
Cc: m.kozlowski@tuxland.pl, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org,
       a.p.zijlstra@chello.nl
Subject: Re: Linux 2.6.24-rc7: sparc64: WARNING: at
 kernel/lockdep_proc.c:267 lockdep_stats_show()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080108225631.GA7021@elte.hu>
References: <200801081942.17139.m.kozlowski@tuxland.pl>
	<20080108.145038.203528847.davem@davemloft.net>
	<20080108225631.GA7021@elte.hu>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Tue, 8 Jan 2008 23:56:31 +0100

> is this anything the core lockdep code could help improve? Let us know 
> if any aspect is hindering you.

No, it's a sparc64 issue.

Another problem I ran into are the huge static table sizes
lockdep uses.  They really need to be either made smaller or
dynamically allocated.

Sparc64 has hard limitations on kernel size (due to firmware
and bootloader issues) and I hit these limits if I am not
careful on SMP with lockdep enabled.

Andi Kleen and I discussed in a thread several weeks ago.
I believe Andi even came up with a suggested direction to
fix this.

