Return-Path: <linux-kernel-owner+w=401wt.eu-S1751486AbXB0EZA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751486AbXB0EZA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 23:25:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751487AbXB0EZA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 23:25:00 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:10120 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486AbXB0EY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 23:24:59 -0500
Subject: Re: [RFC] Fast assurate clock readable from user space and NMI
	handler
From: Daniel Walker <dwalker@mvista.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: mbligh@google.com, linux-kernel@vger.kernel.org, johnstul@us.ibm.com,
       mingo@elte.hu
In-Reply-To: <20070227035456.GA15444@Krystal>
References: <20061126170542.GA30771@Krystal>
	 <1164561427.16871.14.camel@localhost.localdomain>
	 <20061126231833.GA22241@Krystal>
	 <1164585589.16871.52.camel@localhost.localdomain>
	 <20070224161906.GA9497@Krystal> <1172340369.24216.31.camel@imap.mvista.com>
	 <20070226205304.GA30800@Krystal> <1172525261.5517.69.camel@imap.mvista.com>
	 <20070226221423.GA2286@Krystal> <1172531521.5517.138.camel@imap.mvista.com>
	 <20070227035456.GA15444@Krystal>
Content-Type: text/plain
Date: Mon, 26 Feb 2007 20:22:41 -0800
Message-Id: <1172550161.5517.210.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-02-26 at 22:54 -0500, Mathieu Desnoyers wrote:
> If an NMI nests over the spinlock, we have a deadlock.

Maybe not completely safe ...

> In addition, clock->cycle_last is a cycle_t, defined as a 64 bits on
> x86. If is therefore not updated atomically by change_clocksource,
> timekeeping_init, timekeeping_resume and update_wall_time. If an NMI
> fires right on top of the update, especially around the 32 bits wrap
> around, the time will be really fuzzy.

I'm not sure that is particularly significant considering that it's just
a possible bad timestamp, and the probability of that happening seems
rather low .. You could also modify NMI calls so they use a different
time stamping method, like reading the clocksource directly .

The pit clocksource could be dropped pretty easy with my clocksource
update patches, which I'm still working on but you could easily drop
clock sources that aren't atomic like the pit .. Also the pit is
generally undesirable, so it's not going to be missed.

Daniel

