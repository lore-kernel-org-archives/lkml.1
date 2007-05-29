Return-Path: <linux-kernel-owner+w=401wt.eu-S1763721AbXE2E7K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763721AbXE2E7K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 00:59:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755033AbXE2E65
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 00:58:57 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:53956 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277AbXE2E65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 00:58:57 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Albert Cahalan" <acahalan@gmail.com>
Cc: linux-kernel@vger.kernel.org, holt@sgi.com, oleg@tv-sign.ru,
       roland@redhat.com, davidel@xmailserver.org, mingo@elte.hu,
       torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [RFC, PATCH 1/3] introduce SYS_CLONE_MASK
References: <787b0d920705281959l53e74d02g21a6fecd86d73219@mail.gmail.com>
Date: Mon, 28 May 2007 22:57:49 -0600
In-Reply-To: <787b0d920705281959l53e74d02g21a6fecd86d73219@mail.gmail.com>
	(Albert Cahalan's message of "Mon, 28 May 2007 22:59:28 -0400")
Message-ID: <m11wh08bw2.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Albert Cahalan" <acahalan@gmail.com> writes:

> This has long been rotten. Mind fixing it for us? :-)
>
> We have N types of thread on M CPUs. Pick something, N or M,
> to be at the top level in /proc. The other goes below, in the
> per-process task directories.
>
> You then have either N or M things showing up in ps, not N*M.
>
> Note that both ps and top can print the CPU number just fine.
> Abusing the task name for this is just retarded. This suggests
> that the top level should be the type of task, with the lower
> level in /proc/*/task being per-CPU and not needing distinct
> naming at all.

In a lot of ways that is reasonable.  However kernel threads don't
share signal handling and getting to the point where they could share
signal handling would be difficult so we cannot use the generic
CLONE_THREAD handling they really are more like individual processes.
So at that level the cpu number in the name is just to help tell them
apart. 

Eric

