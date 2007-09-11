Return-Path: <linux-kernel-owner+w=401wt.eu-S966099AbXIKHXe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966099AbXIKHXe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 03:23:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761283AbXIKHX0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 03:23:26 -0400
Received: from www.osadl.org ([213.239.205.134]:48557 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761006AbXIKHXZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 03:23:25 -0400
Subject: Re: clockevents: fix resume logic
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <20070911000001.30f8590b.akpm@linux-foundation.org>
References: <200707220159.l6M1xBgH001236@hera.kernel.org>
	 <20070910144740.4eba2fda.akpm@linux-foundation.org>
	 <1189492636.25767.62.camel@chaos>
	 <20070911000001.30f8590b.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 11 Sep 2007 09:23:20 +0200
Message-Id: <1189495400.25767.81.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-09-11 at 00:00 -0700, Andrew Morton wrote:
> > > This patch broke the jinxed vaio.
> > > 
> > > Which is a bit odd, considering that I must have tested it at the time. 
> > > But I bisected it right down to this commit, and the below revert patch
> > > fixed it up.
> > 
> > I just looked up, that you confirmed earlier that the patch does _not_
> > break the VAIO. 
> > 
> > I think, that some other suspend/resume/ACPI or whatever change went in
> > before this patch got merged into Linus tree. Sigh. That's pretty hard
> > to find out.
> > 
> 
> I tried just 18de5bc4c1f1f1fa5e14f354a7603bd6e9d4e3b6 on top of 2.6.22
> (threw away the lguest and xen hunks).  The same problem occurs.  2.6.22 is
> OK.

Hmm.

> I went back to the original patch which I sent to Linus and it matches
> 18de5bc4c1f1f1fa5e14f354a7603bd6e9d4e3b6.  So all I can think is that there
> must have been something else in the tree which I tested which fixed the
> bug which 18de5bc4c1f1f1fa5e14f354a7603bd6e9d4e3b6 introduced.  argh.
> 
> Can you think what would cause the symptoms which I described?  

It seems that time is not updated. Timer interrupt not active or some
other odd thing. I figure out what's going on when I find a box which
exposes the problem.

	tglx


