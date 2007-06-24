Return-Path: <linux-kernel-owner+w=401wt.eu-S1756200AbXFXUAg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756200AbXFXUAg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 16:00:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754421AbXFXT74
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 15:59:56 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:52487 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754563AbXFXT7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 15:59:53 -0400
Date: Sun, 24 Jun 2007 20:59:52 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-sparse@vger.kernel.org
Subject: Re: [PATCH 16/16] fix handling of integer constant expressions
Message-ID: <20070624195952.GD21478@ftp.linux.org.uk>
References: <E1I2N6V-0003g9-8H@ZenIV.linux.org.uk> <20070624174732.GZ21478@ftp.linux.org.uk> <alpine.LFD.0.98.0706241102160.3593@woody.linux-foundation.org> <20070624183547.GA21478@ftp.linux.org.uk> <alpine.LFD.0.98.0706241203530.3593@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0706241203530.3593@woody.linux-foundation.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 24, 2007 at 12:04:44PM -0700, Linus Torvalds wrote:
> 
> 
> On Sun, 24 Jun 2007, Al Viro wrote:
> > 
> > Why?  I'd say it's not better than BUILD_BUG_ON_ZERO() use
> > instead of that ?:
> 
> Oh, _that_ part I have no problem with. It's more that it seems that the 
> gcc optimization is ok at least as an extension.

gcc logs:
	* expressions of form <....> can be reduced to cheaper form
	  by <....>.  Tested and merged.

gcc logs a year later:
	* revert commit <...>, it causes subtle problems (see PR<....>,
	  <....> and <....>).  Proposed replacement is too intrusive
	  for stable branch.

gcc logs a month later:
	* tested and merged the real fix for PR<....>; will go into the
	  next release.

foobar logs a year later:
	* gcc versions between <...> and <...> refuse to compile baz.c,
	  complain about non-constant index in initializer.  Waded through
	  the sewers of macros we have in barf.h and blah.h, found what
	  had been causing that.  Fixed.

Ain't fun...
