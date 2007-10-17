Return-Path: <linux-kernel-owner+w=401wt.eu-S1762276AbXJQXDb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762276AbXJQXDb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 19:03:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759378AbXJQXDX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 19:03:23 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58651
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757493AbXJQXDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 19:03:23 -0400
Date: Wed, 17 Oct 2007 16:03:36 -0700 (PDT)
Message-Id: <20071017.160336.95505053.davem@davemloft.net>
To: stern@rowland.harvard.edu
Cc: david-b@pacbell.net, linux-usb-users@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, greg@kroah.com
Subject: Re: [Linux-usb-users] OHCI root_port_reset() deadly loop...
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.44L0.0710171050010.4468-100000@iolanthe.rowland.org>
References: <20071016.150834.23011861.davem@davemloft.net>
	<Pine.LNX.4.44L0.0710171050010.4468-100000@iolanthe.rowland.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>
Date: Wed, 17 Oct 2007 11:51:57 -0400 (EDT)

> > +			break;
> > +	}
> > +	if (limit_1 < 0) {
> > +		ohci_warn(ohci, "Root port outer-loop reset timeout, "
> > +			  "now[%04x] reset_done[%04x]\n",
> > +			  now, reset_done);
> > +	}
> 
> What reason is there for having two warning messages?  One ought to be 
> enough.

In my patch it was possible for the inner loop one to succeed, but the
outer one to not do so.

In your's this is not the case so I guess it's OK.

I wonder if it's so wise trying to do two things at once.  Here we are
adding the loop timeouts, and also changing to using jiffies based
timeouts rather than a chip timer register based one.

I preferred my patches because it solved one single problem, the lack
of loop limits.  The timeout mechanism could have been changed in
another followon patch.
