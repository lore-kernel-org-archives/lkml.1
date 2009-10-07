Return-Path: <linux-kernel-owner+w=401wt.eu-S1758606AbZJGGoq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758606AbZJGGoq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 02:44:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758507AbZJGGop
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 02:44:45 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47391 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757075AbZJGGon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 02:44:43 -0400
Subject: Re: [RFC][PATCH] perf tools: Merge trace.info content into
 perf.data
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20091006213643.GA5343@nowhere>
References: <20091006213643.GA5343@nowhere>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 07 Oct 2009 08:47:30 +0200
Message-Id: <1254898050.26976.146.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-06 at 23:36 +0200, Frederic Weisbecker wrote:
> Hi,
> 
> Here is an attempt to remove the trace.info file.
> It works well for me, the reason for it to be an RFC
> is that I have doubts about the backward compatibility.
> 
> A file created by perf after his patch is unsupported
> by previous version because the size of the headers have
> increased.
> 
> That said, it's two new fields that have been added in
> the end of the headers, and those could be ignored by
> previous versions if they just handled the dynamic header
> size and then ignore the unknow part. The offsets guarantee
> the compatibility.
> But previous versions handle the header size using its
> static size, not dynamic, then it's not backward compatible.
> 
> Anyway, I'm not sure exactly how to handle that.

If we're still able to read 'regular' old perf.data files after this.
That is, allow to read short headers and assume the tail is 0 we'll be
good. (this will break trace files that rely on the now removed
trace.info, but that's unavoidable I guess).

So backwards compatible, but no fwd compat for the old perf.
