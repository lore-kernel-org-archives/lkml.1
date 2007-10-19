Return-Path: <linux-kernel-owner+w=401wt.eu-S1764599AbXJSQ3P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764599AbXJSQ3P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 12:29:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763566AbXJSQ27
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 12:28:59 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:55747 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755846AbXJSQ26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 12:28:58 -0400
Date: Fri, 19 Oct 2007 10:28:57 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH 1/5] Use wake_up_locked() in eventpoll
Message-ID: <20071019162856.GA30807@parisc-linux.org>
References: <11927463623428-git-send-email-matthew@wil.cx> <11927463621072-git-send-email-matthew@wil.cx> <20071018205623.717ef237@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071018205623.717ef237@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2007 at 08:56:23PM -0700, Arjan van de Ven wrote:
> Have you tested this patch with LOCKDEP enabled? eventpoll is... tricky
> in what it does with waitqueues and locks.... and some of this stuff is
> there, afaik, to deal with that. You're now changing this ... call me
> chicken :)

I haven't tested it, but it's a simple textual substitution:

#define wake_up_locked(x)               __wake_up_locked((x),
TASK_UNINTERRUPTIBLE | TASK_INTERRUPTIBLE)

so it should be identical in effect.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
