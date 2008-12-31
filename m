Return-Path: <linux-kernel-owner+w=401wt.eu-S1757168AbYLaWI2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757168AbYLaWI2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 17:08:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752326AbYLaWIU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 17:08:20 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:46141 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191AbYLaWIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 17:08:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:in-reply-to:references
         :x-mailer:mime-version:content-type:content-transfer-encoding;
        b=geaaaV/T1lJmtDvqrnkhFogVEa9phSMEzL6abRKXAe0zgP/uNdmsZCboI5wKRMP5ZN
         /JJuJqhM+s7GIo98sto4MtYBuG+Hklyx2040pZAviVMgLgFSqhH67WcF3dN0ye2NloJb
         7MjNicFHmunYDugZFCsrwpL90qPrbf9P3to2Y=
Date: Thu, 1 Jan 2009 00:08:12 +0200
From: Pekka Paalanen <pq@iki.fi>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Pekka J Enberg <penberg@cs.helsinki.fi>, mingo@elte.hu,
       linux-kernel@vger.kernel.org,
       Markus Metzger <markus.t.metzger@gmail.com>
Subject: Re: ftrace behaviour (was: [PATCH] ftrace: introduce
 tracing_reset_online_cpus() helper)
Message-ID: <20090101000812.1fd2c088@iki.fi>
In-Reply-To: <alpine.DEB.1.10.0812311401120.6750@gandalf.stny.rr.com>
References: <Pine.LNX.4.64.0812191207130.6888@melkki.cs.Helsinki.FI>
	<c62985530812190247i705d9c3er7662a1b133c6eb29@mail.gmail.com>
	<alpine.DEB.1.10.0812191216190.26432@gandalf.stny.rr.com>
	<20081220004453.50aec846@daedalus.pq.iki.fi>
	<alpine.DEB.1.10.0812191827390.26234@gandalf.stny.rr.com>
	<20081220041759.5a026f5a@daedalus.pq.iki.fi>
	<alpine.DEB.1.10.0812192140350.29275@gandalf.stny.rr.com>
	<20081231155325.392699d0@iki.fi>
	<alpine.DEB.1.10.0812311332410.6262@gandalf.stny.rr.com>
	<20081231205708.4ee8b141@iki.fi>
	<alpine.DEB.1.10.0812311401120.6750@gandalf.stny.rr.com>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Dec 2008 14:06:26 -0500 (EST)
Steven Rostedt <rostedt@goodmis.org> wrote:

> I was thinking of only changing the debugfs file.
> 
> > Are we controlling an action (recording events), a feature (a buffer
> > where to record) or an implementation (a ring buffer)?
> 
> Good point. It only disables the recording, so perhaps a "record_enabled" 
> would be better?

To me "record" sounds more of a noun than a verb, but it's both and
I'm not a native speaker. Still, it brings me to "recording_enabled",
and do we really need the "_enabled" part? So we end up to what I
suggested earlier: "recording" with values 0 and 1. :-)

Anyway, it's good to start the file name with a few distinct letters,
it makes tab-completion so much easier on the command line.

> > What does the user actually want to control? A buffer? A ring
> > buffer? Recording stuff? The tracer? Tracing? Data flow?
> > Assuming there are also other users than tracing, does it make
> > sense to control the ring buffer facility itself?
> 
> I think the name record_enabled for debugfs is the best. This is exactly 
> what happens (not how it is implemented). When someone echos 0 to 
> record_enabled (currently called tracing_on), it stops the recording, and 
> nothing else. The tracers still try to write to the buffer, but the write 
> always fails. This does not disable the tracers or even notify the tracer 
> that the buffers have stopped recording. This is just a simple light 
> weight way to stop and start recording to the trace buffers from either 
> user space or kernel space.  Kernel space can stop it, and user space can 
> start it again (that was the original request for this feature).
> 
> I'm leaning towards record_enabled now.

-- 
Pekka Paalanen
http://www.iki.fi/pq/
