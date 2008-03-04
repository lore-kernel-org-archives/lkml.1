Return-Path: <linux-kernel-owner+w=401wt.eu-S1760636AbYCDJoW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760636AbYCDJoW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 04:44:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754732AbYCDJoN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 04:44:13 -0500
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:20683 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752939AbYCDJoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 04:44:12 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=ynhSYSN/veyW1ZNwxggZiuvIyI/pyL8rKbETqdEZWt2l9lBkyyVyW9U02XR13VDORNpHmYKe7lFwpM5WH97rQPamc8ytypYHwaPoftZOaZM/SLcchYFmwfyZb/Yj+5tEQAlknNhEMNnldnP27Q6ajriEOqJuMNB7C7Hb33AgE2o=  ;
X-YMail-OSG: B1ck0GAVM1mBVfmNibH0dO0Heig8XDSIXF.vI1caSNfu0g2C3klLEyk3jSqvnn2.hMqK25isLA--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Subject: Re: Bugs in MMC [was: [Bug 10030] Suspend doesn't work when SD card is inserted]
Date: Tue, 4 Mar 2008 01:44:09 -0800
User-Agent: KMail/1.9.6
Cc: Alan Stern <stern@rowland.harvard.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
References: <200802241500.41969.rjw@sisk.pl> <200803031359.38263.david-b@pacbell.net> <20080304070357.61ee825b@mjolnir.drzeus.cx>
In-Reply-To: <20080304070357.61ee825b@mjolnir.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803040144.09601.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 March 2008, Pierre Ossman wrote:
> On Mon, 3 Mar 2008 13:59:37 -0800
> David Brownell <david-b@pacbell.net> wrote:
> 
> > 
> > Card insert/remove events can be system wake events though.  Which
> > makes that restriction impractical.

This part seems to be ignored by your comment ... wake events.


> > I think hosts need to be able to call mmc_detect_change() as soon as
> > they see a stable signal.  The MMC core can hold off handling that
> > for a while, if it needs to wait until the code walking the device
> > tree gets around to resuming that host.  It's a lot more natural to
> > hold off such stuff one time there than in N host drivers; especially
> > since the MMC core already has such hold-off code.
> > 
> 
> That actually sorts itself out as the MMC core reprobes on wakeup, but
> I see your point. Right now things will work peachy if the controllers
> just make sure to disable their card detection logic before telling the
> core to suspend.   

That is, the MMC core doesn't understand wakeup events.

Or, as pointed out elsewhere, well-behaved MMC hosts ... which don't
need either such reprobing or the associated remove-on-suspend.

- Dave
