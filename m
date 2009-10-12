Return-Path: <linux-kernel-owner+w=401wt.eu-S1753817AbZJLDaE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753817AbZJLDaE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 23:30:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753682AbZJLDaD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 23:30:03 -0400
Received: from gate.crashing.org ([63.228.1.57]:47978 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753008AbZJLDaD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 23:30:03 -0400
Subject: Re: USB serial regression 2.6.31.1 -> 2.6.31.2 [PATCH]
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Ben Efros <ben@pc-doctor.com>, fangxiaozhi <huananhu@huawei.com>,
       Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>, Hugh Blemings <hugh@blemings.org>,
       Josua Dietze <digidietze@draisberghof.de>
In-Reply-To: <Pine.LNX.4.44L0.0910112150020.638-100000@netrider.rowland.org>
References: <Pine.LNX.4.44L0.0910112150020.638-100000@netrider.rowland.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 12 Oct 2009 14:28:15 +1100
Message-Id: <1255318095.2192.92.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-10-11 at 21:54 -0400, Alan Stern wrote:
> Possibly, but I sure wouldn't bet on it.   :-)
> 
> > I still think it's simpler and potentially more future-proof to just
> > have a back-off scenario.
> > 
> > Now, whether we ping pong the US_FL_SANE_SENSE flag or not is minor,
> > I tend to think that your approach that doesn't touch the flag might
> > indeed be better.
> > 
> > I'll test the patch later today.
> 
> And of course there remains the question of why the serial driver
> wasn't loaded and probed.  Would it make a difference if that driver
> was already loaded when you plugged in the modem? 

Without my hack, the serial driver -was- loaded an probed ... but the
device would go away as soon as the reset happened triggered by
usb-storage.

BTW. I noticed that USB storage is supposed to avoid doing the reset if
the device is multifunction. I suppose that flag gets set prior to the
"mode switch" and so the reset happens regardless... maybe we should set
that MF flag from the quirk that sends the mode switch ?

With my hack, I don't know what happened the first time around, it
worked fine afterward. I'll let you know if it happens again. Could be a
userspace glitch (I'm running Ubuntu Karmic, it's still a bit wet behind
the ears :-)

Cheers,
Ben.


