Return-Path: <linux-kernel-owner+w=401wt.eu-S1756762AbYCZPh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756762AbYCZPh6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 11:37:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752684AbYCZPht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 11:37:49 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:52986 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752604AbYCZPhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 11:37:48 -0400
Date: Wed, 26 Mar 2008 11:37:47 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Richard Kennedy <richard@rsk.demon.co.uk>
cc: dbrownell@users.sourceforge.net, linux-usb <linux-usb@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: ohci : strange looking use of round_jiffies_relative. possible
 bug ?
In-Reply-To: <1206542289.2931.17.camel@castor.localdomain>
Message-ID: <Pine.LNX.4.44L0.0803261136590.6324-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Mar 2008, Richard Kennedy wrote:

> I was looking at the uses of round_jiffies and noticed that the ohci
> unlink_watchdog_func() calls 
> mod_timer(&ohci->unlink_watchdog, round_jiffies_relative(HZ));
> 
> Which looks a bit strange as it will set the timer to 0 <= t < HZ.
> Reading the comments I think that is really is expecting to setup timer
> to (now + 1s)
> 
> mod_timer(&ohci->unlink_watchdog, round_jiffies(jiffies + HZ));
> 
> If this is not true then perhaps it needs a comment to explain what it
> _is_ trying to do, because it's got me baffled ;)

I'd say it's a bug.  Or rather a pair of bugs, since that mod_timer() 
call appears in two places.

Alan Stern

