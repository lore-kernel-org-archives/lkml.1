Return-Path: <linux-kernel-owner+w=401wt.eu-S1754035AbYIOSB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754035AbYIOSB1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 14:01:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755941AbYIOSBP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 14:01:15 -0400
Received: from smtp-out.google.com ([216.239.33.17]:54516 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755775AbYIOSBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 14:01:13 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:from:to:cc:in-reply-to:references:content-type:
	organization:date:message-id:mime-version:x-mailer:content-transfer-encoding;
	b=CYm15/IsaQN7vE/4ZQeoGDNmq0n37Hs8Yb1aYrmXihIcltLV7CTuDZdISDd2HE+7d
	qgJjXBelVhBAlxq6+MhWA==
Subject: Re: [PATCH 2.6.27-rc5 resubmit] Fix itimer/many thread hang.
From: Frank Mayhar <fmayhar@google.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Roland McGrath <roland@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>
In-Reply-To: <20080915064106.GB15680@elte.hu>
References: <1221238479.30136.2.camel@bobble.smo.corp.google.com>
	 <20080914151404.GA28850@elte.hu>
	 <20080914193140.728F56409D@pipsqueak.localdomain>
	 <20080915064106.GB15680@elte.hu>
Content-Type: text/plain
Organization: Google, Inc.
Date: Mon, 15 Sep 2008 10:59:42 -0700
Message-Id: <1221501582.19012.30.camel@bobble.smo.corp.google.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-09-15 at 08:41 +0200, Ingo Molnar wrote:
> * Roland McGrath <roland@redhat.com> wrote:
> 
> > > please uninline these functions.
> > 
> > They are short and have only one caller.
> 
> then they should be defined in the .c file which uses them.

Well, they are actually used in sched.h, in the inline routines
account_group_user_time() and friends, which are in turn used by
routines in sched.c.  The point here is that the
thread_group_cputime_account_xxx() routines are defined differently
depending upon whether we're building for UP or SMP and the
account_group_xxx() routines use the appropriate version accordingly.

> really, sched.h is large enough already and has lots of unnecessary 
> stuff in it.

Agreed, but Roland and I were trying to make life easier for folks who
have to maintain SMP and UP versions of this stuff, keeping it all in
one place rather than scattering it about.

If you insist, I'll un-inline the routines but this will mean moving all
of this (thread_group_cputime_account_xxx() and account_group_xxx()
routines) to sched.c.  Maybe that makes sense.  It's your call; I'll
hold off on the changes (and resubmitting the patch) while I wait for
you to let me know what you prefer.  Thanks.
-- 
Frank Mayhar <fmayhar@google.com>
Google, Inc.

