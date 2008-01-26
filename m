Return-Path: <linux-kernel-owner+w=401wt.eu-S1757076AbYAZF2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757076AbYAZF2Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 00:28:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751982AbYAZF17
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 00:27:59 -0500
Received: from [212.12.190.175] ([212.12.190.175]:60667 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751049AbYAZF16 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 00:27:58 -0500
From: Al Boldi <a1426z@gawab.com>
To: Diego Calleja <diegocg@gmail.com>
Subject: Re: [RFC] ext3: per-process soft-syncing data=ordered mode
Date: Sat, 26 Jan 2008 08:27:43 +0300
User-Agent: KMail/1.5
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jan Kara <jack@suse.cz>
References: <200801242336.00340.a1426z@gawab.com> <20080124225026.55fc6c20.diegocg@gmail.com>
In-Reply-To: <20080124225026.55fc6c20.diegocg@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <200801260827.43284.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Diego Calleja wrote:
> El Thu, 24 Jan 2008 23:36:00 +0300, Al Boldi <a1426z@gawab.com> escribió:
> > Greetings!
> >
> > data=ordered mode has proven reliable over the years, and it does this
> > by ordering filedata flushes before metadata flushes.  But this
> > sometimes causes contention in the order of a 10x slowdown for certain
> > apps, either due to the misuse of fsync or due to inherent behaviour
> > like db's, as well as inherent starvation issues exposed by the
> > data=ordered mode.
>
> There's a related bug in bugzilla:
> http://bugzilla.kernel.org/show_bug.cgi?id=9546
>
> The diagnostic from Jan Kara is different though, but I think it may be
> the same problem...
>
> "One process does data-intensive load. Thus in the ordered mode the
> transaction is tiny but has tons of data buffers attached. If commit
> happens, it takes a long time to sync all the data before the commit
> can proceed... In the writeback mode, we don't wait for data buffers, in
> the journal mode amount of data to be written is really limited by the
> maximum size of a transaction and so we write by much smaller chunks
> and better latency is thus ensured."
>
>
> I'm hitting this bug too...it's surprising that there's not many people
> reporting more bugs about this, because it's really annoying.
>
>
> There's a patch by Jan Kara (that I'm including here because bugzilla
> didn't include it and took me a while to find it) which I don't know if
> it's supposed to fix the problem , but it'd be interesting to try:


Thanks a lot, but it doesn't fix it.

--
Al

