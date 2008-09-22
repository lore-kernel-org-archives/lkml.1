Return-Path: <linux-kernel-owner+w=401wt.eu-S1754006AbYIVXMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006AbYIVXMT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 19:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754131AbYIVXLv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 19:11:51 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:35249 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753614AbYIVXLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 19:11:48 -0400
Message-ID: <e17d46420809221611yeb107a1hd395770e4915b20@mail.gmail.com>
Date: Mon, 22 Sep 2008 16:11:48 -0700
From: "Darren Hart" <darren@dvhart.com>
To: "Masami Hiramatsu" <mhiramat@redhat.com>
Subject: Re: Unified tracing buffer
Cc: "Martin Bligh" <mbligh@google.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Mathieu Desnoyers" <compudj@krystal.dyndns.org>,
       "Steven Rostedt" <rostedt@goodmis.org>, od@novell.com,
       "Frank Ch. Eigler" <fche@redhat.com>,
       systemtap-ml <systemtap@sources.redhat.com>
In-Reply-To: <48D81B5F.2030702@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <33307c790809191433w246c0283l55a57c196664ce77@mail.gmail.com>
	 <48D7F5E8.3000705@redhat.com>
	 <33307c790809221313s3532d851g7239c212bc72fe71@mail.gmail.com>
	 <48D81B5F.2030702@redhat.com>
X-Google-Sender-Auth: 427fa22cacd59196
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2008 at 3:25 PM, Masami Hiramatsu <mhiramat@redhat.com> wrote:

>> One thing that I think is still important is to have a unified timestamp
>> mechanism on everything, so we can co-ordinate different things back
>> together in userspace from different trace tools, so I intend to keep
>> that at a lower level, but I think you're right that the event id, etc can
>> move up into separate layers.
>
> I'm not so sure that the unified 'timestamp' must be required by all tracers.
> If you just need to merge and sort per-cpu data, you can use an atomic
> sequential number for it.
> IMHO, the unified 'timestamp' would better be an option, because some
> architectures can't support it. I think preparing timestamp-callback
> function will help us.
>

There have been several posts on the timestamp for the events.  From a
real-time perspective, this timestamp will be a very important datapoint for
each event, and the more accurate/higher resolution the better.  Some thoughts.

o pretty print resolution should definitely be nanosecond (IMHO)

o internal storage should be "whatever is fastest" with the transformation to
 ns data stored in the trace header (as I believe Mathieu mentioned).

o for archs where the clock isn't synchronized across CPUs, perhaps for now it
 would be adequate to record the per cpu timestamps in the trace header and
 include the cpu id for each event as well.  This is in keeping with the
 previous suggestion to collect the most primitive data available without
 doing any sort of transformation at trace time.

--
Darren Hart
