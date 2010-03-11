Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879Ab0CKJOO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 04:14:14 -0500
Received: from mail.windriver.com ([147.11.1.11]:49588 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545Ab0CKJOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 04:14:12 -0500
Date: Thu, 11 Mar 2010 17:13:39 +0800
From: Yong Zhang <yong.zhang@windriver.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Lars-Peter Clausen <lars@metafoo.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] IRQ: Fix oneshot irq race between
 irq_finalize_oneshot and handle_level_irq
Message-ID: <20100311091339.GD8389@windriver.com>
Reply-To: Yong Zhang <yong.zhang@windriver.com>
References: <1268092679-18070-1-git-send-email-lars@metafoo.de>
 <alpine.LFD.2.00.1003091959080.22855@localhost.localdomain>
 <20100310032102.GA2090@windriver.com>
 <alpine.LFD.2.00.1003100848380.22855@localhost.localdomain>
 <20100311025533.GB8389@windriver.com>
 <alpine.LFD.2.00.1003110927450.22855@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1003110927450.22855@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 11 Mar 2010 09:13:40.0856 (UTC) FILETIME=[241B1780:01CAC0FB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 11, 2010 at 09:41:45AM +0100, Thomas Gleixner wrote:
> No, it is _NOT_ harmless. interrupt handlers are guaranteed _NOT_ to
> be reentered. That's why we check the INPROGRESS flag. 
> 
> And you totally miss the case which caused the disussion in the first
> place: When the thread finishes _before_ the hard irq handler on the
> other CPU has set IRQ_MASKED. So this patch solves nothing at all, it
> just makes stuff worse than it was.
> 
> Here is the solution which solves the inconsistent lock state _AND_
> the reentrancy race.
> 
> http://git.kernel.org/?p=linux/kernel/git/tip/linux-2.6-tip.git;a=commit;h=0b1adaa031a55e44f5dd942f234bf09d28e8a0d6
> 
> The change log has a full explanation of the scenarios.

Yeah, I see. Thanks for your point.
It will smooth the concerns.

Thanks,
Yong
