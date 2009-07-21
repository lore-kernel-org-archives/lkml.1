Return-Path: <linux-kernel-owner+w=401wt.eu-S1755562AbZGUQoW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562AbZGUQoW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 12:44:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754551AbZGUQoT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 12:44:19 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:64875 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755129AbZGUQoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 12:44:17 -0400
Date: Tue, 21 Jul 2009 12:44:15 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ray Lee <ray-lk@madrabbit.org>
cc: Jason Baron <jbaron@redhat.com>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, paulus@samba.org, a.p.zijlstra@chello.nl,
       fweisbec@gmail.com
Subject: Re: [PATCH 2/2] perf_counter: detect debugfs location
In-Reply-To: <2c0942db0907210926ra96ee33ke3e6ac8c57458be8@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.0907211242570.11743@gandalf.stny.rr.com>
References: <cover.1248190728.git.jbaron@redhat.com> <42fb2af3afccef87d78ca6dd86169ad180b63271.1248190728.git.jbaron@redhat.com> <2c0942db0907210926ra96ee33ke3e6ac8c57458be8@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 21 Jul 2009, Ray Lee wrote:

> On Tue, Jul 21, 2009 at 9:20 AM, Jason Baron <jbaron@redhat.com> wrote:
> >
> > Search for the debugfs filesystem in /proc/mounts, but also allows the user to
> > specify '--debugfs-dir=blah' or set the environment variable: 'PERF_DIR_DEBUGFS'
> 
> > -static char default_debugfs_path[] = "/sys/kernel/debug/tracing/events";
> 
> There are server systems out there that run with thousands of mounts.
> It would be kinder to the users of those systems (ie, faster perf
> startup) if you only went rooting around /proc/mounts if opening the
> default location failed.

Well, those that have thousand of mounts could probably get away with 
setting PERF_DIR_DEBUGFS in /etc/profile.

But, a simple stat("/sys/kernel/debug/tracing") should be easy enough.

-- Steve

