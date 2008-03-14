Return-Path: <linux-kernel-owner+w=401wt.eu-S1757589AbYCNCSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757589AbYCNCSR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 22:18:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752116AbYCNCSF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 22:18:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48504 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751970AbYCNCSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 22:18:03 -0400
Date: Thu, 13 Mar 2008 19:17:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Brownell <david-b@pacbell.net>
Cc: linux-kernel@vger.kernel.org, avorontsov@ru.mvista.com
Subject: Re: [patch 2.6.25-rc5 1/2] gpiolib:  dynamic gpio number allocation
Message-Id: <20080313191747.dede60c3.akpm@linux-foundation.org>
In-Reply-To: <200803131753.58733.david-b@pacbell.net>
References: <200803131549.54632.david-b@pacbell.net>
	<200803131618.58516.david-b@pacbell.net>
	<20080313162803.ab8bfd4c.akpm@linux-foundation.org>
	<200803131753.58733.david-b@pacbell.net>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Mar 2008 16:53:58 -0800 David Brownell <david-b@pacbell.net> wrote:

> On Thursday 13 March 2008, Andrew Morton wrote:
> > On Thu, 13 Mar 2008 15:18:58 -0800
> > David Brownell <david-b@pacbell.net> wrote:
> > 
> > > On Thursday 13 March 2008, Andrew Morton wrote:
> > > 
> > > > hm.  I suppose that if someone want a huge number of GPIOs then we can
> > > > convert this to a bitmap or an IDR tree easily enough.
> > > 
> > > Actually, I tried IDRs for a while and they broke platforms
> > > which needed to initialize and use GPIOs early: before kmalloc
> > > would work.  A real PITA that was -- and slow too.
> > 
> > If IDRs were slow, that linear search will be glacial.
> 
> The slowness of IDRs was needing to use them for the
> routine lookups ... versus the current array index,
> which costs a fraction of an instruction cycle and
> doesn't need separate locks.
> 
> Or were you implying they should be used for something
> other than mapping GPIO numbers to controllers/state?
> 

For dynamic allocation.  There should be no need for lookups outside
register/unregister.


Where did the CONFIG_NR_GPIOS discussion disappear to?
