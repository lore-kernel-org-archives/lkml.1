Return-Path: <linux-kernel-owner+w=401wt.eu-S1755246AbYHGSNv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246AbYHGSNv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 14:13:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752538AbYHGSNn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 14:13:43 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:59335 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752237AbYHGSNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 14:13:42 -0400
Message-ID: <17159.166.70.238.44.1218131541.squirrel@webmail.wolfmountaingroup.com>
In-Reply-To: <489B2EAE.8040901@s5r6.in-berlin.de>
References: <1300.69.2.248.210.1218119365.squirrel@webmail.wolfmountaingroup.com>  
        <489B199B.40305@s5r6.in-berlin.de>      
    <489B1BDC.1010504@s5r6.in-berlin.de>   
    <1923.69.2.248.210.1218124570.squirrel@webmail.wolfmountaingroup.com>  
     <489B26F0.3030603@s5r6.in-berlin.de>
    <1905.69.2.248.210.1218126817.squirrel@webmail.wolfmountaingroup.com>
    <489B2EAE.8040901@s5r6.in-berlin.de>
Date: Thu, 7 Aug 2008 11:52:21 -0600 (MDT)
Subject: Re: [ANNOUNCE] mdb-2.6.27-rc2-ia32-08-07-08.patch
From: jmerkey@wolfmountaingroup.com
To: "Stefan Richter" <stefanr@s5r6.in-berlin.de>
Cc: jmerkey@wolfmountaingroup.com, linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> jmerkey@wolfmountaingroup.com wrote:
>>> jmerkey@wolfmountaingroup.com wrote:
>>>> rspin locks are for these types of cases -- so if I fault on the same
>>>> processor I took the lock on it just bumps a counter -- yes, it is
>>>> atomic
>>>> and SMP safe to do it this way.
>>> Only if all contexts which take rlocks are not preemptible.
> [...]
>> check mdb-main.c -- I disable preemption before rspin_lock is attempted.
>> Since the only processor which sets the proc number does do inside the
>> spin lock, and the other processors only read it, unless memory is
>> corrupted or the machine is severely broken, its SMP safe to this.
>
> Then it is recommendable that you document the call context requirements
> at the functions.  And you can and IMO should drop the _irq_save and
> _irq_restore from the spinlock accessors in the rlock accessors.  And
> drop the volatile qualifier of the rlock accessor argument while you are
> at it.
>
> I see that you are calling save_flags/ restore_flags in
> mdb-main.c::mdb().  These are marked as deprecated.  Would
> local_irq_save/ local_irq_restore be correct at these places?


You have sharp eyes.  Yes, you are correct.  added to the list of
corrections.

Jeff

> --
> Stefan Richter
> -=====-==--- =--- --===
> http://arcgraph.de/sr/
>


