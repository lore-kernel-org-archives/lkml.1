Return-Path: <linux-kernel-owner+w=401wt.eu-S1753353AbYKQTgr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353AbYKQTgr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 14:36:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752009AbYKQTgi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 14:36:38 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55034
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751997AbYKQTgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 14:36:37 -0500
Date: Mon, 17 Nov 2008 11:36:37 -0800 (PST)
Message-Id: <20081117.113637.72930858.davem@davemloft.net>
To: mingo@elte.hu
Cc: dada1@cosmosbay.com, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, cl@linux-foundation.org, efault@gmx.de,
       a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
       shemminger@vyatta.com
Subject: Re: [Bug #11308] tbench regression on each kernel release from
 2.6.22 -&gt; 2.6.28
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081117170844.GJ12081@elte.hu>
References: <20081117161135.GE12081@elte.hu>
	<49219D36.5020801@cosmosbay.com>
	<20081117170844.GJ12081@elte.hu>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Mon, 17 Nov 2008 18:08:44 +0100

> Mike Galbraith has been spending months trying to pin down all the 
> issues.

Yes Mike has been doing tireless good work.

Another thing I noticed is that because all of the scheduler
core operations are now function pointer callbacks, the
call chain is deeper for core operations like wake_up().

Much of it used to be completely inlined into try_to_wake_up()

With the addition of the RB tree stuff, that adds yet another
unavoidable depth of function call.

wake_up() is usually at the deepest part of the call chain,
so this is a big deal
