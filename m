Return-Path: <linux-kernel-owner+w=401wt.eu-S1765902AbYAaIpz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765902AbYAaIpz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 03:45:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765123AbYAaIph
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 03:45:37 -0500
Received: from pip15.gyao.ne.jp ([61.122.117.253]:62934 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1765447AbYAaIpg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 03:45:36 -0500
Date: Thu, 31 Jan 2008 17:44:33 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: David Brownell <david-b@pacbell.net>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
       Shannon Nelson <shannon.nelson@intel.com>, kernel@avr32linux.org,
       Francis Moreau <francis.moro@gmail.com>,
       "Vladimir A. Barinov" <vbarinov@ru.mvista.com>,
       Pierre Ossman <drzeus-list@drzeus.cx>
Subject: Re: [RFC v2 2/5] dmaengine: Add slave DMA interface
Message-ID: <20080131084433.GA14160@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	David Brownell <david-b@pacbell.net>,
	Haavard Skinnemoen <hskinnemoen@atmel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	linux-kernel@vger.kernel.org,
	Shannon Nelson <shannon.nelson@intel.com>, kernel@avr32linux.org,
	Francis Moreau <francis.moro@gmail.com>,
	"Vladimir A. Barinov" <vbarinov@ru.mvista.com>,
	Pierre Ossman <drzeus-list@drzeus.cx>
References: <1201630213-31900-1-git-send-email-hskinnemoen@atmel.com> <200801300252.50344.david-b@pacbell.net> <20080130132651.7320d301@dhcp-252-066.norway.atmel.com> <200801310027.25516.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801310027.25516.david-b@pacbell.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2008 at 12:27:24AM -0800, David Brownell wrote:
> On Wednesday 30 January 2008, Haavard Skinnemoen wrote:
> > So basically, you're asking for maximum flexibility with minimum
> > overhead.  I agree that should be the ultimate goal, but wouldn't it
> > be better to start with something more basic?
> 
> Where you start is often NOT where you end up!  You should make sure
> that a wants-to-be-generic slave interface can accomodate a variety of
> non-basic mechanisms, without getting bloated.  :)
> 
I agree with Haavard here. The original dmaengine code was sparse at best
and for a very specific type of workload, evolving that in to something
that can be used by far more people with minimal pain is a good first
step. Trying to overengineer it from the beginning to accomodate fringe
controllers that already have an established API pretty much blocks the
vast majority of users for this work. It also adds in additional
complexity that is simply unnecessary for most of the controllers out
there.

Flexibility is a nice thing to have, but there's absolutely no reason to
penalize all of the other users for this due to the fact that OMAP wants
to be different. Perhaps rather than reinventing the OMAP DMA framework,
it would make more sense to just provide a dmaengine driver that wraps in
to it. You're ultimately going to be dealing with a reduced set of
functionality, but users that need to hook in to all of the quirks of the
hardware are going to be special-cased drivers anyways.
