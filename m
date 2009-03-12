Return-Path: <linux-kernel-owner+w=401wt.eu-S1756100AbZCLCpl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756100AbZCLCpl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 22:45:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754617AbZCLCp2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 22:45:28 -0400
Received: from n26.bullet.mail.mud.yahoo.com ([68.142.206.221]:21582 "HELO
	n26.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755118AbZCLCp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 22:45:26 -0400
X-Yahoo-Newman-Id: 644897.84017.bm@omp410.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=itcJ6zONsh4d3WABWYsWnq7NhAMuHHByttrVrxQoHDksxSEv8nhmuLUKirM6PsBxCGOnlx5lwYtkx6+3HNf4fd9QIR7eXmSVyQDKPLGvgswLan2L0/PVQWKfmsE/18jl+763m61zCr8MmiFp+97YKCDOxsrieZVxMbFFJmgHDZQ=  ;
X-YMail-OSG: P5ovCqAVM1naVWveYHjXj3746rOA2XfuJcNYnAVbZSy0Mfvex3Dqk3XJ7FUthbf.ZCCB4TOWedczJZufWq1CVO1BWBTLD3IMYIba1VBNGgO2Fj4mdby1V01GtyVwSSZimGzd3vlCi1JR5kwLUWSfE0_U
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Wolfgang =?iso-8859-1?q?M=FCes?= <wolfgang.mues@auerswald.de>
Subject: Re: [PATCH 6/7] mmc_spi: convert timeout handling to jiffies and avoid busy waiting
Date: Wed, 11 Mar 2009 18:45:22 -0800
User-Agent: KMail/1.9.10
Cc: Pierre Ossman <drzeus@drzeus.cx>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Matt Fleming" <matt@console-pimps.org>,
       "Mike Frysinger" <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
References: <200903111435.03196.wolfgang.mues@auerswald.de>
In-Reply-To: <200903111435.03196.wolfgang.mues@auerswald.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200903111945.22597.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 11 March 2009, Wolfgang Mües wrote:
> o SD/MMC card timeouts can be very high. So avoid busy-waiting,
>   using the scheduler. Calculate all timeouts in jiffies units,
>   because this will give us the correct sign when to involve
>   the scheduler.

Of these patches, this is the one that bothers me the most.

First, earlier versions used jiffies ... but switching to
ktime sped things up.  (I forget the details by now.)
So it's odd to think that switching again could improve
things.  At any rate, if that's worth doing it's worth
having as a separate patch.

Second, as someone previously pointed out, there's a comment
there about switching to sleep() calls ... did you explore
just kicking in schedule_hrtimeout() or somesuch, right at
that point?  Heck, just calling schedule() would cut the
busy-wait overhead...





