Return-Path: <linux-kernel-owner+w=401wt.eu-S1755516AbZKBRPO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516AbZKBRPO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 12:15:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754235AbZKBRPL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 12:15:11 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:41256 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbZKBRPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 12:15:08 -0500
Date: Mon, 2 Nov 2009 12:10:20 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: wpa2 hangs v2.6.32-rc5-402-gb6727b1. Revert
	7d930bc33653d5592dc386a76a38f39c2e962344 fixed it.
Message-ID: <20091102171019.GG14046@tuxdriver.com>
References: <Pine.LNX.4.64.0911012318000.3549@boston.corp.fedex.com> <1257089345.3555.158.camel@johannes.local> <b6a2187b0911011612v4a874640s62105a7323b01ad0@mail.gmail.com> <alpine.LFD.2.01.0911011641101.31845@localhost.localdomain> <1257151742.3555.165.camel@johannes.local> <b6a2187b0911020705v2377928dn15523318d7c2f09d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6a2187b0911020705v2377928dn15523318d7c2f09d@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 02, 2009 at 11:05:07PM +0800, Jeff Chua wrote:
> On Mon, Nov 2, 2009 at 4:49 PM, Johannes Berg <johannes@sipsolutions.net>wrote:
> 
> > On Sun, 2009-11-01 at 16:53 -0800, Linus Torvalds wrote:
> > > That decodes to
> > > cfg80211_conn_work+89:
> > > ie it looks like 'conn->params.bssid' is NULL and we oops when we try to
> > > load bssid from there. The code is:
> > >       memcpy(bssid, wdev->conn->params.bssid, ETH_ALEN);
> > > And yes, that "memcpy()" was added in that buggy commit.
> >
> > Indeed, thank you. I'd analysed this before but not made the connection
> > with Jeff's report.
> >
> > > So reverting 7d930bc33653d5592dc386a76a38f39c2e962344 is the correct
> > thing
> > > to do. Or somebody needs to fix that piece-of-shit code.
> >
> > Yes ... that params.bssid was != NULL was a bad assumption in that
> > commit. The right thing to do is to add a check and pass NULL through,
> > like I did here:
> > http://thread.gmane.org/gmane.linux.kernel.wireless.general/41695
> >
> 
> That patch fixes the WPA2 hanging the system problem for me.
> 
> Thanks for the quick responses!

I'll roll that up with a few other fixes and send it to Dave M. today.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
