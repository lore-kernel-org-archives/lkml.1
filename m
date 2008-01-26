Return-Path: <linux-kernel-owner+w=401wt.eu-S1759137AbYAZF24@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759137AbYAZF24 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 00:28:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753211AbYAZF2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 00:28:09 -0500
Received: from [212.12.190.175] ([212.12.190.175]:60671 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752866AbYAZF2H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 00:28:07 -0500
From: Al Boldi <a1426z@gawab.com>
To: Jan Kara <jack@suse.cz>
Subject: Re: [RFC] ext3: per-process soft-syncing data=ordered mode
Date: Sat, 26 Jan 2008 08:27:59 +0300
User-Agent: KMail/1.5
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200801242336.00340.a1426z@gawab.com> <20080125153634.GG28856@atrey.karlin.mff.cuni.cz>
In-Reply-To: <20080125153634.GG28856@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200801260827.59675.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kara wrote:
> > Greetings!
> >
> > data=ordered mode has proven reliable over the years, and it does this
> > by ordering filedata flushes before metadata flushes.  But this
> > sometimes causes contention in the order of a 10x slowdown for certain
> > apps, either due to the misuse of fsync or due to inherent behaviour
> > like db's, as well as inherent starvation issues exposed by the
> > data=ordered mode.
> >
> > data=writeback mode alleviates data=order mode slowdowns, but only works
> > per-mount and is too dangerous to run as a default mode.
> >
> > This RFC proposes to introduce a tunable which allows to disable fsync
> > and changes ordered into writeback writeout on a per-process basis like
> > this:
> >
> >       echo 1 > /proc/`pidof process`/softsync
>
>   I guess disabling fsync() was already commented on enough. Regarding
> switching to writeback mode on per-process basis - not easily possible
> because sometimes data is not written out by the process which stored
> them (think of mmaped file).

Do you mean there is a locking problem?

> And in case of DB, they use direct-io
> anyway most of the time so they don't care about journaling mode anyway.

Testing with sqlite3 and mysql4 shows that performance drastically improves 
with writeback writeout.

>  But as Diego wrote, there is definitely some room for improvement in
> current data=ordered mode so the difference shouldn't be as big in the
> end.

Yes, it would be nice to get to the bottom of this starvation problem, but 
even then, the proposed tunable remains useful for misbehaving apps.


Thanks!

--
Al

