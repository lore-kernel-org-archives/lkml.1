Return-Path: <linux-kernel-owner+w=401wt.eu-S1752013AbXCGPjJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752013AbXCGPjJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 10:39:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752007AbXCGPjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 10:39:09 -0500
Received: from smtp.osdl.org ([65.172.181.24]:40314 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752005AbXCGPjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 10:39:08 -0500
Date: Wed, 7 Mar 2007 07:39:00 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Greg KH <greg@kroah.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux v2.6.21-rc3
In-Reply-To: <1173263132.9349.47.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0703070735240.5963@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0703062050570.5963@woody.linux-foundation.org>
 <1173263132.9349.47.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 7 Mar 2007, Benjamin Herrenschmidt wrote:
>
> On Tue, 2007-03-06 at 20:59 -0800, Linus Torvalds wrote:
> 
> > Linus Torvalds (2):
> >       Revert "[PATCH] LOG2: Alter get_order() so that it can make use of ilog2() on a constant"
> >       Linux 2.6.21-rc3
> 
> Greg, I think we should revert that patch in 2.6.20.x stable serie too
> as get_order is broken there as well, causing random kernel memory
> corruption every now and then among others.

Did you confirm that that was indeed the cause of the problem you saw?

As far as I can tell, the bug (because it tested the wrong #define) would 
only affect the constant-size case, and only for something larger than a 
single page, and only for a non-power-of-two size. So it looked fairly 
hard to trigger, if only because all the obvious constants I saw seemed 
to already be powers-of-two..

So did you hunt it down to a particular cases where it triggers?

		Linus
