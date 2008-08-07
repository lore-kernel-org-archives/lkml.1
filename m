Return-Path: <linux-kernel-owner+w=401wt.eu-S1752744AbYHGRTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744AbYHGRTz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 13:19:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752030AbYHGRTq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 13:19:46 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:34641 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549AbYHGRTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 13:19:45 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <489B2EAE.8040901@s5r6.in-berlin.de>
Date: Thu, 07 Aug 2008 19:19:42 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.16) Gecko/20080722 SeaMonkey/1.1.11
MIME-Version: 1.0
To: jmerkey@wolfmountaingroup.com
CC: linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] mdb-2.6.27-rc2-ia32-08-07-08.patch
References: <1300.69.2.248.210.1218119365.squirrel@webmail.wolfmountaingroup.com>       <489B199B.40305@s5r6.in-berlin.de>       <489B1BDC.1010504@s5r6.in-berlin.de>    <1923.69.2.248.210.1218124570.squirrel@webmail.wolfmountaingroup.com>    <489B26F0.3030603@s5r6.in-berlin.de> <1905.69.2.248.210.1218126817.squirrel@webmail.wolfmountaingroup.com>
In-Reply-To: <1905.69.2.248.210.1218126817.squirrel@webmail.wolfmountaingroup.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jmerkey@wolfmountaingroup.com wrote:
>> jmerkey@wolfmountaingroup.com wrote:
>>> rspin locks are for these types of cases -- so if I fault on the same
>>> processor I took the lock on it just bumps a counter -- yes, it is
>>> atomic
>>> and SMP safe to do it this way.
>> Only if all contexts which take rlocks are not preemptible.
[...]
> check mdb-main.c -- I disable preemption before rspin_lock is attempted. 
> Since the only processor which sets the proc number does do inside the
> spin lock, and the other processors only read it, unless memory is
> corrupted or the machine is severely broken, its SMP safe to this.

Then it is recommendable that you document the call context requirements 
at the functions.  And you can and IMO should drop the _irq_save and 
_irq_restore from the spinlock accessors in the rlock accessors.  And 
drop the volatile qualifier of the rlock accessor argument while you are 
at it.

I see that you are calling save_flags/ restore_flags in 
mdb-main.c::mdb().  These are marked as deprecated.  Would 
local_irq_save/ local_irq_restore be correct at these places?
-- 
Stefan Richter
-=====-==--- =--- --===
http://arcgraph.de/sr/
