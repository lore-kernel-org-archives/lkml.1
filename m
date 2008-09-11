Return-Path: <linux-kernel-owner+w=401wt.eu-S1754286AbYIKE0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286AbYIKE0T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 00:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751792AbYIKE0L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 00:26:11 -0400
Received: from gv-out-0910.google.com ([216.239.58.188]:22089 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682AbYIKE0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 00:26:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=vVAlgcYuyONT9A15ijpIfrtOZR1nNpnVSV0dPddmupNizg8+sbOtuOyXpvG7cjlBIo
         Nmi9ym8CGRo0r5hevwv/SZiWRTTU0yUr8MR2J8TfZSa8FGQr/qAzbfGu1E+D7SNQzk8g
         hmtQB2cCuhSDx5EBLEXNQL110qh1thrFYTsjw=
Date: Thu, 11 Sep 2008 08:19:19 +0400
From: Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Robert Hancock <hancockr@shaw.ca>, linux-kernel@vger.kernel.org,
       aabdulla@nvidia.com, jgarzik@pobox.com
Subject: Re: forcedeth: option to disable 100Hz timer (try 2)
Message-ID: <20080911081919.56560a8a@laska>
In-Reply-To: <20080910173630.d0d38697.akpm@linux-foundation.org>
References: <fa.iCGOiwuSYhYKpu85Kihny1t9YbA@ifi.uio.no>
	<fa.4uZtuq0waBlpfBb/4OLq4bM5Pj8@ifi.uio.no>
	<48C863CC.3010902@shaw.ca>
	<20080910173630.d0d38697.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.9; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Sep 2008 17:36:30 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 10 Sep 2008 18:18:20 -0600
> Robert Hancock <hancockr@shaw.ca> wrote:
> 
> > Andrew Morton wrote:
> > > On Tue, 9 Sep 2008 23:34:35 +0400
> > > Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com> wrote:
> > > 
> > >> On some hardware no TX done interrupts are generated, thus special
> > >> 100Hz timer interrupt is required to handle this situation properly.
> > >> Other device do not require that timer interrupt feature. 
> > >>
> > >> Forcedeth has a DEV_NEED_TIMERIRQ flag to mark the broken devices.
> > >> Unfortunately, nobody know the actual list of broken devices, so all
> > >> device has this flag on. Other problem, this flag is not user visible,
> > >> so the kernel recompilation is required to disable timer interrupts and
> > >> test a device.
> > >>
> > >> This patch add a "disable_timerirq" option to disable interrupt 
> > >> timer mentioned above. This may be extremely useful for laptop users.
> > > 
> > > Why do you feel that the timer-based completions need to be disabled? 
> > > Is it causing some problem?
> > 
> > 100 unnecessary CPU wakeups per second imposes some power usage cost, 
> > especially on laptops with CPU C-states..
> 
> Is that the only reason for the change?  We still don't know...
> 
> 
> 
> Anyway, it's certainly _sufficient_ reason, however the implementation
> is pretty sad - most people won't even know that the option exists so
> they'll continue to chew more power than they need to.
> 
> How do we fix this?  Perhaps disable the timer by default, then wait
> for the first tx timeout and then enable the timer at that stage, while
> printing a message saying "add module option <foo> to prevent this
> once-off timeout from happening"?

I'll try this
