Return-Path: <linux-kernel-owner+w=401wt.eu-S1762888AbYBVAr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762888AbYBVAr6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 19:47:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756523AbYBVArr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 19:47:47 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:45536 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757356AbYBVArq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 19:47:46 -0500
Date: Thu, 21 Feb 2008 16:46:33 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Jeff Chua <jeff.chua.linux@gmail.com>,
       Jesse Barnes <jesse.barnes@intel.com>,
       Romano Giannetti <romano@dea.icai.upcomillas.es>,
       suspend-devel List <suspend-devel@lists.sourceforge.net>,
       Dave Airlie <airlied@linux.ie>, Greg KH <gregkh@suse.de>,
       lkml <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: Re: [Suspend-devel] 2.6.25-rc2 System no longer powers off
 aftersuspend-to-disk. Screen becomes green.
In-Reply-To: <200802220131.09525.rjw@sisk.pl>
Message-ID: <alpine.LFD.1.00.0802211643140.19896@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0802210101050.3576@boston.corp.fedex.com> <200802211302.27002.jesse.barnes@intel.com> <b6a2187b0802211620q47f6601fuf7e88395d89b90c8@mail.gmail.com> <200802220131.09525.rjw@sisk.pl>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 22 Feb 2008, Rafael J. Wysocki wrote:
>  
> -	if (state.event == PM_EVENT_SUSPEND) {
> +	if (state.event == PM_EVENT_SUSPEND && !in_hibernation_power_off()) {

I don't understand why hibernation just doesn't use a PM_EVENT_HIBERNATE, 
and be done with it?

Why should it be called PM_EVENT_SUSPEND when it isn't?

Adding some external global variables is absolutely the wrong way to fix 
this.

It's not even like there are very many drivers who actually care about 
"state.event" anyway: a 'git grep' returns just 35 users in the whole 
tree, so if this was done this ugly way just to avoid double-chcking the 
other cases that compare against PM_EVENT_SUSPEND, then it really wasn't 
worth it.

		Linus
