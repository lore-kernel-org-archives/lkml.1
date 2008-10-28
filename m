Return-Path: <linux-kernel-owner+w=401wt.eu-S1753784AbYJ1LYl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753784AbYJ1LYl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 07:24:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752772AbYJ1LYb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 07:24:31 -0400
Received: from smtp.nokia.com ([192.100.105.134]:33006 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759AbYJ1LYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 07:24:30 -0400
Date: Tue, 28 Oct 2008 13:23:41 +0200
From: Felipe Balbi <felipe.balbi@nokia.com>
To: ext Jonathan Cameron <jic23@cam.ac.uk>
Cc: eric miao <eric.y.miao@gmail.com>, Liam Girdwood <lrg@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Regulator RFC] da903x: Where should usb charge pump support
	go?
Message-ID: <20081028112341.GF27144@gandalf.research.nokia.com>
Reply-To: felipe.balbi@nokia.com
References: <4906F500.7080100@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4906F500.7080100@cam.ac.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-OriginalArrivalTime: 28 Oct 2008 11:23:50.0750 (UTC) FILETIME=[A70917E0:01C938EF]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2008 at 11:18:24AM +0000, ext Jonathan Cameron wrote:
> Dear All,
> 
> The new da903x driver is proving to be a good replacement for the out of kernel
> driver I've been using previously.
> 
> Unfortunately there is still quite a lot of functionality to to add.
> 
> The key one for me is control of the USB charge pump. So the question is, does
> this fit within the regulator framework (i.e. should I add it to the regulator
> driver) or should this be a seperate driver (and if so where?)
> 
> Personally I'm not convinced it fits cleanly within the regulator framework
> given it is probably only ever going to get called from one driver and has
> somewhat odd properties!

I was thinking the same and even mailed Liam and Mark about it. The
design I was thinking was the charger chip would be done in regulator
framework and the battery chip (or current gauge) would be using power
supply fw and regulator consumer device.

The constraints would be basically the current and/or voltage range your
charger chip supports.

I still didn't have much time to hack on it, but seemed to be pretty
reasonable.

If someone has better idea, I'd trully like to hear that.

-- 
balbi
