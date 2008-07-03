Return-Path: <linux-kernel-owner+w=401wt.eu-S1756524AbYGCTlf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756524AbYGCTlf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 15:41:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755613AbYGCTlT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 15:41:19 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58667 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755579AbYGCTlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 15:41:18 -0400
Date: Thu, 3 Jul 2008 12:37:55 -0700
From: Greg KH <greg@kroah.com>
To: David Brownell <david-b@pacbell.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michael Buesch <mb@bu3sch.de>,
       sfr@canb.auug.org.au, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gpiolib: Allow user-selection
Message-ID: <20080703193755.GC14194@kroah.com>
References: <200807022346.53222.mb@bu3sch.de> <200807022200.49428.david-b@pacbell.net> <20080702220842.44364045.akpm@linux-foundation.org> <200807022241.28046.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807022241.28046.david-b@pacbell.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2008 at 10:41:27PM -0700, David Brownell wrote:
> The new "-next" process is still working out.  Backwards-incompatible
> changes will *always* make problems.  In this case there seem to
> have been three such changes:
> 
> 	- device_create() vanishing, even for users which did the
> 	  locking correctly ... this was at least something of a
> 	  graceful migration, although it would have been better
> 	  if it were deprecated first.  Change can work against
> 	  the current (2.6.26) code base.

device_create() did disappear in -next, but when it goes to Linus it
will not, it will come back as a #define and everything will be
converted back.  That was to catch the build errors when I audited the
whole tree.  The -rc1 merge cycle will handle this properly.

> 	- class.devices vanishing ... what I really needed was
> 	  more of a "is this class initialized yet" call, so
> 	  testing for class->devices.next non-null can be replaced
> 	  by a test for class->p non-null.  (Or maybe this should
> 	  be viewed as needing a "real" driver model call, so that
> 	  code which must run before driver model init can more
> 	  easily cooperate with driver model stuff that has to
> 	  run much later, after the guts are initialized.)

If you need such a function, please let me know and I can provide it, I
was not aware of anyone using class.devices, it is an
internal-to-the-driver-core field, and has moved private.

> 	- Extra parameter to class_find_device().  This could
> 	  have been done in a backwards-compatible manner, like
> 	  device_create() was, but ... it wasn't.

This was simpler as there were less users of this function.  And the
whole tree was fixed up.  If there are trees on top of -next that I
can't see, that's pretty hard for me to fix :)

thanks,

greg k-h
