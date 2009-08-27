Return-Path: <linux-kernel-owner+w=401wt.eu-S1751386AbZH0K4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751386AbZH0K4T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 06:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751095AbZH0K4S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 06:56:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47601 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751085AbZH0K4S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 06:56:18 -0400
Date: Thu, 27 Aug 2009 12:52:09 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: mmotm 2009-08-24-16-24 uploaded
Message-ID: <20090827105209.GA8469@redhat.com>
References: <200908242328.n7ONSUHI022326@imap1.linux-foundation.org> <20090827144453.25f1161b.kamezawa.hiroyu@jp.fujitsu.com> <20090827160532.d6386722.kamezawa.hiroyu@jp.fujitsu.com> <20090827093441.GA3451@redhat.com> <20090827184303.500ac1f0.kamezawa.hiroyu@jp.fujitsu.com> <20090827100846.GA6462@redhat.com> <20090827193133.b7eed4a9.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090827193133.b7eed4a9.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27, KAMEZAWA Hiroyuki wrote:
>
> On Thu, 27 Aug 2009 12:08:46 +0200
> Oleg Nesterov <oleg@redhat.com> wrote:
>
> >
> > OK, I seem to understand what happens. Could you try the patch below?
> >
>
> worked.

Thanks. I need to think a bit, then I send the fix.

> IMHO, it's necessary to "wake up parent with -ECHILD if all children dies"

Of course! It was supposed to do. More precisely, we should wake up when
any child which cuould be interesting to ->parent dies. No need to check
"all children died" case specially. If parent sleeps on ->wait_chldexit
there must be at least on eligible child.

The problem is, do_notify_parent() changes ->exit_signal _before_ it calls
__wake_up_parent(). This changes the result of eligible_child().

Oleg.

