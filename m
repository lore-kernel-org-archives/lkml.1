Return-Path: <linux-kernel-owner+w=401wt.eu-S1763569AbYDVRgZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763569AbYDVRgZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 13:36:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757893AbYDVRgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 13:36:12 -0400
Received: from pne-smtpout4-sn1.fre.skanova.net ([81.228.11.168]:42011 "EHLO
	pne-smtpout4-sn1.fre.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755541AbYDVRgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 13:36:11 -0400
Date: Tue, 22 Apr 2008 20:36:02 +0300
From: Pekka Paalanen <pq@iki.fi>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>, akpm@osdl.org,
       Peter Zijlstra <peterz@infradead.org>,
       Soeren Sandmann Pedersen <sandmann@redhat.com>
Subject: Re: [PATCH 0/3] ftrace: overrun accounting and trace_pipe headers
Message-ID: <20080422203602.488bb8f9@daedalus.pq.iki.fi>
In-Reply-To: <20080421210935.460817943@goodmis.org>
References: <20080421210935.460817943@goodmis.org>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Excellent!

On Mon, 21 Apr 2008 17:09:35 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> The first patch in this series adds accounting to record overruns. That is
> where the writing catches up to the reading of the buffer. This really
> only matters for trace_pipe since that's a consumer / producer output file.

This takes me some thinking how to make the best of it, but looks like it
allows me to relay the overrun events into the trace log. Very good.

> The next patch adds new methods for the plugins to hook into the
> open_pipe and open_read, to let a plugin produce a header.
> The open_read method can also be used to do something when overruns
> are detected.

You mean pipe_open() and read()? :-)
And read() is pipe specific?
Ah, now I see what you mean by read() can be used to notice overruns:
it is called for every read syscall, not just in the beginning.

> The last patch is a test patch AND SHOULD NOT BE APPLIED. It is just an
> example in how to use the new methods to produce a header. It simply
> makes the ftrace tracer produce a simple "Test header" before any
> output.

In function_read(), shouldn't I be doing something with filp and/or ppos?


Thanks.

-- 
Pekka Paalanen
http://www.iki.fi/pq/
