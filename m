Return-Path: <linux-kernel-owner+w=401wt.eu-S1753687AbZIQUSN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687AbZIQUSN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 16:18:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753336AbZIQUSL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 16:18:11 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:33136 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752919AbZIQUSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 16:18:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=BXVl8q7VCnFQG+jyTo6sxU2kIC5Y3C7pFANZ5FUvgOwHxq3Bt9q1tOTYWPNe7I4/Fw
         jAzt4rmAvkvWhuWeinrEQFDZusZkhllGXZIndxsTjaH564J727BSUTd3lXwm/6R/13/+
         TIsnNoAEuVE2Y2NJa3I9DERPYBGDT/COEvbok=
Date: Fri, 18 Sep 2009 00:18:13 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: test for "spurious" IRQ ignores possible IRQ_WAKE_THREAD value
Message-ID: <20090917201813.GG8817@lenovo>
References: <alpine.LFD.2.00.0909141627500.4124@localhost> <alpine.LFD.2.00.0909141632390.4329@localhost> <20090917193416.GE8817@lenovo> <alpine.LFD.2.00.0909171605320.5014@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0909171605320.5014@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Robert P. J. Day - Thu, Sep 17, 2009 at 04:08:32PM -0400]
...
| > Hi Robert,
| >
| > It could that IRQ_WAKE_THREAD is just missed here. I suppose it was
| > brough there as thread irq merged. But I think only Thomas know for
| > sure, I definitely miss something :) CC'ed
| 
|   actually, after a bit more reading, i found this in
| kernel/irq/handle.c:
|                 ...
|                 switch (ret) {
|                 case IRQ_WAKE_THREAD:
|                         /*
|                          * Set result to handled so the spurious check
|                          * does not trigger.
|                          */
|                         ret = IRQ_HANDLED;
|                         ...
| 
| so it looks like that value of IRQ_WAKE_THREAD is simply "mapped" to
| IRQ_HANDLED, and perhaps that's done before __report_bad_irq is ever
| called so that that latter routine never sees a value of
| IRQ_WAKE_THREAD.  but that's just a guess.
| 
| rday
| --

yeah, Thomas just pointed it too :) The note_interrupt is
called after handle_IRQ_event (except a few drivers which
don;t use threaded irq) so it doesnt reach bad irq state
with IRQ_WAKE_THREAD, for now at least.

	-- Cyrill
