Return-Path: <linux-kernel-owner+w=401wt.eu-S1754851AbZFXSx7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851AbZFXSx7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 14:53:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751666AbZFXSxv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 14:53:51 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42209 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751058AbZFXSxu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 14:53:50 -0400
Message-ID: <4A427631.4090609@redhat.com>
Date: Wed, 24 Jun 2009 11:53:37 -0700
From: Josh Stone <jistone@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b5pre) Gecko/20090513 Fedora/3.0-2.4.b3pre.hg.6a6386c16e98.fc11 Lightning/1.0pre Thunderbird/3.0b3pre
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Rober Richter <robert.richter@amd.com>, anil.s.keshavamurthy@intel.com,
       ananth@in.ibm.com, davem@davemloft.net, mhiramat@redhat.com,
       SystemTap <systemtap@sources.redhat.com>, Eric Anholt <eric@anholt.net>,
       Chris Wilson <chris@chris-wilson.co.uk>,
       intel-gfx@lists.freedesktop.org
Subject: Re: Infrastructure for tracking driver performance events
References: <20090624172912.GB5565@ben-laptop>
In-Reply-To: <20090624172912.GB5565@ben-laptop>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2009 10:29 AM, Ben Gamari wrote:
[...]
> I recently wrote a very simple patch to add accounting for these types
> of stalls to the i915 driver[1], exposing a list of wait-event counts to
> userspace through debugfs. While this is useful for giving a general
> overview of the drivers' performance, it does very little to expose
> individual bottlenecks in the driver or userland components. It has been
> suggested[2] that this wait-event tracking functionality would be far more
> useful if we could provide stack backtraces all the way into user space
> for each wait event.
[...]
> Another option seems to be systemtap. It has already been documented[3]
> that this option could provide both user-mode and kernel-mode
> backtraces. The driver could provide a kernel marker at every potential
> wait point (or a single marker in a function called at each wait point,
> for that matter) which would be picked up by systemtap and processed in
> usermode, calling ptrace to acquire a usermode backtrace. This approach
> seems slightly cleaner as it doesn't require the tracing on the entire
> machine to catch what should be reasonably rare events (hopefully).
> 
> Unfortunately, the systemtap approach described in [3] requires that
> each process have an associated "driver" process to get a usermode
> backtrace. It would be nice to avoid this requirement as there are
> generally far more gpu clients than just the X server (i.e. direct
> rendering clients) and tracking them all could get tricky.
[...]
> [3] http://sourceware.org/ml/systemtap/2006-q4/msg00198.html

I have to say, I'm a bit surprised to see my hacky suggestion
resurrected from the archives.  :)  I would guess that that approach
would add way too much overhead to be of use in diagnosing stalls though.

However, I think we can do a lot better with systemtap these days.
We're growing the ability to do userspace backtraces[1] directly within
your systemtap script, which should be much less intrusive.

Please take a look at ubacktrace() and family in recent systemtap and
let us know how you think it could improve.

Thanks,

Josh

[1] http://sourceware.org/ml/systemtap/2009-q2/msg00364.html
