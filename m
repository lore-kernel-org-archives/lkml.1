Return-Path: <linux-kernel-owner+w=401wt.eu-S1760892AbYAVNYp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760892AbYAVNYp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 08:24:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753127AbYAVNYg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 08:24:36 -0500
Received: from [212.12.190.62] ([212.12.190.62]:48291 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753263AbYAVNYf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 08:24:35 -0500
From: Al Boldi <a1426z@gawab.com>
To: Ingo Molnar <mingo@elte.hu>,
       Oliver Pinter (=?iso-8859-1?q?Pint=E9r?=
	=?iso-8859-1?q?=20Oliv=E9r?=) <oliver.pntr@gmail.com>
Subject: Re: konqueror deadlocks on 2.6.22
Date: Tue, 22 Jan 2008 16:23:42 +0300
User-Agent: KMail/1.5
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <200801192114.41427.a1426z@gawab.com> <6101e8c40801191417k7906422chf657895152b61a2d@mail.gmail.com> <20080122101014.GD5722@elte.hu>
In-Reply-To: <20080122101014.GD5722@elte.hu>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <200801221623.42989.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Oliver Pinter (Pintér Olivér) <oliver.pntr@gmail.com> wrote:
> > and then please update to CFS-v24.1
> > http://people.redhat.com/~mingo/cfs-scheduler/sched-cfs-v2.6.22.15-v24.1
> >.patch
> >
> > > Yes with CFSv20.4, as in the log.
> > >
> > > It also hangs on 2.6.23.13
>
> my feeling is that this is some sort of timing dependent race in
> konqueror/kde/qt that is exposed when a different scheduler is put in.
>
> If it disappears with CFS-v24.1 it is probably just because the timings
> will change again. Would be nice to debug this on the konqueror side and
> analyze why it fails and how. You can probably tune the timings by
> enabling SCHED_DEBUG and tweaking /proc/sys/kernel/*sched* values - in
> particular sched_latency and the granularity settings. Setting wakeup
> granularity to 0 might be one of the things that could make a
> difference.

Thanks Ingo, but Mike suggested that data=writeback may make a difference, 
which it does indeed.

So the bug seems to be related to data=ordered, although I haven't gotten any 
feedback from the ext3 gurus yet.

Seems rather critical though, as data=writeback is a dangerous mode to run.


Thanks!

--
Al

