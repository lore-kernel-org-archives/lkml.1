Return-Path: <linux-kernel-owner+w=401wt.eu-S1752092AbYAPVYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752092AbYAPVYc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 16:24:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751894AbYAPVXw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 16:23:52 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:13802 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785AbYAPVXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 16:23:51 -0500
Subject: Re: setting jiffies as the clocksource stops time
From: Daniel Walker <dwalker@mvista.com>
To: Balaji Rao <balajirrao@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <200801170209.42138.balajirrao@gmail.com>
References: <200801170209.42138.balajirrao@gmail.com>
Content-Type: text/plain
Date: Wed, 16 Jan 2008 13:20:50 -0800
Message-Id: <1200518450.18731.129.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-01-17 at 02:09 +0530, Balaji Rao wrote:
> Hi,
> 
> When i set jiffies as the current_clocksource, date(1) tells me that wallclock time has stopped, and soon after that, the 
> system becomes unresponsive. This is not seen with CONFIG_NO_HZ disabled.
> 
> This happens in 2.6.24-rc4,rc5, and even in rc8.
> 
> I wonder how can jiffies be used as a clocksource.. Its value depends on the tick and when we turn off ticks, we would stop 
> incrementing jiffies and when we come come out of idle, we update the jiffies by reading the current_clocksource which now 
> is 'jiffies', and hence jiffies wouldn't get updated. Could this be the explanation ?

Your right, It can't be used as a clocksource with nohz , and the system
will refuse to automatically switch to it ..

However, you can manually override the system, which is what your
doing .. That in turn forces the usage of an unstable clock which causes
your time and system not to function any more..

Daniel

