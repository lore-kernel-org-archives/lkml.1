Return-Path: <linux-kernel-owner+w=401wt.eu-S933935AbXCOWYo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933935AbXCOWYo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 18:24:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932315AbXCOWYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 18:24:10 -0400
Received: from smtp.osdl.org ([65.172.181.24]:43342 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753406AbXCOWX6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 18:23:58 -0400
Date: Thu, 15 Mar 2007 15:23:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Kosina <jikos@jikos.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>,
       a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] swsusp: Do not use page flags
Message-Id: <20070315152328.228379db.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703152317260.12394@twin.jikos.cz>
References: <200703122214.02657.rjw@sisk.pl>
	<200703122219.21171.rjw@sisk.pl>
	<20070315110816.8b4102b3.akpm@linux-foundation.org>
	<200703152205.54639.rjw@sisk.pl>
	<20070315142955.7cbe62c1.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0703152317260.12394@twin.jikos.cz>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Mar 2007 23:19:02 +0100 (CET)
Jiri Kosina <jikos@jikos.cz> wrote:

> On Thu, 15 Mar 2007, Andrew Morton wrote:
> 
> > > > And why _does_ suspend use GFP_ATOMIC all over the place?
> > > Generally, because it cannot sleep.
> > Why not?
> 
> I guess it's simply beucase of kswapd being already frozen, so there is no 
> chance that once GFP_KERNEL allocation goes to sleep, it is going to get 
> any free pages eventually ... ?

No, things should run fine with a dead kswapd.

There are reasons why we can't call into filesystems from there, but
GFP_NOIO will ensure that and it is heaps better than GFP_ATOMIC.



