Return-Path: <linux-kernel-owner+w=401wt.eu-S1422841AbXBUTnJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422841AbXBUTnJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 14:43:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422844AbXBUTnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 14:43:09 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:47875 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1422841AbXBUTnI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 14:43:08 -0500
Date: Wed, 21 Feb 2007 20:42:57 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, akpm@osdl.org, paulmck@us.ibm.com,
       mingo@elte.hu, vatsa@in.ibm.com, dipankar@in.ibm.com,
       venkatesh.pallipadi@intel.com, linux-kernel@vger.kernel.org,
       oleg@tv-sign.ru
Subject: Re: [RFC PATCH(Experimental) 0/4] Freezer based Cpu-hotplug
Message-ID: <20070221194257.GD3732@elf.ucw.cz>
References: <20070214144031.GA15257@in.ibm.com> <200702151431.10068.rjw@sisk.pl> <20070215142542.GA14931@in.ibm.com> <200702171224.46626.rjw@sisk.pl> <20070221145221.GB21660@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070221145221.GB21660@in.ibm.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Rafael,
> On Sat, Feb 17, 2007 at 12:24:45PM +0100, Rafael J. Wysocki wrote:
> > 
> > Pavel, do you think we can remove the PF_NOFREEZE from bluetooth, BTW?
> 
> The create_workqueue by default marks the worker_threads to be
> non_freezable. For cpu hotplug, all workqueues can be frozen 
> except the "kthread" workqueue (which is single threaded, so won't 
> be frozen anyway).
> 
> And a quick cscope scan shows that only the "xfslogd" and "xfsdatad"
> are the only freezable workqueues. Any particular reason
> for not marking rest of the non-single_threaded workqueues freezeable ??

As I said, go ahead.

bluetooth has absolutely no business running while we are writing
suspend image to disk.

(First person suggesting
suspend-to-file-on-nfs-filesystem-mounted-over-GPRS-line-connected-over-bluetooth
will be punished by only getting bread and water till he implements
it).
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
