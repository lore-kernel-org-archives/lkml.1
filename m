Return-Path: <linux-kernel-owner+w=401wt.eu-S1754201AbZFHToT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201AbZFHToT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 15:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752867AbZFHToM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 15:44:12 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50278 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752372AbZFHToL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 15:44:11 -0400
Message-ID: <4A2D6A8C.1030703@redhat.com>
Date: Mon, 08 Jun 2009 15:46:20 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: ananth@in.ibm.com, Vegard Nossum <vegard.nossum@gmail.com>
CC: linux-kernel@vger.kernel.org,
       Alexander van Heukelum <heukelum@fastmail.fm>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH] kmemcheck: move hook before preempt_conditional_sti()
References: <1244392012-638-1-git-send-email-vegard.nossum@gmail.com> <20090608064148.GA516@in.ibm.com>
In-Reply-To: <20090608064148.GA516@in.ibm.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ananth N Mavinakayanahalli wrote:
> On Sun, Jun 07, 2009 at 06:26:52PM +0200, Vegard Nossum wrote:
>> commit 787ecfaa503dc63ff1831ddc74b15dad49bace1d
>> Author: Vegard Nossum <vegard.nossum@gmail.com>
>> Date:   Fri Apr 4 00:53:23 2008 +0200
>>
>>     x86: add hooks for kmemcheck
>>
>> I encourage the kprobe developers to check whether their code is correct
>> as it stands in current tip/master. Also, comments on this particular
>> change is welcome.
> 
> I see no problem with this change wrt kprobes, since the changes happen
> after the notify_die, by which time, kprobes would've returned
> NOTIFY_DONE since the per-cpu current_kprobe == NULL.

BTW, what will happen if kmemchecked page is accessed from
kprobe's single-stepping instruction? :-)

If a pagefault occurs before (kprobe's)single-step is done,
may kmemcheck's single-step handler be ignored by kprobe's
single-step handler? If it's true, I think kmemcheck hook
should be done before notify_die. (and add __kprobes to some
kmemcheck functions)

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

