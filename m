Return-Path: <linux-kernel-owner+w=401wt.eu-S1030795AbXCTAcI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030795AbXCTAcI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 20:32:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030801AbXCTAcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 20:32:07 -0400
Received: from smtp.osdl.org ([65.172.181.24]:36524 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030795AbXCTAcE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 20:32:04 -0400
Date: Mon, 19 Mar 2007 17:31:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] swsusp: Do not use page flags
Message-Id: <20070319173127.72c3419d.akpm@linux-foundation.org>
In-Reply-To: <200703122219.21171.rjw@sisk.pl>
References: <200703122214.02657.rjw@sisk.pl>
	<200703122219.21171.rjw@sisk.pl>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Mar 2007 22:19:20 +0100
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> Make swsusp use memory bitmaps instead of page flags for marking 'nosave' and
> free pages.  This allows us to 'recycle' two page flags that can be used for other
> purposes.  Also, the memory needed to store the bitmaps is allocated when
> necessary (ie. before the suspend) and freed after the resume which is more
> reasonable.
> 
> The patch is designed to minimize the amount of changes and there are some nice
> simplifications and optimizations possible on top of it.  I am going to
> implement them separately in the future.

Blows up with ia64 allmodconfig due to CONFIG_PM=y, CONFIG_SOFTWARE_SUSPEND=n:

kernel/power/main.c:223: error: redefinition of 'software_suspend'
include/linux/suspend.h:46: error: previous definition of 'software_suspend' was here

I had a look at fixing it, but it's unobvious why we're compiling most of
kernel/power/main.c when CONFIG_SOFTWARE_SUSPEND=n so I'll send this series
back for repair please.
