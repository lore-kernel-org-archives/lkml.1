Return-Path: <linux-kernel-owner+w=401wt.eu-S1755723AbYEJTIi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755723AbYEJTIi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2008 15:08:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752819AbYEJTI2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 May 2008 15:08:28 -0400
Received: from verein.lst.de ([213.95.11.210]:58813 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752804AbYEJTI1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2008 15:08:27 -0400
Date: Sat, 10 May 2008 21:07:59 +0200
From: Christoph Hellwig <hch@lst.de>
To: Robert Richter <robert.richter@amd.com>
Cc: Carl Love <cel@us.ibm.com>, linuxppc-dev@ozlabs.org,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       cbe-oss-dev@ozlabs.org, Arnd Bergmann <arnd@arndb.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [Cbe-oss-dev] [PATCH] Updated: Reworked Cell OProfile: SPU	mutex lock fix
Message-ID: <20080510190759.GA16275@lst.de>
References: <1209587712.7531.42.camel@carll-linux-desktop> <20080509150759.GL24041@erda.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080509150759.GL24041@erda.amd.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +	/* Ignoring the return value from the unregister
> > +	 * call.  A failed return value simply says there
> > +	 * was no registered event.  Hence there will not
> > +	 * be any calls to process a switch event that
> > +	 * could cause a problem.
> > +	 */
> > +	spu_switch_event_unregister(&spu_active);
> 
> Better to use this here, to show the return value is ignored:
> 
>        (void)spu_switch_event_unregister(...)

Actually Linux style is to not add those casts.  But I don't think we
all the notifier_chain_unregister funtion should return error at all,
we should probably fix that up in the core code.
