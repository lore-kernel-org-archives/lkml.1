Return-Path: <linux-kernel-owner+w=401wt.eu-S1751700AbZHXGOh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751700AbZHXGOh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 02:14:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751671AbZHXGOg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 02:14:36 -0400
Received: from mx1-old.redhat.com ([66.187.233.31]:45476 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751661AbZHXGOd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 02:14:33 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix race copy_process() vs de_thread()
In-Reply-To: Hiroshi Shimamoto's message of  Monday, 24 August 2009 13:01:40 +0900 <4A9210A4.4010108@ct.jp.nec.com>
References: <4A9210A4.4010108@ct.jp.nec.com>
X-Shopping-List: (1) Ridiculous hiders
   (2) Quixotic birds
   (3) Enchained barometric depressions
   (4) Simplistic sensuous party snowbulbs
   (5) Quaint dice hamster-lips
Message-Id: <20090824061420.341A9414DF@magilla.sf.frob.com>
Date: Sun, 23 Aug 2009 23:14:20 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm not sure I follow the problem scenario you are citing.

The thread in copy_process() will return -ERESTARTNOINTR
after calling cleanup_signal(), which does properly decrement
sig->count to return it to the state before the copy_process() call.
Then this thread will get to signal handling, dequeue its SIGKILL from
zap_other_threads(), and die itself.  When it's finally reaped, by itself
in exit_notify(), or by de_thread() in the case of a replaced group_leader,
the normal __exit_signal() will do that group_exit_task logic.

What part of this sequence fails to occur in your tests?


Thanks,
Roland
