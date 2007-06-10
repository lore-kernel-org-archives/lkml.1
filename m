Return-Path: <linux-kernel-owner+w=401wt.eu-S1754789AbXFJJvs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789AbXFJJvs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 05:51:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751747AbXFJJvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 05:51:40 -0400
Received: from www.osadl.org ([213.239.205.134]:51315 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751188AbXFJJvk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 05:51:40 -0400
Subject: Re: [patch-mm 06/23] clockevents: Fix resume logic
From: Thomas Gleixner <tglx@linutronix.de>
To: nigel@nigel.suspend2.net
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@suse.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Chris Wright <chrisw@sous-sol.org>
In-Reply-To: <1181468632.30155.36.camel@nigel.suspend2.net>
References: <20070610092437.118387863@inhelltoy.tec.linutronix.de>
	 <20070610092446.588014600@inhelltoy.tec.linutronix.de>
	 <1181468632.30155.36.camel@nigel.suspend2.net>
Content-Type: text/plain
Date: Sun, 10 Jun 2007 11:51:30 +0200
Message-Id: <1181469090.384.6.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-06-10 at 19:43 +1000, Nigel Cunningham wrote:
> Hi Thomas.
> 
> On Sun, 2007-06-10 at 09:44 +0000, Thomas Gleixner wrote:
> > plain text document attachment (clockevents-fix-resume-logic.patch)
> > We need to make sure, that the clockevent devices are resumed, before
> > the tick is resumed. The current resume logic does not guarantee this.
> > 
> > Add CLOCK_EVT_MODE_RESUME and call the set mode functions of the clock
> > event devices before resuming the tick / oneshot functionality.
> > 
> > Fixup the existing users.
> 
> What are the implications of the issue for current (i386) users? (Could
> suspend/hibernation be broken in any way without this patch?)

I have one box, which needs this patch.

OTOH it breaks Andrew's jinxed VAIO in a very mysterious way:
http://lkml.org/lkml/2007/6/9/158

	tglx


