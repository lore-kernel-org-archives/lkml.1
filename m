Return-Path: <linux-kernel-owner+w=401wt.eu-S1753990AbZFXHRd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990AbZFXHRd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 03:17:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752175AbZFXHRZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 03:17:25 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47267
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751737AbZFXHRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 03:17:25 -0400
Date: Wed, 24 Jun 2009 00:17:29 -0700 (PDT)
Message-Id: <20090624.001729.155964457.davem@davemloft.net>
To: andi@firstfloor.org
Cc: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: NMI watchdog + NOHZ question
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090624071555.GK6760@one.firstfloor.org>
References: <20090624070315.GH6760@one.firstfloor.org>
	<20090624.000811.118222188.davem@davemloft.net>
	<20090624071555.GK6760@one.firstfloor.org>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <andi@firstfloor.org>
Date: Wed, 24 Jun 2009 09:15:55 +0200

> On Wed, Jun 24, 2009 at 12:08:11AM -0700, David Miller wrote:
>> From: Andi Kleen <andi@firstfloor.org>
>> Date: Wed, 24 Jun 2009 09:03:15 +0200
>> 
>> >> I'm not exactly sure what to do about this.
>> > 
>> > Ack the timer interrupt earlier (and also give it a high priority?)
>> 
>> It has a higher priority, but all interrupts get re-enabled right
>> before we process software interrupts.  So the flood of qla2xxx
>> interrupts can come in before we can run the timer softirq and
>> thus schedule the next timer interrupt.
> 
> Ah you have a one shot timer and it gets rescheduled in the softirq?
> If yes why not in doing that directly in the hardirq handler?

Then what's the point of the generic timer code supporting one-shot
clock sources? :-)
