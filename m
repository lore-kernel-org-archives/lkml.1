Return-Path: <linux-kernel-owner+w=401wt.eu-S935118AbZLKXxt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935118AbZLKXxt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 18:53:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934038AbZLKXxp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 18:53:45 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37389 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934014AbZLKXxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 18:53:44 -0500
Date: Fri, 11 Dec 2009 15:53:14 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Alan Stern <stern@rowland.harvard.edu>, Zhang Rui <rui.zhang@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: Async suspend-resume patch w/ completions (was: Re: Async
 suspend-resume patch w/ rwsems)
In-Reply-To: <200912120048.46180.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.0912111552330.3526@localhost.localdomain>
References: <Pine.LNX.4.44L0.0912091729530.2672-100000@iolanthe.rowland.org> <200912112311.08548.rjw@sisk.pl> <alpine.LFD.2.00.0912111415160.3922@localhost.localdomain> <200912120048.46180.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 12 Dec 2009, Rafael J. Wysocki wrote:
> 
> Below is a patch I've just tested, but there's a lockdep problem in it I don't
> know how to solve.  Namely, lockdep is apparently unhappy with us not releasing
> the lock taken in device_suspend() and it complains we take it twice in a row
> (which we do, but for another device).  I need to use down_read_non_owner()
> to make it shut up and then I also need to use up_read_non_owner() in
> __device_suspend(),

Ok, that I admit is actually a problem.

Ok, ok, I'll accept that completion() version, even though I think it's 
inferior.

		Linus
