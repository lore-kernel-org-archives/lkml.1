Return-Path: <linux-kernel-owner+w=401wt.eu-S933254AbYCDTNu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933254AbYCDTNu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 14:13:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933111AbYCDTNh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 14:13:37 -0500
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:28677 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933105AbYCDTNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 14:13:36 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=A07MBtbiuOMVblEXC996EYHRg/5hHdg2ejQmVcQ+96ILK11sR9dQZIUVyrMvyNCLWYLC5pjcwHY7uLxFbfQ0h4UIdiFhP06Cu7Qvx/apUhbDC2c/sZ4xmN/u83Y3TmmikRc7pFuJS2pWADVUQasHJoqkSIxX2bsKJ+1FQhkCZ9w=  ;
X-YMail-OSG: pYT_eRoVM1k.at8sXk1.Bm.xDHL6vVMMCOGfM0J.8TcuJYLnSmpSc07WcEMk0IClBgM7fsmZMw--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Bugs in MMC [was: [Bug 10030] Suspend doesn't work when SD card is inserted]
Date: Tue, 4 Mar 2008 10:53:44 -0800
User-Agent: KMail/1.9.6
Cc: Pierre Ossman <drzeus-mmc@drzeus.cx>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.0803041252480.15190-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0803041252480.15190-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803041053.44909.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 March 2008, Alan Stern wrote:
> On Tue, 4 Mar 2008, David Brownell wrote:
> 
> > Or, as pointed out elsewhere, well-behaved MMC hosts ... which don't
> > need either such reprobing or the associated remove-on-suspend.
> 
> I don't understand this comment.  Suppose a card was inserted while the 
> system was hibernating.  If the core didn't reprobe, when would that 
> card be discovered?

The host controller would tell the core to check for a card, exactly
like it does at all other times.

That's the natural alternative to having the MMC core assume that card
detection was broken in low power states, so that the core needed to
forcibly remove the cards before suspend, and reprobe during resume
processing.

Having the MMC core make such needless assumptions can cause problems
for the upper layers, including filesystems.

- Dave

