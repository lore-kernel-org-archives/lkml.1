Return-Path: <linux-kernel-owner+w=401wt.eu-S1753276AbZKCGRz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276AbZKCGRz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 01:17:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751662AbZKCGRz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 01:17:55 -0500
Received: from tomts13.bellnexxia.net ([209.226.175.34]:61344 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750998AbZKCGRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 01:17:54 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlgFAJ9W70pGGN1W/2dsb2JhbACBUNsIgjuCAgQ
Date: Tue, 3 Nov 2009 01:17:53 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: ltt-dev@lists.casi.polymtl.ca
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: LTTng 0.165 for 2.6.31.5 : refactoring/cleanup
Message-ID: <20091103061753.GA5815@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 01:01:42 up 76 days, 16:51,  4 users,  load average: 1.58, 0.66,
	0.41
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I just finished testing the LTTng refactoring. It consists of:

- Change design to inheritance for channels and buffers.
  - Eliminate structure duplication for locking/allocation level of buffer and
    channel.
  - Remove now unnecessary krefs.
- Fix cpu hotplug for timers.
- Cleanups.

Impact:
- Cleaner code.
- Simpler structures for channel/buffers.
- Smaller d-cache footprint.

It also permits to change the license of all LTTng modules needed both
for kernel and user-space tracing to dual LGPL/GPL license.

Due to the size of this change, review and testing would be very
welcome. I decided to do it in a separate patch on top of the tree
rather than rebasing. Considering the size of this modification, going
over the modified code on a file by file basis rather than looking at
the patch itself is probably easier.

I decided to mark the "locked" and "irqoff" locking schemes as "BROKEN"
for now and focus on the lockless scheme. We could re-create them if
needed by deriving from the lockless code-base.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
