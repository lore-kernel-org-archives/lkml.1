Return-Path: <linux-kernel-owner+w=401wt.eu-S1754820AbZHMPjL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820AbZHMPjL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 11:39:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751660AbZHMPjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 11:39:10 -0400
Received: from cinke.fazekas.hu ([195.199.244.225]:51542 "EHLO
	cinke.fazekas.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569AbZHMPjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 11:39:10 -0400
Date: Thu, 13 Aug 2009 17:39:10 +0200 (CEST)
From: Marton Balint <cus@fazekas.hu>
To: Andreas Mohr <andi@lisas.de>
cc: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org
Subject: Re: CPU scheduler weirdness?
In-Reply-To: <20090813084257.GA761@rhlx01.hs-esslingen.de>
Message-ID: <alpine.LNX.2.00.0908131720050.8321@cinke.fazekas.hu>
References: <20090813084257.GA761@rhlx01.hs-esslingen.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Does anybody have any idea what can cause this?
>
> /sys/devices/system/cpu/sched_smt_power_savings , perhaps?

Thanks for the tip, tuning the sched_mc_power_savings setting helped! The 
original value of it was 0, but after setting it to 1, the two 
cpu-intensive processes got scheduled to different CPU cores, as expected.

Setting it back to 0 casused the two cpu-intensive processes to run on 
the same CPU again. So I guess I will just set it to 1 after booting the 
system.

But just out of curiousity, this strange behaviour of the scheduler 
without poking sched_mc_power_savings is a bug or a feature?

Regards,
   Marton
