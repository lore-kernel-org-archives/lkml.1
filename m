Return-Path: <linux-kernel-owner+w=401wt.eu-S1756072AbYAGIot@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072AbYAGIot (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 03:44:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754477AbYAGIoi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 03:44:38 -0500
Received: from mx2.suse.de ([195.135.220.15]:42146 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754063AbYAGIoh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 03:44:37 -0500
Date: Mon, 7 Jan 2008 00:45:28 -0800
From: Greg KH <gregkh@suse.de>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, stern@rowland.harvard.edu,
       peterz@infradead.org, david-b@pacbell.net, davem@davemloft.net,
       jarkao2@gmail.com, krh@redhat.com, dbrownell@users.sourceforge.net,
       James.Bottomley@HansenPartnership.com, a.zummo@towertech.it,
       cbou@mail.ru, dwmw2@infradead.org,
       linux1394-devel@lists.sourceforge.net,
       spi-devel-general@lists.sourceforge.net, linux-scsi@vger.kernel.org,
       rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] convert semaphore to mutex in struct class
Message-ID: <20080107084528.GA8365@suse.de>
References: <20080103055019.GA4885@darkstar.te-china.tietoenator.com> <478120D9.5090404@s5r6.in-berlin.de> <20080107020944.GA3637@darkstar.te-china.tietoenator.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080107020944.GA3637@darkstar.te-china.tietoenator.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 07, 2008 at 10:09:44AM +0800, Dave Young wrote:
> 
> Thanks for your comment, I rewrite it for 2.6.24-rc7 as a all-in-one
> patch, please see following. Drop i2c maintainer and list in cc
> because there's no changes about i2c in this patch:
> 
> Convert semaphore to mutex in struct class

Most of the non-driver core code should be converted to not use the
lock in the class at all.  They should use a local lock instead.

So how about a patch series that removes the usage of the current
semaphore from the different drivers, and then, a single patch that
converts the semaphore to mutex in the class code, it should not touch
anything outside of the drivers/base/ directory (not including the
driver.h file.)

Sound reasonable?

thanks,

greg k-h
