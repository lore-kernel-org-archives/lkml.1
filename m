Return-Path: <linux-kernel-owner+w=401wt.eu-S1762754AbZEGU0K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762754AbZEGU0K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 16:26:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760507AbZEGUZe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 16:25:34 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51547 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762091AbZEGUZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 16:25:31 -0400
Date: Thu, 7 May 2009 21:24:28 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Christoph Lameter <cl@linux.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Alok Kataria <akataria@vmware.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Reduce the default HZ value
Message-ID: <20090507212428.2fbe5cfa@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.DEB.1.10.0905071555040.14051@qirst.com>
References: <1241462661.412.8.camel@alok-dev1>
	<4A00ADDE.9000908@zytor.com>
	<1241560625.8665.17.camel@alok-dev1>
	<alpine.DEB.1.10.0905071010170.24528@qirst.com>
	<1241716053.6311.1514.camel@laptop>
	<1241716422.6311.1524.camel@laptop>
	<1241716718.6311.1531.camel@laptop>
	<20090507173608.GC6693@linux.vnet.ibm.com>
	<1241717904.6311.1558.camel@laptop>
	<20090507180112.GE6693@linux.vnet.ibm.com>
	<alpine.DEB.1.10.0905071404390.22107@qirst.com>
	<20090507205357.1be739e1@lxorguk.ukuu.org.uk>
	<alpine.DEB.1.10.0905071555040.14051@qirst.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Reducing the number of application interruptions by a factor of 10 is not
> pointless. The lower HZ becomes the more useless it will become for the
> users of jiffies because they will have to create timers and use time
> intervals if the HZ intervals become too large.

More like "the more your performance goes down the toilet" - as
everything is rounded up.

If you want to follow that argument set the default HZ to 1. Then see if
it has any side effects.

Given HZ=1 doesn't work, its fairly clear that all you are doing is
frobbing pointlessly with defaults that have been evolved over about 15
years because they work.

Whereas if you make jiffies jiffies() and it reads a timer it puts the
pain in the right place and you can begin to make actual progress to
making things work properly.
