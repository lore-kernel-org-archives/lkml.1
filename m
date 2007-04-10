Return-Path: <linux-kernel-owner+w=401wt.eu-S1753899AbXDJPBz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899AbXDJPBz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 11:01:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753901AbXDJPBz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 11:01:55 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:48985 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753899AbXDJPBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 11:01:54 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Ingo Molnar <mingo@elte.hu>, Robin Holt <holt@sgi.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Snook <csnook@redhat.com>, linux-kernel@vger.kernel.org,
       Jack Steiner <steiner@americas.sgi.com>
Subject: Re: init's children list is long and slows reaping children.
References: <Pine.LNX.4.64.0704051352370.6730@woody.linux-foundation.org>
	<46159987.6090006@redhat.com>
	<Pine.LNX.4.64.0704051825400.6730@woody.linux-foundation.org>
	<m1hcru9rki.fsf@ebiederm.dsl.xmission.com>
	<20070406104301.GB19755@lnx-holt.americas.sgi.com>
	<m1mz1l8qdr.fsf@ebiederm.dsl.xmission.com>
	<20070406163100.GA554@tv-sign.ru> <20070406173249.GA2517@elte.hu>
	<m11wix73ut.fsf@ebiederm.dsl.xmission.com>
	<20070410134814.GA28016@elte.hu> <20070410133808.GA163@tv-sign.ru>
Date: Tue, 10 Apr 2007 09:00:50 -0600
In-Reply-To: <20070410133808.GA163@tv-sign.ru> (Oleg Nesterov's message of
	"Tue, 10 Apr 2007 17:38:08 +0400")
Message-ID: <m13b38z331.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@tv-sign.ru> writes:

> No! That is why I suggest (a long ago, in fact) to move ->children into
> ->signal_struct. When sub-thread forks, we set ->parent = group_leader.
> We don't need forget_original_parent() until the last thead exists. This
> also simplify do_wait().
>
> However, this breaks the current ->pdeath_signal behaviour. In fact (and
> Eric thinks the same) this _fixes_ this behaviour, but may break things.

Thinking about this.  As contingency planning if there is something in user
space that actually somehow cares about pdeath_signal, from a threaded
parent we can add a pdeath_signal list, to the task_struct and get
rid of the rest of the complexity.

I think I want to wait until someone screams first.

This does very much mean that we can remove the complexity of
a per thread ->children without fear, of having to revert everything.

Eric
