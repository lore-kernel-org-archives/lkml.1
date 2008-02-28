Return-Path: <linux-kernel-owner+w=401wt.eu-S1758724AbYB1LmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758724AbYB1LmU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 06:42:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756040AbYB1LmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 06:42:09 -0500
Received: from styx.suse.cz ([82.119.242.94]:54588 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755541AbYB1LmI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 06:42:08 -0500
Date: Thu, 28 Feb 2008 12:42:07 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Roland McGrath <roland@redhat.com>
cc: Oleg Nesterov <oleg@tv-sign.ru>, Davide Libenzi <davidel@xmailserver.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFC] fix missed SIGCONT cases
In-Reply-To: <20080228102649.071572700FD@magilla.localdomain>
Message-ID: <Pine.LNX.4.64.0802281238550.3391@jikos.suse.cz>
References: <Pine.LNX.4.64.0802271610330.3391@jikos.suse.cz>
 <20080227210038.93AFC2700FD@magilla.localdomain> <Pine.LNX.4.64.0802272258150.3391@jikos.suse.cz>
 <20080228102649.071572700FD@magilla.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Feb 2008, Roland McGrath wrote:

> [PATCH] clean up and fix SIGCONT
> This reorganizes some of the signals code, replacing handle_stop_signal()
> with prepare_signal() and finish_signal(), called as a pair before and
> after generating any signal.  The CLD_CONTINUED notification to parent is
> moved into finish_signal(), taking place after the signal is made pending
> and siglock dropped.  This fixes a race where a process waking from SIGCONT
> could resume application code without running its SIGCONT handler first.

Hi Roland,

I haven't tested what is the behavior with my patch, or without any 
patches at all (will do), but with your patch applied, when I run the test 
program under strace, it resumes immediately ... doesn't look particularly 
OK to me:

$ strace -o /dev/null ./a.out | head -10
finished (without SIGCONT)
finished (without SIGCONT)
finished (without SIGCONT)
finished (without SIGCONT)
finished (without SIGCONT)
finished (without SIGCONT)
finished (without SIGCONT)
finished (without SIGCONT)
finished (without SIGCONT)
finished (without SIGCONT)

-- 
Jiri Kosina
SUSE Labs
