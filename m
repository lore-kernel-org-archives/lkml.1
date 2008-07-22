Return-Path: <linux-kernel-owner+w=401wt.eu-S1755756AbYGVL1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755756AbYGVL1X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 07:27:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751994AbYGVL1P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 07:27:15 -0400
Received: from ik-out-1112.google.com ([66.249.90.177]:47946 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865AbYGVL1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 07:27:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=WlLQl2vqG3OhJGeUNW47HtxX9nb/qeTy+qZB7iJXs7FlPIWXvnIGcDeAxMcQhnchIr
         8dmLoEl4OO748AMn4hG7pnaovfV6bpb43oAOP5OFE3SWWgzRQdTQYHTQ0SMksnR/AoF+
         W6zV8wz03oqb42q8HU16EgmzZyGiNdSffe114=
Date: Tue, 22 Jul 2008 12:25:35 +0100
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Eric Sesterhenn <snakebyte@gmx.de>, xiyou.wangcong@gmail.com,
       linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net, jdike@addtoit.com
Subject: Re: [Patch] um: fix a build error
Message-ID: <20080722112535.GC3081@hack.voiplan.pt>
References: <20080722105812.GB5283@alice> <20080722115354.79ba2314@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080722115354.79ba2314@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2008 at 11:53:54AM +0100, Alan Cox wrote:
>> Signed-off-by: Eric Sesterhenn <snakebyte@gmx.de>
>> 
>> --- linux-2.6/arch/um/drivers/line.c.orig	2008-07-22 12:06:17.000000000 +0200
>> +++ linux-2.6/arch/um/drivers/line.c	2008-07-22 12:06:49.000000000 +0200
>> @@ -362,10 +362,8 @@ static irqreturn_t line_write_interrupt(
>>  	if (tty == NULL)
>>  		return IRQ_NONE;
>>  
>> -	if (test_bit(TTY_DO_WRITE_WAKEUP, &tty->flags) &&
>> -	   (tty->ldisc.write_wakeup != NULL))
>> -		(tty->ldisc.write_wakeup)(tty);
>> -
>> +	if (test_bit(TTY_DO_WRITE_WAKEUP, &tty->flags))
>> +		tty_wakeup(tty);
>
>Sorry I should have been clearer - you don't want the test_bit either.
>

Sure, tty_wakeup() already does that test.

And, tty_wakeup() also does wake_up_interruptible(), so I think
the wake_up_interruptible() below can also be removed, probably.

Thanks.

-- 
The opposite of love is not hate, but indifference.
	--Elie Wiesel
