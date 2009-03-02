Return-Path: <linux-kernel-owner+w=401wt.eu-S1756620AbZCBWv6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756620AbZCBWv6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 17:51:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753601AbZCBWvt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 17:51:49 -0500
Received: from casper.infradead.org ([85.118.1.10]:34031 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777AbZCBWvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 17:51:48 -0500
Subject: Re: lockdep and threaded IRQs (was: ...)
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: David Brownell <david-b@pacbell.net>
Cc: dbrownell@users.sourceforge.net, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, me@felipebalbi.com,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       felipe.balbi@nokia.com, dmitry.torokhov@gmail.com, sameo@openedhand.com
In-Reply-To: <200903021440.58712.david-b@pacbell.net>
References: <1235762883-20870-1-git-send-email-me@felipebalbi.com>
	 <200903021409.21344.david-b@pacbell.net>
	 <1236032371.5330.1654.camel@laptop>
	 <200903021440.58712.david-b@pacbell.net>
Content-Type: text/plain
Date: Mon, 02 Mar 2009 23:51:29 +0100
Message-Id: <1236034289.5330.1745.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-03-02 at 14:40 -0800, David Brownell wrote:
> On Monday 02 March 2009, Peter Zijlstra wrote:
> > I state that every !IRQF_DISABLED usage is a bug, either
> > due to broken hardware or broken drivers.
> 
> That's a novel position.  You do realize that removing that
> capability breaks drivers?

Then we fix them.

> But if that's what is keeping you from fixing the lockdep bug,
> why haven't you submitted patches to remove IRQF_DISABLED from
> the kernel, and update all the drivers relying on IRQs being
> enabled when their handlers run?

I did so today. Just didn't realize things actually relied on it since
lockdep turned them off and my system has been working fine.

Your driver needs threaded interrupts, Thomas is working on that now,
and I saw a conversion of your driver to use that.

IDE PIO can hopefully also be converted to threaded interrupts.

After that I'll post patches to remove IRQF_DISABLED and provide a
another flag to quick-'fix' other iffy drivers.

Once such drivers are found we can work on proper fixes for them.

