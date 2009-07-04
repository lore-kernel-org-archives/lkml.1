Return-Path: <linux-kernel-owner+w=401wt.eu-S1758605AbZGDBz7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758605AbZGDBz7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 21:55:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754836AbZGDBzs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 21:55:48 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37870
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754553AbZGDBzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 21:55:47 -0400
Date: Fri, 03 Jul 2009 18:55:53 -0700 (PDT)
Message-Id: <20090703.185553.218218176.davem@davemloft.net>
To: jarkao2@gmail.com
Cc: andres@anarazel.de, arun@linux.vnet.ibm.com, tglx@linutronix.de,
       shemminger@vyatta.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Soft-Lockup/Race in networking in 2.6.31-rc1+195 (
 possibly?caused by netem)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090703225640.GA3639@ami.dom.local>
References: <20090703120301.GD4847@ff.dom.local>
	<20090703.132220.57384838.davem@davemloft.net>
	<20090703225640.GA3639@ami.dom.local>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jarek Poplawski <jarkao2@gmail.com>
Date: Sat, 4 Jul 2009 00:56:40 +0200

> On Fri, Jul 03, 2009 at 01:22:20PM -0700, David Miller wrote:
>> Well, if you look at that commit the bisect pointed to Jarek, it is a
>> change which starts causing a situation which never happened before.
>> Namely, timers added on one cpu can be migrated and fire on another.
>> 
>> So this could be exposing races in the networking that technically
>> always existed.
> 
> I'm not sure I get your point; could you give some example?
> Actually, I've suspected races in timers code.

Let's say that a particular networking timer always gets
re-added on the cpu where the timer fires.

In that case, beforehand, no inter-cpu races could possibly
be tested.  But with the new timer code, such races could
now be potentially triggered.
