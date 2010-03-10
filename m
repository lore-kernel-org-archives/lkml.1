Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756147Ab0CJDQv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 22:16:51 -0500
Received: from kroah.org ([198.145.64.141]:52265 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756028Ab0CJDQs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 22:16:48 -0500
Date: Tue, 9 Mar 2010 18:37:27 -0800
From: Greg KH <greg@kroah.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Magnus Damm <damm@opensource.se>, linux-kernel@vger.kernel.org,
       linux-sh@vger.kernel.org
Subject: Re: [PATCH] driver core: Early dev_name() support.
Message-ID: <20100310023727.GB26642@kroah.com>
References: <20100309065753.GA8287@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100309065753.GA8287@linux-sh.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 09, 2010 at 03:57:53PM +0900, Paul Mundt wrote:
> Presently early platform devices suffer from the fact they are unable to
> use dev_xxx() calls early on due to dev_name() and others being
> unavailable at the time ->probe() is called.
> 
> This implements early init_name construction from the matched name/id
> pair following the semantics of the late device/driver match. As a
> result, matched IDs (inclusive of requested ones) are preserved when the
> handoff from the early platform code happens at kobject initialization
> time.
> 
> Since we still require kmalloc slabs to be available at this point, using
> kstrdup() for establishing the init_name works fine. This subsequently
> needs to be tested from dev_name() prior to the init_name being cleared
> by the driver core. We don't kfree() since others will already have a
> handle on the string long before the kobject initialization takes place.
> 
> This is also needed to permit drivers to use the clock framework early,
> without having to manually construct their own device IDs from the match
> id/name pair locally (needed by the early console and timer code on sh
> and arm).

Is this change something that we need for .34?  Or can it wait for .35?

thanks,

greg k-h
