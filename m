Return-Path: <linux-kernel-owner+w=401wt.eu-S1755555AbYILMFf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555AbYILMFf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 08:05:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752728AbYILMFZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 08:05:25 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37351 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752477AbYILMFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 08:05:25 -0400
Date: Fri, 12 Sep 2008 13:05:23 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@openedhand.com>
Cc: Liam Girdwood <lrg@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mfd: Core support for the WM8400 AudioPlus HiFi
	CODEC and PMU
Message-ID: <20080912120522.GA21720@rakim.wolfsonmicro.main>
Mail-Followup-To: Samuel Ortiz <sameo@openedhand.com>,
	Liam Girdwood <lrg@kernel.org>, linux-kernel@vger.kernel.org
References: <20080910182825.GB16721@rakim.wolfsonmicro.main> <1221071334-19381-1-git-send-email-broonie@opensource.wolfsonmicro.com> <20080912105413.GA4999@localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080912105413.GA4999@localdomain>
X-Cookie: Q: Are we not men?
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2008 at 12:54:19PM +0200, Samuel Ortiz wrote:

> > +config MFD_WM8400
> > +	tristate "Support Wolfson Microelectronics WM8400"
> > +	select MFD_CORE
> It seems you're not using the mfd-core API currently.
> Maybe we could get rid of this select for now ?

Done, will be in the next version I push out.

> > --- /dev/null
> > +++ b/include/linux/mfd/wm8400-private.h
> Just a remark here: many chunks from this file are really wm8400 private and
> could live in drivers/mfd/wm8400.h.

Which chunks in particular?  Note that I've not currently included the
audio driver - it will need much more interaction with the core than the
regulator support does and it doesn't feel right to have it peer into
drivers/mfd for things it needs.  While I have split much of that into a
separate audio header file for the next submission there are several
areas which cross over multiple functions.

> I would also prefer to have one single wm8400.h file in include/linux/mfd/,
> containing both those definitions and the ones you're adding with the
> regulator patch.

The goal in splitting out wm8400.h from wm8400-private.h was to ensure
that the (fairly small) interface intended for use by clients of the
driver was clearly separated from the interfaces intended for use within
the WM8400 drivers themselves.  I'd like to keep this separation since
it makes it clearer to users which interfaces they should be using and
having to include a separate file makes this very easy to spot on
review.
