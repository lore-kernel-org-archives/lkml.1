Return-Path: <linux-kernel-owner+w=401wt.eu-S1755168AbZEGHU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755168AbZEGHU0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 03:20:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751175AbZEGHUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 03:20:11 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47900 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752187AbZEGHUK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 03:20:10 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org
Subject: Re: [FOR REVIEW, PATCH 2/2] introduce "struct wait_opts" to
	simplify do_wait() pathes
In-Reply-To: Oleg Nesterov's message of  Thursday, 7 May 2009 08:45:59 +0200 <20090507064559.GC15220@redhat.com>
References: <20090506053324.GA31988@redhat.com>
	<20090506200949.4FF6CFC39E@magilla.sf.frob.com>
	<20090507064559.GC15220@redhat.com>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20090507072003.8E0ACFC39E@magilla.sf.frob.com>
Date: Thu,  7 May 2009 00:20:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yes, I considered this option too. But since (I hope) you do not have
> a strong opinion on this, I'd prefer to keep the code as is. This way
> do_wait() looks more symmetrical wrt to other helpers. And we don't
> copy args twice.

I don't feel strongly.  But I do think that those two repeated assignment
blocks are more to read and harder to read, and more error-prone for drift
in future changes (vs prototype changes getting quick compilation errors).
do_wait() is not "another helper", it's the main function.  On machines
with 6 argument registers (everything but x86-32?), the compiler probably
does fine making the callers' register shuffling be free.  On x86-32, a few
cache-hot stack stores and loads are in the tiny noise vs the whole cost of
this hairy syscall, and IMHO don't compare to source maintainability issues.


Thanks,
Roland
