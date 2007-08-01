Return-Path: <linux-kernel-owner+w=401wt.eu-S1754991AbXHAECp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754991AbXHAECp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 00:02:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750763AbXHAECg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 00:02:36 -0400
Received: from ozlabs.org ([203.10.76.45]:57041 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899AbXHAECf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 00:02:35 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18096.1493.86023.542969@cargo.ozlabs.ibm.com>
Date: Wed, 1 Aug 2007 14:02:29 +1000
From: Paul Mackerras <paulus@samba.org>
To: Greg KH <gregkh@suse.de>
Cc: Andreas Schwab <schwab@suse.de>, WANG Cong <xiyou.wangcong@gmail.com>,
       Satyam Sharma <satyam@infradead.org>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       jack@hawkeye.stone.uk.eu.org, linux-kernel@vger.kernel.org,
       trivial@kernel.org
Subject: Re: [Patch 09/16] Remove unnecessary kmalloc casts in the pci
	subsystem.
In-Reply-To: <20070731174755.GA8592@suse.de>
References: <20070731125316.860150000@hawkeye.stone.uk.eu.org>
	<20070731125443.880871000@hawkeye.stone.uk.eu.org>
	<200707311553.29090.borntraeger@de.ibm.com>
	<alpine.LFD.0.999.0707311956170.26032@enigma.security.iitk.ac.in>
	<20070731144619.GA8183@localhost.localdomain>
	<20070731161051.GA7490@suse.de>
	<jeir80y27m.fsf@sykes.suse.de>
	<20070731174755.GA8592@suse.de>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH writes:

> On Tue, Jul 31, 2007 at 06:20:29PM +0200, Andreas Schwab wrote:
> > Greg KH <gregkh@suse.de> writes:
> > 
> > > On Tue, Jul 31, 2007 at 10:46:19PM +0800, WANG Cong wrote:
> > >> However, I think using resource_size_t is a bit better than unsigned long,
> > >> so that we don't need to check the defination of it.
> > >> 
> > >> - res->start = (unsigned long)kmalloc(*size, GFP_KERNEL);
> > >> + res->start = (resource_size_t)kmalloc(*size, GFP_KERNEL);
> > >> 
> > >> Is this change OK?
> > >
> > > Yes, that is the proper cast to have here.
> > 
> > It will generate a warning when resoure_size_t is 64bit on a 32bit arch.
> 
> How?  And if so, what should the proper cast be?

You'll get a "cast from pointer to different-sized integer" type of
warning.  The proper cast is unsigned long, just like the code is
without this patch. :)

Paul.
