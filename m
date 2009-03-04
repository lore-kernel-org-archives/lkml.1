Return-Path: <linux-kernel-owner+w=401wt.eu-S1754206AbZCDNCM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206AbZCDNCM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 08:02:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750806AbZCDNB5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 08:01:57 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:59492 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbZCDNB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 08:01:56 -0500
Subject: Re: [PATCH -v2] tracing: lockdep tracepoints
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       =?ISO-8859-1?Q?T=F6r=F6k?= Edwin <edwintorok@gmail.com>,
       Jason Baron <jbaron@redhat.com>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20090304121258.GD6032@nowhere>
References: <1236164586.5330.7142.camel@laptop>
	 <20090304112345.GB6032@nowhere> <1236166375.5330.7209.camel@laptop>
	 <20090304114319.GA4916@elte.hu> <1236167883.5330.7264.camel@laptop>
	 <20090304121258.GD6032@nowhere>
Content-Type: text/plain
Date: Wed, 04 Mar 2009 14:01:42 +0100
Message-Id: <1236171702.5330.7397.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-04 at 13:12 +0100, Frederic Weisbecker wrote:

> The TRACE_FIELD_SPECIAL is only used in case of complex assignment,
> those that can't be done in a simple "=" expression.
> 
> All you need is simply:
> 
> TRACE_FORMAT(lock_contended,
>      TPPROTO(struct lockdep_map *lock, unsigned long ip),
>      TPARGS(lock, ip),
>      TPFMT("%s", lock->name)
>      TRACE_STRUCT(
> 	TRACE_FIELD(char *, name, lock->name)
>      )
>      TPRAWFMT("%s");
> );

As discussed on IRC, that won't actually work. In generic, you cannot
assume the string is stable, in my particular case it would work, since
lock->name is a compile time constant, except for modules, who will
still ruin that.

So I think something like TRACE_FIELD_STRING() is called for. Not sure
how to integrate a variable length field like that with the static
format description though. Maybe use offsets from the start of the
object as string pointers, so you can place the variable sized bits
after the static bits.



