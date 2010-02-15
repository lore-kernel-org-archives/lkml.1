Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756514Ab0BOU2H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 15:28:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45729 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756485Ab0BOU2D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 15:28:03 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Mike Frysinger <vapier@gentoo.org>
X-Fcc: ~/Mail/linus
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tracehook: add some self tests
In-Reply-To: Mike Frysinger's message of  Monday, 15 February 2010 01:15:53 -0500 <1266214553-29476-1-git-send-email-vapier@gentoo.org>
References: <1266214553-29476-1-git-send-email-vapier@gentoo.org>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20100215202800.5192E1AD@magilla.sf.frob.com>
Date: Mon, 15 Feb 2010 12:28:00 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is something of a misnomer, since asm/syscall.h is the only thing you
are testing.  

As Oleg pointed out, not all arch definitions can be used without a proper
task_struct argument.  Only ia64 actually needs the task as part of the
actual register access.  But several others (including x86) look at the
task to decide whether to use the 32-bit or 64-bit interpretation of the
register values.

I'd make the more general point that this sort of "synthetic" test does not
seem very useful.  At best, it can test the asm/syscall.h code for being
internally consistent--but that doesn't test whether it's really correct.
IMHO this is not worth having unless it's an "empirical" test.  What I mean
by that is one that really uses the asm/syscall.h calls as specified, and
in the context specified.  So, you'd have to fork a user process and use
ptrace on it to get it stopped at a syscall entry.  Then you can fetch the
arguments, modify them, and look at the arguments it actually passes in to
the syscall.


Thanks,
Roland
