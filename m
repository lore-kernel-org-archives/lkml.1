Return-Path: <linux-kernel-owner+w=401wt.eu-S1754647AbYCVQVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647AbYCVQVT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 12:21:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752865AbYCVQVM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 12:21:12 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:39016 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752729AbYCVQVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 12:21:11 -0400
Date: Sat, 22 Mar 2008 17:21:10 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Eric W. Biederman" <ebiederm@xmission.com>, nigel@nigel.suspend2.net,
       Kexec Mailing List <kexec@lists.infradead.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-pm@lists.linux-foundation.org, Vivek Goyal <vgoyal@redhat.com>,
       Len Brown <len.brown@intel.com>
Subject: Re: [linux-pm] [PATCH -mm] kexec jump -v9
Message-ID: <20080322162110.GA32058@atrey.karlin.mff.cuni.cz>
References: <200803210040.33982.rjw@sisk.pl> <Pine.LNX.4.44L0.0803202049550.11234-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0803202049550.11234-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, 21 Mar 2008, Rafael J. Wysocki wrote:
> 
> > > > > Well, in fact ACPI has something called the NVS memory, which we're supposed
> > > > > to restore during the resume and which we're not doing.  The problem may be
> > > > > related to this.
> > > > 
> > > > No, it can't be.  ACPI won't expect the NVS memory to be restored 
> > > > following an S5-shutdown.  In fact, as far as ACPI is concerned, 
> > > > resuming from an S5-type hibernation should not be considered a resume 
> > > > at all but just an ordinary reboot.
> > 
> > I agree here.
> > 
> > > > All ACPI-related memory areas in the boot kernel should be passed directly
> > > > through to the image kernel.
> > 
> > However, the image kernel is supposed to restore the NVS area (from the
> > image) before executing _WAK.
> 
> It's supposed to do that when resuming from an S4 hibernation, not 
> when resuming from an S5 hibernation.
> 
> > > How can we pass interpretter state? I do not think we do this kind of
> > > passing.
> > 
> > The interpreter state is passed withing the image.  The platform state is not.
> 
> For an S5 hibernation, the interpreter state within the image is wrong.  
> The image kernel needs to have the interpreter state from the boot 
> kernel -- I don't know if this is possible.

yes, nosave pages could be used to do this passing -- if we can put
interpretter state into pre-allocated memory block.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
