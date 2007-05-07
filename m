Return-Path: <linux-kernel-owner+w=401wt.eu-S966520AbXEGVTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966520AbXEGVTS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 17:19:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755039AbXEGVTR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 17:19:17 -0400
Received: from z2.cat.iki.fi ([212.16.98.133]:35350 "EHLO z2.cat.iki.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754981AbXEGVTQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 17:19:16 -0400
Date: Tue, 8 May 2007 00:19:15 +0300
From: Matti Aarnio <matti.aarnio@zmailer.org>
To: linux-kernel@vger.kernel.org
Subject: Re: gmail is a bit too popular..
Message-ID: <20070507211915.GI3883@mea-ext.zmailer.org>
References: <20070507145555.GG3883@mea-ext.zmailer.org> <20070507201821.GG943@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070507201821.GG943@1wt.eu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 07, 2007 at 10:18:21PM +0200, Willy Tarreau wrote:
> On Mon, May 07, 2007 at 05:55:55PM +0300, Matti Aarnio wrote:
...
> > The  gmail  is so popular, that with their somewhat rudimentary 
> > inbound MTA software this kind of recipient masses take horrible
> > time to feed in...  Mere 0.5-0.7 seconds per recipient, but..
> > 
> > So far we have tried to feed all recipients in one go per
> > message - that is sending 2100  RCPT TO -lines in one swoop,
> > and the system has taken some 15-25 minutes per message to
> > feed it to gmail.  We are running the delivery 20 streams in
> > parallel, so it isn't quite as bad as it sounds..
> > 
> 
> I suspect they behave like that on purpose to fight spam.

No.  VGER is on the extreme outer edge of things, only very few
legitimate systems have a need to send this much recipients for
each and every message.  Some small list with perhaps 10 subscribers
at gmail notice nothing.  Not even with 100 subscribers, but soon
after that the sending list sysadmin may notice something...

Comparing with spammers - message content analysis (ever so difficult
thing anyway) is _easier_ per recipient when we are sending 100
recipients for each DATA-dot body.  It is 1/100:th cost per recipient
compared to "send one RCPT for each body".  We could send all 2100
recipients if systems could negotiate such raised limit (there is
no standardized way, just one private ad-hoc,) and do the recipient
acceptance analysis fast enough so that PIPELINING-mode would really
gain benefits.

> If they implemented pipelining, it wouldn't help them.

It would not hurt them either.  Just help us very few who
are at this extreme outer edge of things..

Lightspeed delay (ping) is about 160 ms, so there is still some
300-600 ms that the gmail system is munching somewhere per recipient..

Anyway, VGER is now tuned so that the delivery delay stays usually
under about 1 hour per message to gmail.

....
> Willy

  /Matti Aarnio
