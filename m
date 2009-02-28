Return-Path: <linux-kernel-owner+w=401wt.eu-S1755451AbZB1UeH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451AbZB1UeH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 15:34:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753345AbZB1Udz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 15:33:55 -0500
Received: from n10.bullet.mail.mud.yahoo.com ([209.191.125.208]:39282 "HELO
	n10.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753339AbZB1Udy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 15:33:54 -0500
X-Greylist: delayed 160244 seconds by postgrey-1.27 at vger.kernel.org; Sat, 28 Feb 2009 15:33:54 EST
X-Yahoo-Newman-Id: 439452.66875.bm@omp406.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=i+7KQi4Cy14qGLD4Mk/G7UHLYKSuSFah4fuuJkV3Q7/qjkC1UmYPptxuTW4VtIl3PfX8xW2poBGhDJhFcc8s9JKASnx31PIXNkcG+//ckEnuqrir3kWywiyws7OWUMoPQiJbywSK6u2zBdxkdDQzecg2xJhebSy6tTzKH+DUTMg=  ;
X-YMail-OSG: 0YEsIkoVM1lp0IPIrR7NcP_8.BkAqqTwgiKC5wUGcoeOr27FMqvtr0mPCBH9qgb4.nd5LDaFN1OhDM.e6qxOyWIFDCVwviYplKpPtMUbPw5Bk7JQ8uDsW7XZMxqJmRmvW7_60am9O_6aMh7uUo2l2xsF
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Balaji Rao <balajirrao@openmoko.org>
Subject: Re: [PATCH 0/2] spi: Add support for non-blocking synchronous transfers
Date: Sat, 28 Feb 2009 12:33:50 -0800
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
       Andy Green <andy@openmoko.com>
References: <20090228081036.31964.80618.stgit@fedora.yogi>
In-Reply-To: <20090228081036.31964.80618.stgit@fedora.yogi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902281233.50612.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Note that $SUBJECT concept is nonsense.
Synchronous calls are by definition blocking ones...


On Saturday 28 February 2009, Balaji Rao wrote:
> During the course of development of an accelerometer driver, we saw the
> necessity to execute spi transfers synchronously within an interrupt handler.

This sounds like a bad design.  How can you know that no other
transfers are going on ... or are queued in front of the transfer
you're requesting?

You'd need to wait for all the other transfers to work their
way through the transfer queue.  There are *much* better things
to do in interrupt handlers.


> When using a workqueue instead, we observed a huge number of overruns
> with very high cpu utlization, which is unacceptable.

Sure, but at least part of that seems to be caused by some
broken design assumptions.

Why are you even trying to touch SPI devices from hardirq
context?  That's never going to be OK; "can't-sleep" contexts
don't mix with "must-sleep" calls.


> This series adds a new interface for this and modifies no existing ones.

NAK on these two patches.

