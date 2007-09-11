Return-Path: <linux-kernel-owner+w=401wt.eu-S1762288AbXIKGhc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762288AbXIKGhc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 02:37:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760929AbXIKGhW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 02:37:22 -0400
Received: from www.osadl.org ([213.239.205.134]:50581 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760258AbXIKGhV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 02:37:21 -0400
Subject: Re: clockevents: fix resume logic
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <20070910144740.4eba2fda.akpm@linux-foundation.org>
References: <200707220159.l6M1xBgH001236@hera.kernel.org>
	 <20070910144740.4eba2fda.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 11 Sep 2007 08:37:16 +0200
Message-Id: <1189492636.25767.62.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-09-10 at 14:47 -0700, Andrew Morton wrote:
> > 
> >     clockevents: fix resume logic
> >     
> >     We need to make sure, that the clockevent devices are resumed, before
> >     the tick is resumed. The current resume logic does not guarantee this.
> >     
> >     Add CLOCK_EVT_MODE_RESUME and call the set mode functions of the clock
> >     event devices before resuming the tick / oneshot functionality.
> >     
> >     Fixup the existing users.
> >     
> >     Thanks to Nigel Cunningham for tracking down a long standing thinko,
> >     which affected the jinxed VAIO.
> >     
> 
> This patch broke the jinxed vaio.
> 
> Which is a bit odd, considering that I must have tested it at the time. 
> But I bisected it right down to this commit, and the below revert patch
> fixed it up.

I just looked up, that you confirmed earlier that the patch does _not_
break the VAIO. 

I think, that some other suspend/resume/ACPI or whatever change went in
before this patch got merged into Linus tree. Sigh. That's pretty hard
to find out.

	tglx


