Return-Path: <linux-kernel-owner+w=401wt.eu-S1754532AbYKFOak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532AbYKFOak (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 09:30:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751582AbYKFOab
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 09:30:31 -0500
Received: from casper.infradead.org ([85.118.1.10]:50962 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047AbYKFOaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 09:30:30 -0500
Date: Thu, 6 Nov 2008 06:31:08 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu
Subject: Re: [PATCH] ftrace: add an fsync tracer
Message-ID: <20081106063108.02b4813d@infradead.org>
In-Reply-To: <1225981141.7803.4577.camel@twins>
References: <20081105094902.27ec4b39@infradead.org>
	<1225976138.7803.4485.camel@twins>
	<20081106060624.58a0f967@infradead.org>
	<1225981141.7803.4577.camel@twins>
Organization: Intel
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 06 Nov 2008 15:19:01 +0100
Peter Zijlstra <peterz@infradead.org> wrote:

> > a syscall tracer will exactly not tell you which file(name) was
> > being fsync()'d which was the whole point.
> 
> It will tell you the process and the fd, and when you have those two
> its a simple step to find the actual file.

actually process+fd is absolutely useless; the typical useage is

fd = open(file)
write(fd, <> )
fsync(fd);
close(fd);

by the time userland gets the data the fd is closed. And heck, even the
program may have exited.
Really, the fd number is only useful for the program itself, not for
any outside part, and especially, later in time.

> 
> > LatencyTOP already KNOWS that fsync is the problem. What it doesn't
> > know is which file is being fsync()d.
> > 
> > fsync is a problem when used incorrectly, not just for ext3 but also
> > due to barriers. That's why it's important to be able to find who
> > calls it when it impacts interactive performance.
> 
> Which suggests you want a tracer that gives more information about who
> generates barriers, not specifically fsync().

that would be a fine second tracer. because the filesystem part of it
is also expensive, and you can diss ext3 all you want, it is reality
for 99% of the people...

(and I suspect that at the barrier level it'll be really hard to get to
a filename)


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
