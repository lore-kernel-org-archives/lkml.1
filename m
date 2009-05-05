Return-Path: <linux-kernel-owner+w=401wt.eu-S1754188AbZEEAdv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188AbZEEAdv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 20:33:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755934AbZEEAdi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 20:33:38 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:31992 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754475AbZEEAdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 20:33:36 -0400
X-IronPort-AV: E=Sophos;i="4.40,294,1238976000"; 
   d="scan'208";a="180744033"
Date: Mon, 4 May 2009 17:33:37 -0700
From: David VomLehn <dvomlehn@cisco.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Sergey Vlasov <vsu@altlinux.ru>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       USB list <linux-usb@vger.kernel.org>, Greg KH <greg@kroah.com>,
       SCSI development list <linux-scsi@vger.kernel.org>,
       netdev@vger.kernel.org, arjan@infradead.org
Subject: Re: [PATCH 1/5] initdev:kernel: Asynchronously-discovered device
	synchronization, v5
Message-ID: <20090505003337.GF29124@cuplxvomd02.corp.sa.net>
References: <20090502133153.GA8116@atlas.home> <Pine.LNX.4.44L0.0905021010200.23879-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0905021010200.23879-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Authentication-Results: sj-dkim-3; header.From=dvomlehn@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 02, 2009 at 10:16:39AM -0400, Alan Stern wrote:
> I agree with Sergey's comments.  In addition:
> 
> On Fri, May 01, 2009 at 07:25:51PM -0700, David VomLehn wrote:
> 
> > +initdev_wait(enum initdev_type type, bool (*done)(void))
> > +	Wait until one of two conditions is met:
> > +	o	All possible init devices of the given type have been probed
> > +	o	The "done" function returns true
> > +
> > +	The type is one of:
> > +		BOOTDEV_CONSOLE
> > +		BOOTDEV_NETDEV
> > +		BOOTDEV_BLOCK
> 
> These should be named INITDEV_CONSOLE_TYPE and so on, with the final 
> _TYPE suffix to help prevent confusion with INITDEV_CONSOLE_MASK.

Yes, I think this will help.

> Also, in patch 3/5:
> 
> > --- a/drivers/accessibility/braille/braille_console.c
> > +++ b/drivers/accessibility/braille/braille_console.c
> > @@ -35,6 +35,7 @@
> >  #include <linux/keyboard.h>
> >  #include <linux/kbd_kern.h>
> >  #include <linux/input.h>
> > +#include <linux/initdev.h>
> 
> What does this do?  It looks like a typo.

It is one.

> Alan Stern

Thanks!

David VomLehn
