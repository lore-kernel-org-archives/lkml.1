Return-Path: <linux-kernel-owner+w=401wt.eu-S1759804AbZCBS0r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759804AbZCBS0r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 13:26:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751468AbZCBS0i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 13:26:38 -0500
Received: from kroah.org ([198.145.64.141]:38563 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751398AbZCBS0h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 13:26:37 -0500
Date: Mon, 2 Mar 2009 10:23:34 -0800
From: Greg KH <greg@kroah.com>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: tom.leiming@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] driver core: implement uevent suppress in kobject(v1)
Message-ID: <20090302182334.GA4514@kroah.com>
References: <1235834729-14402-1-git-send-email-tom.leiming@gmail.com> <1235913049-4533-1-git-send-email-tom.leiming@gmail.com> <20090302185125.5038a705@gondolin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090302185125.5038a705@gondolin>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 02, 2009 at 06:51:25PM +0100, Cornelia Huck wrote:
> On Sun,  1 Mar 2009 21:10:49 +0800,
> tom.leiming@gmail.com wrote:
> 
> > From: Ming Lei <tom.leiming@gmail.com>
> > 
> > This patch implements uevent suppress in kobject and removes it
> > from struct device, based on the following ideas:
> > 
> > 1,Uevent sending should be one attribute of kobject, so suppressing it
> > in kobject layer is more natural than in device layer. By this way,
> > we can do it for other objects embedded with kobject.
> > 
> > 2,It may save several bytes for each instance of struct device.(On my
> > omap3(32bit ARM) based box, can save 8bytes per device object)
> > 
> > This patch also introduces dev_set|get_uevent_suppress() helpers to
> > set and query uevent_suppress attribute in case to help kobject
> > as private part of struct device in future.
> 
> But moving the kobject into an allocated private structure would be
> rather broken?

For one thing, attribute usages, yes, it is a "broken" idea, but one
that I have played around with at times.

The main reason I was wanting to do this was to fix the issue of
statically created kobjects, which is not a good idea.  But that's a
long-term goal, that I'm still working toward in different ways (fixing
up sysdev is the first thing to help with that.)

> I have no objections to the patch, though, and it worked fine on my
> s390 LPAR.

I don't either, thanks for testing.  Ming, I'll add this to my queue,
thanks for doing it.

greg k-h
