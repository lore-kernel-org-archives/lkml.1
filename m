Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753787Ab0CDUP4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 15:15:56 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:41108 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752466Ab0CDUPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 15:15:54 -0500
Date: Thu, 4 Mar 2010 21:15:48 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>, Jens Axboe <jens.axboe@oracle.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [linux-pm] Is it supposed to be ok to call del_gendisk while
 userspace is frozen?
Message-ID: <20100304201548.GA1341@elf.ucw.cz>
References: <Pine.LNX.4.44L0.1003032142580.6963-100000@netrider.rowland.org>
 <201003042026.30303.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201003042026.30303.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > My thought exactly.  This is the only approach that also solves the 
> > following race:
> > 
> > 	A driver is unloaded at the same time as a suspend starts.
> > 
> > 	The writeback thread gets frozen.
> > 
> > 	Then before the rmmod thread is frozen, it calls del_gendisk.
> > 
> > Delaying things by means of a workqueue (or the equivalent) might also 
> > work, but it doesn't seem as safe.  For example, some important 
> > writebacks might end up getting delayed until too late.

Delaying writebacks during sleep should be ok... That's why we do
sync() after userspace is frozen -- nothing really important should be
waiting for writeback after that point. 
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
