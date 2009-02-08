Return-Path: <linux-kernel-owner+w=401wt.eu-S1752202AbZBHPRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752202AbZBHPRT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 10:17:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751311AbZBHPRK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 10:17:10 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:56928 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160AbZBHPRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 10:17:10 -0500
Date: Sun, 8 Feb 2009 10:17:07 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH tip 2/2] tracing: Introduce
 trace_buffer_{lock_reserve,unlock_commit}
In-Reply-To: <20090208130437.GB6130@nowhere>
Message-ID: <alpine.DEB.1.10.0902081015080.30802@gandalf.stny.rr.com>
References: <20090205181413.GI17653@ghostprotocols.net> <20090205225835.GB23999@nowhere> <20090206015416.GF9846@ghostprotocols.net> <20090206023944.GA24546@nowhere> <20090206031015.GH9846@ghostprotocols.net> <20090208130437.GB6130@nowhere>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 8 Feb 2009, Frederic Weisbecker wrote:
> 
> 
> Ok, yes by making the flags per tracer, it will goes well.
> Just one thing, the insertion of an event is sometimes a hot path
> like with the functions tracer. And such facility adds some unused function calls
> and branch checking.
> But on such cases, we can use directly the ring buffer functions :-)

Yes, please keep the direct calls to the ring buffer on the function 
tracer. The function tracer is also special, in that if we have dynamic 
tracing turned on, we can simply point to a different function that does 
different things depending on trace settings.

Thanks,

-- Steve

