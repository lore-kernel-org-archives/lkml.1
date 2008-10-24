Return-Path: <linux-kernel-owner+w=401wt.eu-S1758243AbYJXSMt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758243AbYJXSMt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 14:12:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758050AbYJXSMi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 14:12:38 -0400
Received: from one.firstfloor.org ([213.235.205.2]:35650 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758007AbYJXSMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 14:12:37 -0400
To: Mike Travis <travis@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>, Pavel Machek <pavel@suse.cz>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Jack Steiner <steiner@sgi.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Richard Purdie <rpurdie@rpsys.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] SGI X86 UV: Provide a System Activity Indicator	driver
From: Andi Kleen <andi@firstfloor.org>
References: <4901AF28.4070606@sgi.com> <20081024120103.GD1680@elf.ucw.cz>
	<20081024120544.GA9812@elte.hu> <4901BF30.3090708@sgi.com>
Date: Fri, 24 Oct 2008 20:12:38 +0200
In-Reply-To: <4901BF30.3090708@sgi.com> (Mike Travis's message of "Fri, 24 Oct 2008 05:27:28 -0700")
Message-ID: <87mygt9815.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Travis <travis@sgi.com> writes:
>
> I do use the timer mechanism (once per second) to update the scir state.
> Unfortunately, the state is *always* not idle during the timer callback
> (since we are actively executing), so I needed some way of knowing the
> idle state prior to the timer callback.

The idle thread always has pid 0. So if the timer sees current->pid == 0
it interrupted idle.

But sampling only once a second would be presumably not very accurate.
You could just check the per cpu statistics the kernel keeps
anyways in the timer.

I agree with Ingo that this doesn't belong in a idle notifier.

-Andi
-- 
ak@linux.intel.com
