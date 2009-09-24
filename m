Return-Path: <linux-kernel-owner+w=401wt.eu-S1753519AbZIXOmr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519AbZIXOmr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 10:42:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753481AbZIXOmp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 10:42:45 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:48091 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753492AbZIXOmo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 10:42:44 -0400
X-Greylist: delayed 2108 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Sep 2009 10:42:44 EDT
Message-Id: <20090924132626.485545323@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 24 Sep 2009 09:26:26 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: [patch 00/12] Immediate Values
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Thu, 24 Sep 2009 14:07:31 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Here is an updated version of the immediate values, applying to current tip.

[impact: data-cache optimization]

The main benefit of this infrastructure is to encode read-often variables into
the instruction stream. It can benefit to tracepoints by replacing the memory
load by an immediate value instruction. There is still room for improvement
through: an effort to provide static jump patching is ongoing, involving the
kernel and gcc communities.

Even then, the immediate values have their niche: when a value (rather than a
branch selection) is read often on fast-paths, the immediate value
infrastructure can encode these in the instruction stream without any d-cache
cost.

Two sample users are provided: prof_on from the scheduler code and tracepoints.
Feel free to merge/drop any of these.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
