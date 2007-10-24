Return-Path: <linux-kernel-owner+w=401wt.eu-S1757048AbXJXGxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757048AbXJXGxQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 02:53:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754509AbXJXGxD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 02:53:03 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:36914 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755003AbXJXGxB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 02:53:01 -0400
Message-ID: <471EEBCB.30804@garzik.org>
Date: Wed, 24 Oct 2007 02:52:59 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org
Subject: Re: [PATCH 4/12] riscom8: fix SMP brokenness
References: <tueoct232007613pm.likjasfdlkjdas987@havoc.gtf.org> <20071023223638.DD9FE1F81A8@havoc.gtf.org> <471EEA7B.8070008@gmail.com>
In-Reply-To: <471EEA7B.8070008@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby wrote:
> On 10/24/2007 12:36 AM, Jeff Garzik wrote:
>> After analyzing the elements that save_flags/cli/sti/restore_flags were
>> protecting, convert their usages to a global spinlock (the easiest and
>> most obvious next-step).  There were some usages of flags being
>> intentionally cached, because the code already knew the state of
>> interrupts.  These have been taken into account.
>>
>> This allows us to remove CONFIG_BROKEN_ON_SMP.  Completely untested.
>>
>> Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
>> ---
>>
> [...]
>> diff --git a/drivers/char/riscom8.c b/drivers/char/riscom8.c
>> index b37e626..45d109c 100644
>> --- a/drivers/char/riscom8.c
>> +++ b/drivers/char/riscom8.c
> [...]
>> @@ -82,6 +83,8 @@
>>  static struct riscom_board * IRQ_to_board[16];
>>  static struct tty_driver *riscom_driver;
>>  
>> +static spinlock_t riscom_lock = SPIN_LOCK_UNLOCKED;
> 
> This is deprecated (see linux/spinlock_types.h for details), use DEFINE_SPINLOCK
> instead, otherwise seems OK.
> 
> Revieweved-by: Jiri Slaby <jirislaby@gmail.com>

I noticed you reviewed my other riscom8 patch... you don't have hardware 
perchance, do you?  :)

	Jeff



