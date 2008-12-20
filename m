Return-Path: <linux-kernel-owner+w=401wt.eu-S1755251AbYLTBij@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251AbYLTBij (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 20:38:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752637AbYLTBib
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 20:38:31 -0500
Received: from nf-out-0910.google.com ([64.233.182.189]:34597 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355AbYLTBia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 20:38:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:in-reply-to:references
         :x-mailer:mime-version:content-type:content-transfer-encoding;
        b=vmQfzh+OMTlz9W2eyDzbBYrpD/vU18GWiVhOx/bwYY+ZLLZlQ0CFi8Pppqhe8gRBxU
         yUWdSdQtVu8p3KWeimIJIBfh4Qu9na7xbDTBQOOL20v7gThRf36f6A44WmFt+Sx89iIK
         TWhfYjdEmu7CyHZ9AcpaMOCMlYIZ0caZ3NFRg=
Date: Sat, 20 Dec 2008 03:38:22 +0200
From: Pekka Paalanen <pq@iki.fi>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Pekka J Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>,
       Markus Metzger <markus.t.metzger@gmail.com>
Subject: Re: ftrace behaviour (was: [PATCH] ftrace: introduce
 tracing_reset_online_cpus() helper)
Message-ID: <20081220033822.362bc88a@daedalus.pq.iki.fi>
In-Reply-To: <alpine.DEB.1.10.0812191912280.26234@gandalf.stny.rr.com>
References: <Pine.LNX.4.64.0812191207130.6888@melkki.cs.Helsinki.FI>
	<c62985530812190247i705d9c3er7662a1b133c6eb29@mail.gmail.com>
	<alpine.DEB.1.10.0812191216190.26432@gandalf.stny.rr.com>
	<20081220004453.50aec846@daedalus.pq.iki.fi>
	<20081219225717.GK13409@elte.hu>
	<alpine.DEB.1.10.0812191810110.26234@gandalf.stny.rr.com>
	<20081219233443.GC17984@elte.hu>
	<alpine.DEB.1.10.0812191912280.26234@gandalf.stny.rr.com>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Dec 2008 19:29:30 -0500 (EST)
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Sat, 20 Dec 2008, Ingo Molnar wrote:
> > 
> > The current "only allow resizing while tracing is disabled" is an 
> > unintuitive and counterproductive restriction - a borderline bug in fact.
> 
> Having to disable tracing to resize is much better than having to reboot.
> 
> I'm not defending that this is the way to go. I never planned on keeping 
> this the defacto standard. I've been setting up infrastructure to allow 
> for a seamless resize. If you think we should reset the buffers on resize, 
> then that would be a great way for the user to know why they are missing 
> **all** their data.

I thought this was just about not having to do

$ echo 0 > tracing_enabled
$ echo 28764243 > buffer_size
$ echo 1 > tracing_enabled

and instead just do

$ echo 28764243 > buffer_size

which would do exactly the same, except being easier for the user.
Personally I've never dreamed of any kind of resize-in-flight.

> What I'm trying to say is that the more we allow during resize, the more 
> likely there will be a critical bug that might lock up the system. The 
> whole point about writing the ring buffer was to do it incrementally. 
> Start out with being straight forward and simple, then we could add 
> features as we understand things better.
> 
> IOW, I totally agree that we should make it as intuitive as possible. But 
> this needs to be done step by step. I wrote 10 different versions of the 
> ring buffer in a week. Most of them were complete rewrites. I want this to 
> be as robust and powerful as you do, but I also want to be cautious about 
> doing things that might crash the system.
> 
> Ftrace already had the infrastructure in place to protect against resize. 
> I just used it to give me time to do other things with the ring buffer. 
> I always planned on having the resize protection back inside the ring 
> buffer code when I got around to it.
> 
> -- Steve

-- 
Pekka Paalanen
http://www.iki.fi/pq/
