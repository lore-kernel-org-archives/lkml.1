Return-Path: <linux-kernel-owner+w=401wt.eu-S1757573AbYARKH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757573AbYARKH1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 05:07:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754561AbYARKHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 05:07:21 -0500
Received: from www.tglx.de ([62.245.132.106]:41126 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753407AbYARKHU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 05:07:20 -0500
Date: Fri, 18 Jan 2008 11:06:48 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Balaji Rao <balajirrao@gmail.com>
cc: Jan Engelhardt <jengelh@computergmbh.de>,
       Daniel Walker <dwalker@mvista.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: setting jiffies as the clocksource stops time
In-Reply-To: <200801181141.55837.balajirrao@gmail.com>
Message-ID: <alpine.LFD.0.99999.0801181105390.4642@localhost.localdomain>
References: <200801170209.42138.balajirrao@gmail.com> <1200518450.18731.129.camel@imap.mvista.com> <Pine.LNX.4.64.0801172333130.18447@fbirervta.pbzchgretzou.qr> <200801181141.55837.balajirrao@gmail.com>
User-Agent: Alpine 0.99999 (LFD 796 2007-11-08)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jan 2008, Balaji Rao wrote:

> On Friday 18 January 2008 04:04:33 am Jan Engelhardt wrote:
> > 
> > On Jan 16 2008 13:20, Daniel Walker wrote:
> > >On Thu, 2008-01-17 at 02:09 +0530, Balaji Rao wrote:
> > >> Hi,
> > >> 
> > >> When i set jiffies as the current_clocksource, date(1) tells me
> > >> that wallclock time has stopped, and soon after that, the system
> > >> becomes unresponsive. This is not seen with CONFIG_NO_HZ disabled.
> > >> 
> > >> I wonder how can jiffies be used as a clocksource.. Its value
> > >> depends on the tick and when we turn off ticks, we would stop
> > >> incrementing jiffies and when we come come out of idle, we update
> > >> the jiffies by reading the current_clocksource which now is
> > >> 'jiffies', and hence jiffies wouldn't get updated. Could this be
> > >> the explanation ?
> > >
> > >Your right, It can't be used as a clocksource with nohz , and the system
> > >will refuse to automatically switch to it ..
> > 
> > I think that manually changing to jiffies by echoing into sysfs
> > should also be prohibited.
> > 
> Yea, right. But why not unregister jiffies as a clocksource itself when we get into NO_HZ ? I think it's much cleaner 
> provided it has no other consequences.

As I said before. I have a patch lined up for the same issue vs. PIT
clocksource and I'm adding that for jiffies as well. It's just not an
urgent issue, which needs to go into .24

Thanks

	tglx

