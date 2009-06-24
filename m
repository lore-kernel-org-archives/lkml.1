Return-Path: <linux-kernel-owner+w=401wt.eu-S1755568AbZFXHQB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568AbZFXHQB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 03:16:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751737AbZFXHPy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 03:15:54 -0400
Received: from one.firstfloor.org ([213.235.205.2]:60938 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633AbZFXHPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 03:15:53 -0400
Date: Wed, 24 Jun 2009 09:15:55 +0200
From: Andi Kleen <andi@firstfloor.org>
To: David Miller <davem@davemloft.net>
Cc: andi@firstfloor.org, linux-kernel@vger.kernel.org,
       sparclinux@vger.kernel.org
Subject: Re: NMI watchdog + NOHZ question
Message-ID: <20090624071555.GK6760@one.firstfloor.org>
References: <20090622.022752.219499742.davem@davemloft.net> <20090623.171735.154729801.davem@davemloft.net> <20090624070315.GH6760@one.firstfloor.org> <20090624.000811.118222188.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090624.000811.118222188.davem@davemloft.net>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 24, 2009 at 12:08:11AM -0700, David Miller wrote:
> From: Andi Kleen <andi@firstfloor.org>
> Date: Wed, 24 Jun 2009 09:03:15 +0200
> 
> >> I'm not exactly sure what to do about this.
> > 
> > Ack the timer interrupt earlier (and also give it a high priority?)
> 
> It has a higher priority, but all interrupts get re-enabled right
> before we process software interrupts.  So the flood of qla2xxx
> interrupts can come in before we can run the timer softirq and
> thus schedule the next timer interrupt.

Ah you have a one shot timer and it gets rescheduled in the softirq?
If yes why not in doing that directly in the hardirq handler?

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
