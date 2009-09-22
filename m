Return-Path: <linux-kernel-owner+w=401wt.eu-S1755722AbZIVJUi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755722AbZIVJUi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 05:20:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754379AbZIVJUg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 05:20:36 -0400
Received: from ozlabs.org ([203.10.76.45]:51293 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751281AbZIVJUe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 05:20:34 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19128.38623.956765.684792@cargo.ozlabs.ibm.com>
Date: Tue, 22 Sep 2009 19:20:31 +1000
From: Paul Mackerras <paulus@samba.org>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf_counter: cleanup for __perf_event_sched_in()
In-Reply-To: <4AB88F06.10900@cn.fujitsu.com>
References: <4AB88F06.10900@cn.fujitsu.com>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Xiao Guangrong writes:

> It must be a group leader if event->attr.pinned is "1"

True, but you shouldn't use BUG_ON unless there is no sensible way for
the kernel to continue executing, and that's not the case here.  Make
it WARN_ON, or better still, WARN_ON_ONCE.

Paul.
