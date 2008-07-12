Return-Path: <linux-kernel-owner+w=401wt.eu-S1754114AbYGLFWL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114AbYGLFWL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 01:22:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753689AbYGLFV4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 01:21:56 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:37449 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753686AbYGLFVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 01:21:55 -0400
Date: Fri, 11 Jul 2008 23:21:49 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Jon Smirl <jonsmirl@gmail.com>
Cc: linuxppc-dev@ozlabs.org, spi-devel-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, fabrizio.garetto@gmail.com,
       david-b@pacbell.net
Subject: Re: [PATCH v2 4/5] spi: Add OF binding support for SPI busses
Message-ID: <20080712052149.GA23213@secretlab.ca>
References: <20080703005749.26187.71719.stgit@trillian.secretlab.ca> <20080703010313.26187.99119.stgit@trillian.secretlab.ca> <9e4733910807022002n3c739c7cs8ed642e4a6027bb6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9e4733910807022002n3c739c7cs8ed642e4a6027bb6@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2008 at 11:02:23PM -0400, Jon Smirl wrote:
> On 7/2/08, Grant Likely <grant.likely@secretlab.ca> wrote:
> > From: Grant Likely <grant.likely@secretlab.ca>
> >
> >  This patch adds support for populating an SPI bus based on data in the
> >  OF device tree.  This is useful for powerpc platforms which use the
> >  device tree instead of discrete code for describing platform layout.
> >
> >  Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> >  ---
> >  +               /* Select device driver */
> >  +               sprop = of_get_property(nc, "linux,modalias", &len);
> >  +               if (sprop && len > 0)
> >  +                       strncpy(spi->modalias, sprop, KOBJ_NAME_LEN);
> >  +               else
> >  +                       strncpy(spi->modalias, "spidev", KOBJ_NAME_LEN);
> 
> You're missing a request_module("%s", info.type) to make sure the
> module is loaded.
> 
> It might make sense to share code with of_find_i2c_driver() so we have
> a common way of guessing module names.

You're right.  I've refactored the i2c code to make it usable by SPI
also.  I'll post the new patch series this evening.

g.
