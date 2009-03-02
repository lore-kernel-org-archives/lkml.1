Return-Path: <linux-kernel-owner+w=401wt.eu-S1757887AbZCBXC6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757887AbZCBXC6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 18:02:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753805AbZCBXCp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 18:02:45 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:43774 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752860AbZCBXCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 18:02:44 -0500
Subject: Re: lockdep and threaded IRQs
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: David Miller <davem@davemloft.net>
Cc: dbrownell@users.sourceforge.net, tglx@linutronix.de,
       akpm@linux-foundation.org, me@felipebalbi.com,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       felipe.balbi@nokia.com, dmitry.torokhov@gmail.com, sameo@openedhand.com
In-Reply-To: <20090302.144647.116847598.davem@davemloft.net>
References: <1236030106.5330.1553.camel@laptop>
	 <200903021409.21344.david-b@pacbell.net>
	 <1236032371.5330.1654.camel@laptop>
	 <20090302.144647.116847598.davem@davemloft.net>
Content-Type: text/plain
Date: Tue, 03 Mar 2009 00:02:23 +0100
Message-Id: <1236034943.5330.1779.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-03-02 at 14:46 -0800, David Miller wrote:
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Mon, 02 Mar 2009 23:19:31 +0100
> 
> > I state that every !IRQF_DISABLED usage is a bug, either due to broken
> > hardware or broken drivers.
> 
> We'll send you the bill to have everyone's hardware
> replaced :-)

I'm not saying to remove support for such stuff, as long as we clearly
annotate that its due to broken ass hardware we can leave a IRQF_ENABLED
thingy in there.

Preferably such drivers would be converted to threaded interrupts, but I
thought Alan mentioned an IDE chipset that was so broken even that would
be impossible (could not mask the IRQ for it would corrupt stuff).

The thing I am strongly opposing though, is keeping interrupts enabled
for regular drivers on sane hardware.

