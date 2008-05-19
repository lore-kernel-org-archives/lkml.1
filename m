Return-Path: <linux-kernel-owner+w=401wt.eu-S1761666AbYEST7h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761666AbYEST7h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 15:59:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758673AbYEST70
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 15:59:26 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:2465 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756717AbYEST7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 15:59:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=nEHvlHmzgZLgOi8lj6jvpgdesTpbPfH8DjrLWQ+5Lq6auMI2b0haW0avAUKsE7JxS7muwYqSMFci2L/93SPt3wnQjWY9daSULViIdQWkcsSoPmM5YdPAdjwFOrPfMrsciv637vA5IrMRqblhVVbY4a6wIVv1doMb4OXBbapheO0=
Message-ID: <4831DBDC.8000008@gmail.com>
Date: Mon, 19 May 2008 15:58:20 -0400
From: Gregory Haskins <gregory.haskins.ml@gmail.com>
Reply-To: gregory.haskins@gmail.com
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Rune Torgersen <runet@innovsys.com>
CC: Scott Wood <scottwood@freescale.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, linux-ide@vger.kernel.org,
       linux-rt-users@vger.kernel.org
Subject: Re: Oops with PREEMPT-RT on 2.6.25.4
References: <DCEAAC0833DD314AB0B58112AD99B93B0469010C@ismail.innsys.innovsys.com> <4831D527.2020907@freescale.com> <DCEAAC0833DD314AB0B58112AD99B93B04690162@ismail.innsys.innovsys.com>
In-Reply-To: <DCEAAC0833DD314AB0B58112AD99B93B04690162@ismail.innsys.innovsys.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rune Torgersen wrote:
> Scott Wood wrote:
>
>> You're recursively entering lock_timer_base, which does a
>> spin_lock_irqsave().  Either interrupts are enabled when they should
>> not be, or an interrupt was supposed to be threaded that isn't.
> 
> Sort of figured. How do I figure out which one, and how to fix it?
> I've never gotten any -rt patchsets to work on this CPU, and it always
> seems to be related to the disk driver.
> I've tried since 2.6.16 ppc.... (2.6.16, 2.6.18 on ppc, 2.6.24 and 25 on
> powerpc)
> 
> Even though this is a custom board, I'm pretty sure I can get it to fail
> on a pq2fads board with the same disk controller.

Im not sure if LOCKDEP is available for that architecture.  Have you 
tried it?  Its pretty good at flushing these kinds of issues out 
(assuming its available).

-Greg
