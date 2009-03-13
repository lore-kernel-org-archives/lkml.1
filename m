Return-Path: <linux-kernel-owner+w=401wt.eu-S1760198AbZCMX2r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760198AbZCMX2r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 19:28:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759345AbZCMX20
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 19:28:26 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:41537 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753399AbZCMX2Y convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 19:28:24 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AugFAIuCuklMQW1W/2dsb2JhbACBTs5JgjWBSQY
Date: Fri, 13 Mar 2009 19:28:11 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org
Cc: mbligh@google.com
Subject: LTTng 0.108 provides many performance improvements
Message-ID: <20090313232811.GA18251@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 19:17:58 up 13 days, 19:44,  2 users,  load average: 0.31, 0.44,
	0.36
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I just released LTTng 0.108. Time had come to do a bit of performance
tuning using oprofile.

Basically, the tbench workload, under flight recorder tracing, passed
from a 52 % slowdown with previous lttng to a 32 % slowdown with lttng
0.108 on my test machine (8-cores x86_64, 16GB ram).

Modifications done :

- inlined fast paths. Modularity is now provided by the build system,
  not by callbacks anymore. Selecting between lockless and locked buffer
  management must be done at compile-time. I'd like to keep the
  "transport" around because it will be used eventually to specify where
  the information must be sent rather than selecting the buffer management
  mechanism (e.g. sent to physical pages (contiguous or non-contiguous),
  video card memory...). The "transport" option is still there, but it
  currently does not do much. The slow paths are now done in function
  calls.

- Fixed false sharing problem. It looks like the kzalloc_node()
  allocator, used to allocate the commit counters, does not align the
  memory allocated on cache lines.

Therefore I think the new code will be _much_ easier to optimize,
because the fastpaths are very well identified and much smaller than
they were before. I diminished the tracer stack space used, register
usage and instruction cache usage.

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
