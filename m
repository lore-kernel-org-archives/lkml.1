Return-Path: <linux-kernel-owner+w=401wt.eu-S1753458Ab0AGWgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458Ab0AGWgh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 17:36:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753273Ab0AGWgf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 17:36:35 -0500
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:46418 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752795Ab0AGWge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 17:36:34 -0500
Message-Id: <20100107223524.760517016@quilx.com>
User-Agent: quilt/0.46-1
Date: Thu, 07 Jan 2010 16:35:24 -0600
From: Christoph Lameter <cl@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Tejun Heo <tj@kernel.org>
Cc: Mike Frysinger <vapier.adi@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org
Subject: [RFC local_t removal V2 0/3] Remove local_t
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current -next has only the trace subsystem left as a user of local_t

Tracing uses local_t for per cpu safe atomic operations in the form
of cmpxchg and additions.

This patchset removes unused function in local.h and then genericizes
local.h by removing local_t. This results in a very small set of
functions.

"long" is used for now instead of local_t. With some additional work it
would be possible to pass arbitrary types to local_xx() function like
cmpxchg_local() and the this_cpu_xx() functions. Maybe a more flexible
way of handling local_xx() would allow the use of these functions in
other kernel subsystems.

Still RFC state. Lots of stuff todo. Compiles on my box.

V1->V2
 - Preserve local.h
 - Add a rationale why the remaining functions are useful and how
   they differ from this_cpu_xx.


