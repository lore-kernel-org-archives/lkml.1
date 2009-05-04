Return-Path: <linux-kernel-owner+w=401wt.eu-S1755849AbZEDTfj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849AbZEDTfj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 15:35:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752865AbZEDTf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 15:35:28 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44214 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751283AbZEDTf0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 15:35:26 -0400
Subject: Re: [PATCH] ftrace: use .sched.text, not .text.sched in
	recordmcount.pl.
From: Steven Rostedt <srostedt@redhat.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Tim Abbott <tabbott@MIT.EDU>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>
In-Reply-To: <20090504193033.GA10382@uranus.ravnborg.org>
References: <1241136371-10768-1-git-send-email-tabbott@mit.edu>
	 <20090504193033.GA10382@uranus.ravnborg.org>
Content-Type: text/plain
Organization: Red Hat
Date: Mon, 04 May 2009 15:35:15 -0400
Message-Id: <1241465715.11379.0.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2009-05-04 at 21:30 +0200, Sam Ravnborg wrote:
> On Thu, Apr 30, 2009 at 08:06:11PM -0400, Tim Abbott wrote:
> > The only references in the kernel to the .text.sched section are in
> > recordmcount.pl.  Since the code it has is intended to be example code
> > it should refer to real kernel sections.  So change it to .sched.text
> > instead.
> > 
> > Signed-off-by: Tim Abbott <tabbott@mit.edu>
> > Cc: Steven Rostedt <srostedt@redhat.com>
> 
> Steven - this change is independent of the ongoing
> section rework and is a pure documentation fix.
> 
> Please apply it with my ack.
> 
> 	Sam

Will do, Thanks!

-- Steve

> 
> [Kept whole patch for reference]
> 
> > ---
> >  scripts/recordmcount.pl |    6 +++---
> >  1 files changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
> > index 409596e..0fae7da 100755
> > --- a/scripts/recordmcount.pl
> > +++ b/scripts/recordmcount.pl
> > @@ -26,7 +26,7 @@
> >  # which will also be the location of that section after final link.
> >  # e.g.
> >  #
> > -#  .section ".text.sched"
> > +#  .section ".sched.text", "ax"
> >  #  .globl my_func
> >  #  my_func:
> >  #        [...]
> > @@ -39,7 +39,7 @@
> >  #        [...]
> >  #
> >  # Both relocation offsets for the mcounts in the above example will be
> > -# offset from .text.sched. If we make another file called tmp.s with:
> > +# offset from .sched.text. If we make another file called tmp.s with:
> >  #
> >  #  .section __mcount_loc
> >  #  .quad  my_func + 0x5
> > @@ -51,7 +51,7 @@
> >  # But this gets hard if my_func is not globl (a static function).
> >  # In such a case we have:
> >  #
> > -#  .section ".text.sched"
> > +#  .section ".sched.text", "ax"
> >  #  my_func:
> >  #        [...]
> >  #        call mcount  (offset: 0x5)
> > -- 
> > 1.6.2.1
> > 

