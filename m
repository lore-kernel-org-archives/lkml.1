Return-Path: <linux-kernel-owner+w=401wt.eu-S1755932AbZGUTVQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755932AbZGUTVQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 15:21:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755912AbZGUTVN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 15:21:13 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:35305 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755100AbZGUTVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 15:21:08 -0400
Message-Id: <20090721191745.788551122@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Tue, 21 Jul 2009 21:17:45 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       john stultz <johnstul@us.ibm.com>
Subject: [RFC][patch 0/5] clocksource cleanup / improvement
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,
I had a go at the clocksource code and tried to make it better. The
first 4 patches contain some code cleanup and improve the separation
between timekeeping.c and clocksource.[ch].
Patch #5 is the one with the real change: the switch to a new clock
source is now done with stop_machine instead of checking with every
wall time update. A clocksource change is an extremely rare thing,
to use stop_machine seems reasonable to me.

What I'd like to do is to make the content of struct clocksource
private to clocksource.c and clocksource.h. The biggest road-block
to get there is update_wall_time. I stared at it for hours and then
gave up. A bit of unfinished business ..

The clocksource patches have been created against todays upstream
tree plus the patches from the tip tree, if anyone wants to try them
you need to pull from:
    git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-tip

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

