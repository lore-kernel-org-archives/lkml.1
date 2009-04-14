Return-Path: <linux-kernel-owner+w=401wt.eu-S1754157AbZDNG43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157AbZDNG43 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 02:56:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751195AbZDNG4S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 02:56:18 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:42734 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761AbZDNG4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 02:56:17 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] tracing/lockdep: turn lock->name into an array
Cc: kosaki.motohiro@jp.fujitsu.com, Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Tom Zanussi <tzanussi@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <20090414065303.GA24626@elte.hu>
References: <20090414153035.C662.A69D9226@jp.fujitsu.com> <20090414065303.GA24626@elte.hu>
Message-Id: <20090414155551.C668.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Tue, 14 Apr 2009 15:56:11 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> * KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> 
> > Hi
> > 
> > > Impact: allow filtering by lock name / fix module tracing
> > > 
> > > Currently, the "lock acquired" event is traced using a TRACE_EVENT.
> > > But we can't use the char * type for the name without risking to
> > > dereference a freed pointer. A lock name can come from a module
> > > towards lockdep and it is risky to only store its address because we
> > > defer its name printing.
> > 
> > When released lockdep string table? I guess it only happend at 
> > module unloading. if so, we should consider to make delayed string 
> > table freeing at module unloading.
> > 
> > My point is, module unloading is rare event. thus meking pointer 
> > safe mechanism widely avoid string copy.
> > 
> > IOW, if not, ringbuffer is filled tons string. it kill the merit 
> > of binary buffer and current design.
> 
> We could zap all pending trace entries on module unload (it is a 
> rare operation). That would indeed make a whole category of 
> symbol-alike string pointers safe to be passed by value.

Oh, it seems very good idea!



