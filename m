Return-Path: <linux-kernel-owner+w=401wt.eu-S1756713AbXENPz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756713AbXENPz1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 11:55:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753072AbXENPzR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 11:55:17 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49510 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752141AbXENPzQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 11:55:16 -0400
Message-ID: <4648865E.5030706@redhat.com>
Date: Mon, 14 May 2007 11:55:10 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Thunderbird 1.5.0.7 (X11/20061004)
MIME-Version: 1.0
To: linux@horizon.com
CC: learninglinux4@gmail.com, linux-kernel@vger.kernel.org,
       linux-newbie@vger.kernel.org
Subject: Re: Why can't we sleep in an ISR?
References: <20070514152218.19773.qmail@science.horizon.com>
In-Reply-To: <20070514152218.19773.qmail@science.horizon.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

linux@horizon.com wrote:
> Sleeping in an ISR is not fundamentally impossible - I could design
> a multitasker that permitted it - but has significant problems, and
> most multitaskers, including Linux, forbid it.

You could design a system in which most ISRs can sleep,
but even then you'll probably need to make exceptions.

For example, the timer interrupt tends to drive the
scheduler.  This means the timer interrupt cannot go
to sleep and expect the scheduler to wake it up at
some point in the future - since there will be no new
timer interrupts to drive the scheduler.

This precludes the timer interrupt from taking certain
sleeping locks, even on a system where interrupts can
sleep (not Linux).

Interrupts will always have some limitations, under
any OS design.

-- 
All Rights Reversed
