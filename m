Return-Path: <linux-kernel-owner+w=401wt.eu-S1757210AbZKWLOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757210AbZKWLOp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 06:14:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753791AbZKWLOo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 06:14:44 -0500
Received: from ozlabs.org ([203.10.76.45]:56038 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752588AbZKWLOo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 06:14:44 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19210.28321.247956.956374@cargo.ozlabs.ibm.com>
Date: Mon, 23 Nov 2009 22:14:41 +1100
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arjan van de Ven <arjan@infradead.org>,
       "Michael S. Tsirkin" <mst@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf: use default compiler mode by default
In-Reply-To: <20091123065548.GE31758@elte.hu>
References: <20091122121335.GA24254@redhat.com>
	<20091122091338.4a9d772f@infradead.org>
	<20091123065548.GE31758@elte.hu>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar writes:

> I'd still like to hear back from Paulus whether PowerPC is affected 
> negatively - IIRC it was PowerPC where we got the -m64 from originally.

It seems that a 32-bit perf now works on a 64-bit kernel on powerpc,
so I don't have any hard objection to this patch.  (For some reason,
perf top isn't getting any samples, so I'll have to chase that.)

Many distros on powerpc default to 32-bit userspace on 64-bit
machines, since that has a slight performance and size benefit for
most programs.  I expect perf is better as a 64-bit binary, since it
does a lot of 64-bit arithmetic, so users of those distros on 64-bit
machines would need to do "make EXTRA_CFLAGS=-m64".

Paul.
