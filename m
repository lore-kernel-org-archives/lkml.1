Return-Path: <linux-kernel-owner+w=401wt.eu-S1751883AbYFXLtX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751883AbYFXLtX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 07:49:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753904AbYFXLtO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 07:49:14 -0400
Received: from emerald.lightlink.com ([64.57.176.19]:3394 "EHLO
	emerald.lightlink.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752876AbYFXLtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 07:49:12 -0400
Date: Tue, 24 Jun 2008 07:45:01 -0400
From: "Mark M. Hoffman" <mhoffman@lightlink.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Robert Hancock <hancockr@shaw.ca>, Rene Herman <rene.herman@keyaccess.nl>,
       Hans de Goede <j.w.r.degoede@hhs.nl>, Zhang Rui <rui.zhang@intel.com>,
       Jean Delvare <khali@linux-fr.org>, linux-acpi@vger.kernel.org,
       lm-sensors@lm-sensors.org, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2.6.26-rc] ACPI Thermal Zone driver breaks lm-sensors 2 userspace
Message-ID: <20080624114501.GL7306@mars.solarsys.private>
References: <fa.4PGqX9CuLbgiTimfCcon+PlAMxk@ifi.uio.no> <fa.PWu620xEt5OlYdOezvRtQriuNjM@ifi.uio.no> <48605935.5070407@shaw.ca> <alpine.LFD.1.10.0806232004480.2926@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0806232004480.2926@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus:

* Linus Torvalds <torvalds@linux-foundation.org> [2008-06-23 20:07:15 -0700]:
> 
> 
> On Mon, 23 Jun 2008, Robert Hancock wrote:
> 
> > Mark M. Hoffman wrote:
> > > 
> > > 1) The bug is in libsensors (2.10), not the kernel.
> > 
> > This doesn't matter. Breaking userspace in such a fashion is severely frowned
> > upon unless essentially unavoidable, even if it is just triggering a bug.
> 
> I do tend to agree. If it used to work, it should continue to work, even 
> if it wasn't _meant_ to work.
> 
> That's not always 100% possible, but the fact is, neither is updating user 
> space always possible. The kernel needs to try its best to maintain stable 
> interfaces, and no, "..but the interface was broken" is _not_ an 
> acceptable excuse for unbreaking it if it causes problems.

No excuses... it's just a simple case of userspace making a bad assumption.
(Queue rant about how sysfs interfaces are prone to this sort of thing.)

> > > - but more importantly -
> > > 
> > > 2) This patch is broken.
> > 
> > You didn't indicate what was wrong with the patch.
> 
> Yes. Leaving everybody wondering whether it's just an opinionated 
> expression of the former problem, or whether there is a real and 
> understandable reason why it was NACK'ed.

IMO Jean Delvare and Zhang Rui had explained this well enough elsewhere in the
thread, but...

In summary: the patch adds a meaningless symbolic link to an arbitrary thermal
zone device where the was none before.  This keeps (one version of) libsensors
from tripping over itself.  But if the TZ devices are unregistered in the wrong
order, OOPS.  Apparently this can't happen in practice; but it's a bad trade
to add an implicit dependency on the order of device reg/unreg just to wall-
paper over a bug in userspace (IMHO).

Regards,

-- 
Mark M. Hoffman
mhoffman@lightlink.com

