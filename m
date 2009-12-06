Return-Path: <linux-kernel-owner+w=401wt.eu-S933728AbZLFLij@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933728AbZLFLij (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 06:38:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933703AbZLFLii
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 06:38:38 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:35227 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933702AbZLFLih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 06:38:37 -0500
Date: Sun, 6 Dec 2009 12:38:43 +0100
From: Andreas Mohr <andi@lisas.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Andreas Mohr <andi@lisas.de>, Ondrej Zary <linux@rainbow-software.org>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: debugging oops after disconnecting Nexio USB touchscreen
Message-ID: <20091206113843.GA13276@rhlx01.hs-esslingen.de>
References: <20091205073652.GA30203@rhlx01.hs-esslingen.de> <Pine.LNX.4.44L0.0912051211530.15558-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0912051211530.15558-100000@netrider.rowland.org>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, Dec 05, 2009 at 12:16:13PM -0500, Alan Stern wrote:
> On Sat, 5 Dec 2009, Andreas Mohr wrote:
> 
> > Hi,
> > 
> > > Furthermore, the patch shows that the second-to-last argument to 
> > > usb_fill_bulk_urb() -- the completion function -- is NULL.  That is 
> > > strictly illegal and it should have caused an oops as soon as the URB 
> > > was used.
> > 
> > Then there's definitely a WARN_ON or so missing in
> > static inline void usb_fill_bulk_urb()
> 
> No there isn't.  That inline just fills in a bunch of fields.

After the fact I've been thinking that yes, such an inline helper
isn't really an appropriate location.

> > And highly likely more checks in those areas that are causing my (and
> > other people's) ftdi_sio tests and USB audio (MIPS mmap) to fail.
> > Followup soon.
> 
> Sometimes having too many checks is worse than having too few, 
> especially if the failure modes are relatively easy to handle.

True, many checks in all sorts of user places instead of the one core
place where it matters can clutter things. Especially since the WARN_ON
checks are unconditional, not a debug-only setting.

Andreas Mohr
