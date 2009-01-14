Return-Path: <linux-kernel-owner+w=401wt.eu-S1760849AbZANAOr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760849AbZANAOr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 19:14:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758123AbZANANy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 19:13:54 -0500
Received: from THUNK.ORG ([69.25.196.29]:55562 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757422AbZANANv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 19:13:51 -0500
Date: Tue, 13 Jan 2009 19:13:46 -0500
From: Theodore Tso <tytso@mit.edu>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Ext4 Developers List <linux-ext4@vger.kernel.org>,
       ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org
Subject: Re: [ltt-dev] LTTng 0.74 for Linux 2.6.28 (ext4 tracepoints)
	(fixed in LTTng 0.78)
Message-ID: <20090114001346.GB14730@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Mathieu Desnoyers <compudj@krystal.dyndns.org>,
	KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org
References: <20090109235449.GA21999@Krystal> <20090110161137.GA20526@Krystal> <2f11576a0901131433h31056e34n82588a9c643224de@mail.gmail.com> <20090113225827.GA5791@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090113225827.GA5791@Krystal>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2009 at 05:58:27PM -0500, Mathieu Desnoyers wrote:
> > 
> > -ECANTBUILD
> > 
> Thanks for the report. This should be fixed in LTTng 0.78 now.

Out of curiosity, do you maintain a branch of LTTNG versus any of the
-rc kernels, or do you only track the stable kernels?  I tried pulling
LTTNG 0.78 against the most recent Linus mainline and got a whole pile
of conflicts.

I then tried building LTTng 0.78 and got build failures:

  CC      arch/x86/kernel/init_task.o
distcc[27501] ERROR: compile /var/cache/ccache/init_task.tmp.closure.27497.i on localhost failed
/usr/projects/linux/ext4/arch/x86/kernel/init_task.c:35: error: unknown field ‘user_markers_mutex’ specified in initializer
/usr/projects/linux/ext4/arch/x86/kernel/init_task.c:35: warning: braces around scalar initializer
/usr/projects/linux/ext4/arch/x86/kernel/init_task.c:35: warning: (near initialization for ‘init_task.latency_record_count’)
/usr/projects/linux/ext4/arch/x86/kernel/init_task.c:35: error: field name not in record or union initializer
/usr/projects/linux/ext4/arch/x86/kernel/init_task.c:35: error: (near initialization for ‘init_task.latency_record_count’)

Looks like CONFIG_MARKERS_USERSPAC is busted....

						- Ted
