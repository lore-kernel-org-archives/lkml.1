Return-Path: <linux-kernel-owner+w=401wt.eu-S1752014AbZBWKPW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014AbZBWKPW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 05:15:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752102AbZBWKPH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 05:15:07 -0500
Received: from gate.crashing.org ([63.228.1.57]:55979 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751917AbZBWKPG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 05:15:06 -0500
Subject: Re: [RFC][PATCH 2/2] PM: Rework handling of interrupts during
 suspend-resume
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <m17i3ha4nk.fsf@fess.ebiederm.org>
References: <200902221837.49396.rjw@sisk.pl>
	 <alpine.LFD.2.00.0902220946070.3111@localhost.localdomain>
	 <200902222342.08285.rjw@sisk.pl> <200902230048.33635.rjw@sisk.pl>
	 <m1ab8ddfbr.fsf@fess.ebiederm.org> <20090223084400.GB9582@elte.hu>
	 <m17i3ha4nk.fsf@fess.ebiederm.org>
Content-Type: text/plain
Date: Mon, 23 Feb 2009 21:13:06 +1100
Message-Id: <1235383986.8805.239.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-02-23 at 01:22 -0800, Eric W. Biederman wrote:
> Ingo Molnar <mingo@elte.hu> writes:
> 
> 
> > I think this aspect has been well-understood during the 
> > discussion of this topic and it's just a slightly misleading 
> > changelog.
> 
> As I was a member of that discussion I did not see that.
> 
> It took me several passes through the patches to realize
> the goal is to allow drivers to be able to sleep while they
> are in their late pm shutdown routines.
> 
> Why we want this I don't know.  But it seems simple enough
> to implement, and it makes it harder to get the late pm
> suspend routines wrong, which is always good.

To simplify (it's really all in the discussion we had the last few
weeks) It boils down to being able to do the proper ACPI calls (which
require core interrupts to be on, ie, ACPI uses mutexes, sleeps, etc...)
after we have saved and before we restore the PCI config space, in the
late suspend or early resume stages of devices.

Cheers,
Ben.


