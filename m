Return-Path: <linux-kernel-owner+w=401wt.eu-S934801AbXLQDAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934801AbXLQDAq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 22:00:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764266AbXLQDAh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 22:00:37 -0500
Received: from py-out-1112.google.com ([64.233.166.179]:31447 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785AbXLQDAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 22:00:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:reply-to:to:subject:message-id:mime-version:content-type;
        b=iWwE8oS7gyJU63JVLJhZ8SdgDH4QMTcvII6DF7TNhU2OSNWHgIxUdLVS5pFOqKx7l0PcbbO+j/ldjvotdIIQYoHORqqqPzESvIkQWLgym+mYbnZDph/qfWuKOlWYd6/FovceFm4vBUfrfEdblJ3H08fEoP0jf50FqYcaURb/6JI=
Date: Sun, 16 Dec 2007 22:00:23 -0500 (EST)
From: Parag Warudkar <parag.warudkar@gmail.com>
X-X-Sender: parag@mini.warudkars.net
Reply-To: parag.warudkar@gmail.com
To: linux-kernel@vger.kernel.org
Subject: init_timer_deferrable conversion
Message-ID: <Pine.LNX.4.64.0712162149220.4622@mini.warudkars.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In my quest to get the wake-ups from idle per second down to bare minimum, 
I noticed 3 places in the kernel that could benefit from 
using init_timer_deferrable() instead of init_timer() -

a) drivers/net/sky2.c - watchdog_timer. This was showing up high on 
Powertop's list of things that cause routine wakeups from idle. After 
converting to init_timer_deferrable() the wakeups went down and this one 
no longer shows up in powertop's list. 25% reduction.

b) kernel/time/clocksource.c - watchdog_timer - same story as sky2.c

c) net/core/neighbour.c - gc_timer - Most benefit from deferrable timer.

I am running a kernel with above changes and haven't noticed any immediate 
problems and the wakeups-from-idle have gone down from 5-7 to mere 1-2 per 
second.

Is there any reason not to make the above timers deferrable - corner 
cases, other side effects? If not then I will submit a patch.

Thanks

Parag
