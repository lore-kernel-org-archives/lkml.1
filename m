Return-Path: <linux-kernel-owner+w=401wt.eu-S1752224AbZDNGgL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752224AbZDNGgL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 02:36:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751551AbZDNGf4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 02:35:56 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:43877 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327AbZDNGfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 02:35:55 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] tracing/lockdep: turn lock->name into an array
Cc: kosaki.motohiro@jp.fujitsu.com, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Tom Zanussi <tzanussi@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <1239662166-13208-1-git-send-email-fweisbec@gmail.com>
References: <1239662166-13208-1-git-send-email-fweisbec@gmail.com>
Message-Id: <20090414153035.C662.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Tue, 14 Apr 2009 15:35:51 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> Impact: allow filtering by lock name / fix module tracing
> 
> Currently, the "lock acquired" event is traced using a TRACE_EVENT.
> But we can't use the char * type for the name without risking to
> dereference a freed pointer. A lock name can come from a module
> towards lockdep and it is risky to only store its address because we
> defer its name printing.

When released lockdep string table?
I guess it only happend at module unloading. if so, we should consider to
make delayed string table freeing at module unloading.

My point is, module unloading is rare event. thus meking pointer safe mechanism
widely avoid string copy.

IOW, if not, ringbuffer is filled tons string. it kill the merit of binary
buffer and current design.


> That's why this patch uses a fixed array size and copy the name.
> Also it lets us filter the lock name because the event filtering
> doesn't handle the char pointers. Such support is not needed yet since
> the events don't use it for now because it is rarely easy to keep track
> of a string while we defer its output.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>



