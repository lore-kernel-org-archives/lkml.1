Return-Path: <linux-kernel-owner+w=401wt.eu-S932734AbZE0SOJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932734AbZE0SOJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 14:14:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761302AbZE0SNz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 14:13:55 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:40109 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756940AbZE0SNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 14:13:54 -0400
X-Greylist: delayed 391 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 May 2009 14:13:54 EDT
X-Amavis-Alert: BAD HEADER, Header field occurs more than once: "Cc" occurs 4
	times
Message-Id: <20090527180635.008102701@gentwo.org>
User-Agent: quilt/0.46-1
Date: Wed, 27 May 2009 13:46:58 -0400
From: cl@linux-foundation.org
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Cc: mingo@elte.hu
Cc: rusty@rustcorp.com.au
Cc: davem@davemloft.net
Subject: [my_cpu_ptr 0/5] Introduce my_cpu_ptr/__my_cpu_ptr
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The problem with per_cpu_ptr(x, smp_processor_id) is that it requires
an array lookup to find the offset for the cpu. Processors typically
have the offset for the current cpu area already in some kind of
(arch dependent) efficiently accessible register or memory location.

We can use the per cpu offset instead of doing the array lookup to speed up the
determination of the address of the percpu variable. This is particularly
significant because these lookups occur in performance critical paths
of the core kernel.

This optimization is a prerequiste to the introduction of per processor
atomic operations for the core code. Atomic per processor operations
implicitly do the offset calculation to the current per cpu area in a
single instruction. The locations touched by this patchset are potential
candidates for atomic per cpu operations.

The patchset does not cover arch code nor exotic cases where the current
cpu is determined before the call into a function.

-- 
