Return-Path: <linux-kernel-owner+w=401wt.eu-S1758650AbYE2XHM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758650AbYE2XHM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 19:07:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754087AbYE2XHB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 19:07:01 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47192 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753868AbYE2XHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 19:07:00 -0400
Date: Thu, 29 May 2008 16:06:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: david-b@pacbell.net, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, mingo@elte.hu, pavel@suse.cz
Subject: Re: [patch 2.6.26-rc4-git] PM: boot time suspend selftest
Message-Id: <20080529160632.816e1720.akpm@linux-foundation.org>
In-Reply-To: <200805292329.48896.rjw@sisk.pl>
References: <200805291333.42057.david-b@pacbell.net>
	<200805292301.42244.rjw@sisk.pl>
	<200805291426.18404.david-b@pacbell.net>
	<200805292329.48896.rjw@sisk.pl>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 May 2008 23:29:48 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Thursday, 29 of May 2008, David Brownell wrote:
> > On Thursday 29 May 2008, Rafael J. Wysocki wrote:
> > > Two questions:
> > > 
> > > 1) How is it related to the analogous patch in the Ingo's tree?
> > 
> > AFAIK -- just that it's an updated version.  Comments, some
> > code flow, but mostly having the "test_suspend=mode" parameter
> > default to "safe -- no testing" and allows the choice of modes.
> > 
> > 
> > > 2) Does it apply to the current linux-next?
> > 
> > No idea.
> 
> Could you check, please?  The previous version didn't.
> 

There's just one trivial reject against the PCI tree's
pm-introduce-new-top-level-suspend-and-hibernation-callbacks:

***************
*** 293,299 ****
  	if (suspend_ops->finish)
  		suspend_ops->finish();
   Resume_devices:
  	device_resume();
   Resume_console:
  	resume_console();
   Close:
--- 342,350 ----
  	if (suspend_ops->finish)
  		suspend_ops->finish();
   Resume_devices:
+ 	suspend_test_start();
  	device_resume();
+ 	suspend_test_finish("resume devices");
   Resume_console:
  	resume_console();
   Close:

