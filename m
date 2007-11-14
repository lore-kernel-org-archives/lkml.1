Return-Path: <linux-kernel-owner+w=401wt.eu-S1760868AbXKNVox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760868AbXKNVox (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 16:44:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753459AbXKNVoo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 16:44:44 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:42564 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753072AbXKNVon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 16:44:43 -0500
Date: Wed, 14 Nov 2007 22:42:00 +0000
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH] Hibernation: Fix lockdep report (v2)
Message-ID: <20071114224200.GB7367@ucw.cz>
References: <200711142225.58033.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200711142225.58033.rjw@sisk.pl>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2007-11-14 22:25:57, Rafael J. Wysocki wrote:
> [Andrew, please consider this as 2.6.24 material, thanks.]
> ---
> From: Johannes Berg <johannes@sipsolutions.net>
> 
> Lockdep reports a circular locking dependency in the hibernate code
> because
>  - during system boot hibernate code (from an initcall) locks pm_mutex
>    and then a sysfs buffer mutex via name_to_dev_t
>  - during regular operation hibernate code locks pm_mutex under a
>    sysfs buffer mutex because it's called from sysfs methods.
> 
> The deadlock can never happen because during initcall invocation nothing
> can write to sysfs yet. This removes the lockdep report by marking the
> initcall locking as being in a different class.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> Cc: Alan Stern <stern@rowland.harvard.edu>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Pavel Machek <pavel@ucw.cz>

ACK...

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
