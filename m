Return-Path: <linux-kernel-owner+w=401wt.eu-S1758524AbZLIWlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758524AbZLIWlV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 17:41:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758506AbZLIWlO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 17:41:14 -0500
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:32354
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758404AbZLIWlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 17:41:08 -0500
X-SpamScore: -12
X-BigFish: VPS-12(zzzz1202hzz5eeeTz2fh6bh61h)
X-Spam-TCS-SCL: 0:0
Message-ID: <4B202753.4010108@am.sony.com>
Date: Wed, 9 Dec 2009 14:40:19 -0800
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: linux kernel <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/4] ftrace - Add function duration tracer to ftrace
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Dec 2009 22:40:20.0700 (UTC) FILETIME=[96A831C0:01CA7920]
X-SEL-encryption-scan: scanned
X-Reverse-DNS: mail8.fw-sd.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've created a new tracer, called the "function duration" tracer,
which is derived from the existing function graph tracer.  The
new feature of this tracer, relative to the function graph tracer,
is that it allows filtering by duration.

The rationale for creating a separate tracer is that some of the
optimizations used for the duration tracer were incompatible with
the function graph tracer.  Specifically, I avoid superfluous
calls to the ring_buffer code, avoiding substantial overhead
penalties.  Also, this tracer is more suitable for use at
bootup time (I have a set of patches pending which adds support
for that, on ARM).

The output format for the tracer is amenable to grep-ing.
That is, the duration is on the same line as the function name.

For details about this, see my presentation from the Japan Linux
Symposium:
http://elinux.org/images/7/70/Measuring-function-duration-with-ftrace-oct-2009.pdf

with more information available at the elinux wiki page:
http://elinux.org/Ftrace_Function_Graph_ARM

Patches to follow.  Thanks.
 -- Tim


