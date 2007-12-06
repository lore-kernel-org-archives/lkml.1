Return-Path: <linux-kernel-owner+w=401wt.eu-S1753285AbXLFOmq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285AbXLFOmq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 09:42:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751226AbXLFOmi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 09:42:38 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:49054 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351AbXLFOmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 09:42:38 -0500
Date: Thu, 6 Dec 2007 07:42:36 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Ingo Molnar <mingo@elte.hu>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH 2/5] Use macros instead of TASK_ flags
Message-ID: <20071206144236.GB15868@parisc-linux.org>
References: <11932286982175-git-send-email-matthew@wil.cx> <1193228698799-git-send-email-matthew@wil.cx> <20071205125622.GA21531@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071205125622.GA21531@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 05, 2007 at 01:56:22PM +0100, Ingo Molnar wrote:
> 1) please change 'is' and 'task' around so that it reads nicer:
> 
>    if (task_is_stopped(t))
> 
> instead of the tongue-twister:
> 
>    if (is_task_stopped(t))

Sure, no problem.  I vacillated on this order myself.

> 2) please change task_is_loadavg() to something more sensible - i didnt 
> know what it meant when i first saw it in -mm's sched.c. 
> task_is_uninterruptible() would be the logical choice ...

It's not obvious to me that "can't be interrupted by a signal" is the
same thing as "contributes to loadavg".  Indeed, I think we would all
like to see a day where there's no such thing as an uninterruptible sleep,
but we'll still want at least some of those tasks contributing to loadavg.

You're right that task_is_loadavg() doesn't make much sense.
task_contributes_to_load() is a better name, but only marginally.

I've considered task_performing_io(), and name the corresponding bit
__TASK_PERFORMING_IO (or even just __TASK_DOING_IO or __TASK_IO), but
it's not just doing IO that makes a task contribute to loadavg.

I have no good suggestions here ;-(

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
