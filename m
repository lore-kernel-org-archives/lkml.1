Return-Path: <linux-kernel-owner+w=401wt.eu-S1754902AbYEKLBh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902AbYEKLBh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 07:01:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752563AbYEKLB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 07:01:27 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:22031 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752692AbYEKLB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 07:01:27 -0400
Date: Sun, 11 May 2008 13:01:24 +0200
From: Andi Kleen <andi@firstfloor.org>
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org
Subject: better msleep for drivers
Message-ID: <20080511110124.GA24187@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 11 May 2008 10:54:25.0856 (UTC) FILETIME=[60DA2400:01C8B355]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

Someone asked if there is a msleep using hrtimers that is more accurate
than jiffies/msecs for external drivers. There is hrtimer nanosleep,
but it is currently not exported. It can be reimplemented using hrtimer_start
etc. which are exported, but that seems rather clumpsy.

Is there any reason such an obvious function is not exported? 

Ok I guess right now nobody in tree is using it. But that seems wrong.  
Perhaps we should have a (exported) usleep_blocking() wrapper or somesuch for 
that case?  

I suspect that a lot of drivers could make use of it. Just from grepping we 
have a lot of msleep(1)s in drivers and I suspect a lot of those would 
actually like to delay shorter than one jiffie. 

One argument against it would be that it makes them more difficult to test 
because behavior will differ between hrtimer enabled and disabled systems. 
Still longer term I suppose there's really no way around having accurate
sleep functions and it's probably better to start testing earlier than later.

Thoughts?

-Andi
