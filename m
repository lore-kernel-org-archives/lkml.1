Return-Path: <linux-kernel-owner+w=401wt.eu-S1759384AbZBYUBk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759384AbZBYUBk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 15:01:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757503AbZBYUBb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 15:01:31 -0500
Received: from mx1.redhat.com ([66.187.233.31]:56684 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757456AbZBYUBa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 15:01:30 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Chris Evans <scarybeasts@gmail.com>,
       David Howells <dhowells@redhat.com>, Don Howard <dhoward@redhat.com>,
       Eugene Teo <eugene@redhat.com>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       Tavis Ormandy <taviso@sdf.lonestar.org>,
       Vitaly Mayatskikh <vmayatsk@redhat.com>, stable@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] copy_process: fix CLONE_PARENT && ->exit_signal
	interaction
In-Reply-To: Oleg Nesterov's message of  Wednesday, 25 February 2009 20:48:51 +0100 <20090225194851.GA9139@redhat.com>
References: <20090225190211.GA7445@redhat.com>
	<20090225193927.1ED25FC3DA@magilla.sf.frob.com>
	<20090225194851.GA9139@redhat.com>
X-Windows: putting new limits on productivity.
Message-Id: <20090225195424.8BF4EFC3DA@magilla.sf.frob.com>
Date: Wed, 25 Feb 2009 11:54:24 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The task T has ->exit_signal != SIGCHLD, say, SIGHUP. It does
> clone(CLONE_PARENT), copy_process() sets ->exit_signal = SIGHUP.
> 
> T->parent exits, T is re-parented to /sbin/init, and its ->exit_signal
> is changed to SIGCHLD.

I see.  It's tempting to call this a reason to just use SIGCHLD instead of
current->group_leader->exit_signal.  Of course, this all really begs the
question of who uses the case and what they want.


Thanks,
Roland
