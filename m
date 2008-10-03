Return-Path: <linux-kernel-owner+w=401wt.eu-S1753151AbYJCOwA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151AbYJCOwA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 10:52:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751427AbYJCOvw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 10:51:52 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:54805 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750785AbYJCOvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 10:51:51 -0400
Date: Fri, 3 Oct 2008 10:51:49 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Andrew Morton <akpm@linux-foundation.org>
cc: yi.y.yang@intel.com, <linux-kernel@vger.kernel.org>,
       <dbrownell@users.sourceforge.net>, <gregkh@suse.de>,
       <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] USB: improve ehci_watchdog's side effect in CPU power
 management
In-Reply-To: <20081002165649.00d021db.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.44L0.0810031043590.2500-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Responding just Andrew's comments, disregarding whether or not the 
patch itself is worthwhile...

On Thu, 2 Oct 2008, Andrew Morton wrote:

> <looks>
> 
> <regrets it>
> 
> 
> Why does this:
> 
> 	t = DIV_ROUND_UP(EHCI_SHRINK_FRAMES * HZ, 1000) + 1;
> 
> add "1000" to a jiffies value when it doesn't know what HZ is?  It'll
> be adding anywhere from one second up to ten seconds to the timeout
> interval depending upon compile-time options.

Look again.  The macro doesn't _add_ 1000 to a jiffies value; it 
_divides_ the value by 1000.  This is because EHCI_SHRINK_FRAMES is in 
milliseconds.

However this could be changed to

	t = msecs_to_jiffies(EHCI_SHRINK_FRAMES) + 1;

even though that would involve more runtime code.

> I suspect s/1000/HZ/ would improve things here.  Or just delete it -
> doesn't the subsequent round_jiffies() do the same thing, only better? 
> This code needs help, I suspect.

That subsequent round_jiffies() is most likely a mistake.

> Also, do we really need to inline this large function into at least
> five callsites?

I agree; this function should not be inline.

Alan Stern

