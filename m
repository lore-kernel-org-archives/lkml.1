Return-Path: <linux-kernel-owner+w=401wt.eu-S1758678AbYCZPq7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758678AbYCZPq7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 11:46:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754788AbYCZPqt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 11:46:49 -0400
Received: from anchor-post-32.mail.demon.net ([194.217.242.90]:1687 "EHLO
	anchor-post-32.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754299AbYCZPqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 11:46:48 -0400
Subject: Re: ohci : strange looking use of round_jiffies_relative. possible
	bug ?
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: dbrownell@users.sourceforge.net, linux-usb <linux-usb@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.0803261136590.6324-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.0803261136590.6324-100000@iolanthe.rowland.org>
Content-Type: text/plain
Date: Wed, 26 Mar 2008 15:46:45 +0000
Message-Id: <1206546405.2931.20.camel@castor.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-03-26 at 11:37 -0400, Alan Stern wrote:
> On Wed, 26 Mar 2008, Richard Kennedy wrote:
> 
> > I was looking at the uses of round_jiffies and noticed that the ohci
> > unlink_watchdog_func() calls 
> > mod_timer(&ohci->unlink_watchdog, round_jiffies_relative(HZ));
> > 
> > Which looks a bit strange as it will set the timer to 0 <= t < HZ.
> > Reading the comments I think that is really is expecting to setup timer
> > to (now + 1s)
> > 
> > mod_timer(&ohci->unlink_watchdog, round_jiffies(jiffies + HZ));
> > 
> > If this is not true then perhaps it needs a comment to explain what it
> > _is_ trying to do, because it's got me baffled ;)
> 
> I'd say it's a bug.  Or rather a pair of bugs, since that mod_timer() 
> call appears in two places.
> 
> Alan Stern
> 
Thanks. In that case I'll post a patch.
Richard 

