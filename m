Return-Path: <linux-kernel-owner+w=401wt.eu-S1762197AbXIZWWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762197AbXIZWWT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 18:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754109AbXIZWWK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 18:22:10 -0400
Received: from mga03.intel.com ([143.182.124.21]:18675 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755950AbXIZWWJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 18:22:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,199,1188802800"; 
   d="scan'208";a="287385308"
From: Jesse Barnes <jesse.barnes@intel.com>
To: Greg KH <greg@kroah.com>
Subject: Re: PCI: Fix boot-time hang on G31/G33 PC
Date: Wed, 26 Sep 2007 15:20:40 -0700
User-Agent: KMail/1.9.7
Cc: linux-pci@atrey.karlin.mff.cuni.cz, Matthew Wilcox <matthew@wil.cx>,
       linux-kernel@vger.kernel.org, Robert Hancock <hancockr@shaw.ca>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>
References: <20070826015556.GC14130@parisc-linux.org> <200709261455.56165.jesse.barnes@intel.com> <20070926215648.GA24505@kroah.com>
In-Reply-To: <20070926215648.GA24505@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709261520.40859.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, September 26, 2007 2:56 pm Greg KH wrote:
> On Wed, Sep 26, 2007 at 02:55:55PM -0700, Jesse Barnes wrote:
> > On Wednesday, September 26, 2007 2:18 pm Greg KH wrote:
> > > Due to the issues surrounding this patch, I'm dropping it from my
> > > repo.
> >
> > What issues?  Is it causing problems for people?
>
> I thought this was the patch that Ivan objected to.

Yeah, Ivan objected to this, but incorrectly I think.

Ivan, your concern is about disabling things like interrupt controllers 
and power management chips during probe right?  You're right that doing 
that could cause problems if we get and interrupt or PMU event at just 
the wrong time, but that could just as easily happen if decode was 
still enabled but the BAR had a bogus address programmed (as it would 
during probing).

Ultimately, I don't care much one way or another as long as we can get 
the desktop platforms fixed somehow.  I think disabling decode is the 
most correct way of doing this, but I'm open to other solutions (this 
is the only patch I've seen though that's been tested to solve the 
problem).

Jesse
