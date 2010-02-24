Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757663Ab0BXTOJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 14:14:09 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36851 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757576Ab0BXTOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 14:14:08 -0500
Date: Wed, 24 Feb 2010 19:14:03 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/14] Regulators: wm8400 - cleanup platform driver
 data handling
Message-ID: <20100224191402.GA8316@rakim.wolfsonmicro.main>
References: <20100224073342.15964.8863.stgit@localhost.localdomain>
 <20100224073849.15964.62321.stgit@localhost.localdomain>
 <20100224102548.GG18896@rakim.wolfsonmicro.main>
 <20100224190234.GD25304@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100224190234.GD25304@core.coreip.homeip.net>
X-Cookie: Approved for veterans.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 24, 2010 at 11:02:34AM -0800, Dmitry Torokhov wrote:
> On Wed, Feb 24, 2010 at 10:25:49AM +0000, Mark Brown wrote:

> > Nack due to this change - this change would make it impossible for
> > callers to actually call the function.  Note that nothing including only
> > wm8400.h even has a struct declaration, much less defniition, for struct
> > wm8400.

> If you notice I added forward declaration of "struct wm8400" to wm8400.h
> thus users can pass around pointer to the structure.

This doesn't help unless you also provide a way for users to obtain a
struct wm8400.

> I really think we should refrain from passing naked 'struct device *'
> pointers as much as possible since it is error prone. Otherwise
> wm8400_register_regulator has no way of ensuting that passed  'dev' is
> indeed wm8400.

Right, there's no type safety here (and this whole method of registering
regulators is fairly deprecated anyway in favour of just straight
platform data) but really it doesn't buy us much - the users get exactly
the struct device they need to use passed in to them, there's really
very little chance for them to get confused about what they're talking
about.
