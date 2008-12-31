Return-Path: <linux-kernel-owner+w=401wt.eu-S1757130AbYLaS5Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757130AbYLaS5Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 13:57:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756384AbYLaS5R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 13:57:17 -0500
Received: from ik-out-1112.google.com ([66.249.90.179]:9331 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756241AbYLaS5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 13:57:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:in-reply-to:references
         :x-mailer:mime-version:content-type:content-transfer-encoding;
        b=FI75bGjRzokoFaOuTq8e7RBgxQFMNuAO2VnUklAEtGRgM7/Z+6LPJPcEYOFis11xO5
         bhZ8qq9lKFNLJTElA8UadT9fKIv16QPQRo5GZoVpyG9fb00J67wzptciGXUuYKS4dOsd
         5ZEWkfJo+cBEIr7mLqizR0oUH+XhHGu9E7xUo=
Date: Wed, 31 Dec 2008 20:57:08 +0200
From: Pekka Paalanen <pq@iki.fi>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Pekka J Enberg <penberg@cs.helsinki.fi>, mingo@elte.hu,
       linux-kernel@vger.kernel.org,
       Markus Metzger <markus.t.metzger@gmail.com>
Subject: Re: ftrace behaviour (was: [PATCH] ftrace: introduce
 tracing_reset_online_cpus() helper)
Message-ID: <20081231205708.4ee8b141@iki.fi>
In-Reply-To: <alpine.DEB.1.10.0812311332410.6262@gandalf.stny.rr.com>
References: <Pine.LNX.4.64.0812191207130.6888@melkki.cs.Helsinki.FI>
	<c62985530812190247i705d9c3er7662a1b133c6eb29@mail.gmail.com>
	<alpine.DEB.1.10.0812191216190.26432@gandalf.stny.rr.com>
	<20081220004453.50aec846@daedalus.pq.iki.fi>
	<alpine.DEB.1.10.0812191827390.26234@gandalf.stny.rr.com>
	<20081220041759.5a026f5a@daedalus.pq.iki.fi>
	<alpine.DEB.1.10.0812192140350.29275@gandalf.stny.rr.com>
	<20081231155325.392699d0@iki.fi>
	<alpine.DEB.1.10.0812311332410.6262@gandalf.stny.rr.com>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Dec 2008 13:33:19 -0500 (EST)
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Wed, 31 Dec 2008, Pekka Paalanen wrote:
> > 
> > "tracing_on" is not a function call, so nesting does not make sense.
> > It is a file in debugfs, and therefore an end user interface. I am only
> > talking about the debugfs files, not functions. Only developers use
> > functions and devels can be expected to find the implementation and
> > read the fine documentation.
> > 
> > How about /debug/tracing/recording with values 0 and 1?
> > That would be a clear distinction to /debug/tracing/tracing_enabled.
> > I have also wondered about the "tracing_" prefix, the files are
> > already in the tracing/ directory.
> > 
> > I am just trying to think what file names would make sense in
> > debugfs. I completely agree with you on function naming, but should
> > the file have the same name as the function? Sure, for developers
> > it would be easier to remember, but the name might not make any
> > sense unless you know the internal implementation.
> > 
> > If something else than tracing starts to use the ring buffer
> > facility, we have to think about the names again. Until then,
> > just my 2c. :-)
> 
> Since this really only enables or disables the ring buffer, perhaps 
> "ringbuffer_enabled" is the way to go?

As a C-function or as a debugfs file?
Are we controlling an action (recording events), a feature (a buffer
where to record) or an implementation (a ring buffer)?
Does the user know or care if it is a ring buffer or just whatever
temporary storage?
What does the user actually want to control? A buffer? A ring
buffer? Recording stuff? The tracer? Tracing? Data flow?
Assuming there are also other users than tracing, does it make
sense to control the ring buffer facility itself?

I'm sure we could discuss this forever, so I'll just say:
Happy new year! :-)

-- 
Pekka Paalanen
http://www.iki.fi/pq/
