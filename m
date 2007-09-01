Return-Path: <linux-kernel-owner+w=401wt.eu-S1757851AbXIABxh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757851AbXIABxh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 21:53:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753362AbXIABqL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 21:46:11 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:52877 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754095AbXIABqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 21:46:09 -0400
Subject: Re: nmi_watchdog=2 regression in 2.6.21
From: Daniel Walker <dwalker@mvista.com>
To: =?ISO-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
Cc: eranian@hpl.hp.com, ak@suse.de, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <20070901010053.GA29765@atjola.homenet>
References: <20070828194636.GB2814@frankl.hpl.hp.com>
	 <1188332024.2435.328.camel@dhcp193.mvista.com>
	 <20070829212451.GC4810@frankl.hpl.hp.com>
	 <1188436919.26038.27.camel@dhcp193.mvista.com>
	 <20070830210555.GA6635@frankl.hpl.hp.com>
	 <1188571401.26038.41.camel@dhcp193.mvista.com>
	 <20070831162146.GD7161@frankl.hpl.hp.com>
	 <1188578123.26038.52.camel@dhcp193.mvista.com>
	 <20070831180644.GA24174@atjola.homenet>
	 <1188606286.26038.117.camel@dhcp193.mvista.com>
	 <20070901010053.GA29765@atjola.homenet>
Content-Type: text/plain; charset=utf-8
Date: Fri, 31 Aug 2007 18:36:07 -0700
Message-Id: <1188610568.9476.7.camel@dhcp193.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-09-01 at 03:00 +0200, Björn Steinbrink wrote:
> On 2007.08.31 17:24:46 -0700, Daniel Walker wrote:
> > On Fri, 2007-08-31 at 20:06 +0200, Björn Steinbrink wrote:
> > 
> > 
> > > > something to do with the nmi hertz adjustment that happens after
> > > > check_nmi_watchdog() ..
> > > 
> > > Hm hm, does the same thing (watchdog stuck after check) happen with
> > > older kernels, ie. those before Stephane's changeset that made it use
> > > PERFCTR1?
> > 
> > I noticed the frequency gets turned down after check_nmi_watchdog() is
> > called.. I think it's suppose to trigger once per second, but it's more
> > like it updates randomly ..
> 
> It's once per second if the cpu is 100% busy, if it's just idling and
> halted, the performance counters won't be increased.

Didn't know that .. I ran hackbench while watching /proc/interrupts ,
and it ticks along ok on some cores .. 

The acid test was running an application that hangs the system, and it
caught it (although the system didn't recover from the lockup..) ..

> > In older kernels it's very slow, but it's more consistent ..
> 
> With the same load on the box? Maybe some other changes caused the box
> to behave differently (say, CFS), regarding eg. load distribution
> amongst the cores.

It must not have been the same load considering everything else.

I'm satisfied that Stephane's last patch fixes it ..

Daniel

