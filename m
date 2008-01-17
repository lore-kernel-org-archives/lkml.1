Return-Path: <linux-kernel-owner+w=401wt.eu-S1759409AbYAQWen@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759409AbYAQWen (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 17:34:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752088AbYAQWef
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 17:34:35 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:50670 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993AbYAQWee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 17:34:34 -0500
Date: Thu, 17 Jan 2008 23:34:33 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Daniel Walker <dwalker@mvista.com>
cc: Balaji Rao <balajirrao@gmail.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: setting jiffies as the clocksource stops time
In-Reply-To: <1200518450.18731.129.camel@imap.mvista.com>
Message-ID: <Pine.LNX.4.64.0801172333130.18447@fbirervta.pbzchgretzou.qr>
References: <200801170209.42138.balajirrao@gmail.com>
 <1200518450.18731.129.camel@imap.mvista.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 16 2008 13:20, Daniel Walker wrote:
>On Thu, 2008-01-17 at 02:09 +0530, Balaji Rao wrote:
>> Hi,
>> 
>> When i set jiffies as the current_clocksource, date(1) tells me
>> that wallclock time has stopped, and soon after that, the system
>> becomes unresponsive. This is not seen with CONFIG_NO_HZ disabled.
>> 
>> I wonder how can jiffies be used as a clocksource.. Its value
>> depends on the tick and when we turn off ticks, we would stop
>> incrementing jiffies and when we come come out of idle, we update
>> the jiffies by reading the current_clocksource which now is
>> 'jiffies', and hence jiffies wouldn't get updated. Could this be
>> the explanation ?
>
>Your right, It can't be used as a clocksource with nohz , and the system
>will refuse to automatically switch to it ..

I think that manually changing to jiffies by echoing into sysfs
should also be prohibited.
