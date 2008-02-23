Return-Path: <linux-kernel-owner+w=401wt.eu-S1763460AbYBWU04@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763460AbYBWU04 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 15:26:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760897AbYBWU0s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 15:26:48 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:52745 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760492AbYBWU0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 15:26:46 -0500
Subject: Re: [PATCH 3/8] sched: rt-group: interface
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Menage <menage@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       tong.n.li@intel.com
In-Reply-To: <6599ad830802231202q6584557fte44f4976eacc6e89@mail.gmail.com>
References: <20080204210258.118479000@chello.nl>
	 <20080204211836.968632000@chello.nl>
	 <6599ad830802231148w518d937cyd75d1d0a35702d9d@mail.gmail.com>
	 <1203796668.6242.82.camel@lappy>
	 <6599ad830802231202q6584557fte44f4976eacc6e89@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 23 Feb 2008 21:26:29 +0100
Message-Id: <1203798389.6242.98.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2008-02-23 at 12:02 -0800, Paul Menage wrote:
> On Sat, Feb 23, 2008 at 11:57 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> >  > If so, could we avoid that problem by using 0 rather than -1 as the
> >  > "unlimited" value? It looks from what I've read in the Documentation
> >  > changes as though 0 isn't really a meaningful value.
> >
> >  0 means no time, quite useful and clearly distinct from inf. time.
> >
> 
> So a real-time task in a cgroup with a 0 rt_runtime can be in the R
> state but never actually get to run? OK, if people need to be able to
> do that then fair enough.

Yeah, its an awkward situation, and we refuse new rt tasks in such
groups. But the 0 value is needed so you can have groups that don't
participate in the realtime scheduling because we enforce a
schedulalbility constraint over the groups.

Each group has a runtime ratio, namely: rt_runtime / rt_period.
The sum of this ratio over all groups must be smaller or equal to the
global ratio which must be smaller or equal to 1.

> In that case I guess I'll have to add signed versions of the
> read_uint/write_uint methods.

Yes, I looked at that, I found the interface somewhat unfortunate, it
would mean growing the struct with two more function pointers. Perhaps a
read and write function with abstract data would be better suited. That
would allow for this and more. Sadly it looses type information.


