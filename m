Return-Path: <linux-kernel-owner+w=401wt.eu-S1755799AbXEQJXk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755799AbXEQJXk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 05:23:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753995AbXEQJXd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 05:23:33 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4239 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752389AbXEQJXc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 05:23:32 -0400
Date: Thu, 17 May 2007 09:23:19 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Chuck Ebbert <cebbert@redhat.com>, len.brown@intel.com
Cc: Maciej Rutecki <maciej.rutecki@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, lenb@kernel.org,
       torvalds@linux-foundation.org
Subject: Re: 2.6.22-rc1-mm1 [cannot change thermal trip points]
Message-ID: <20070517092318.GD3975@ucw.cz>
References: <20070515201914.16944e04.akpm@linux-foundation.org> <464B4155.9070902@gmail.com> <464B43BB.3070505@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <464B43BB.3070505@redhat.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > In 2.6.20.9 I can change trippoints:
> > 
> > echo "105:100:100:78:70:40:30" > /proc/acpi/thermal_zone/TZ0/trip_points
> > echo 10  > /proc/acpi/thermal_zone/TZ0/polling_frequency
> > 
> > Then I got:
> > cat /proc/acpi/thermal_zone/TZ0/*
...
> > Its bug or feature?
> > 
> 
> Committed to mainline May 10:
> 
> Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=11ccc0f249cb01a129f54760b8ff087f242935d4
> Commit:     11ccc0f249cb01a129f54760b8ff087f242935d4
> Parent:     de46c33745f5e2ad594c72f2cf5f490861b16ce1
> Author:     Len Brown <len.brown@intel.com>
> AuthorDate: Mon Apr 30 22:36:01 2007 -0400
> Committer:  Len Brown <len.brown@intel.com>
> CommitDate: Mon Apr 30 22:36:01 2007 -0400
> 
>     ACPI: thermal trip points are read-only

What was the rationale? Can we get this one reverted? 

Some machines (HP omnibook xe3) have broken trip points -- too high --
so machine will overheat and trigger hw shutdown before starting
passive cooling.

That's really broken, and write to trip points is reasonable way to
'fix' that. (I'd understand if you only ever let trip points to
decrease... but otoh root should be able to shoot himself....)

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
