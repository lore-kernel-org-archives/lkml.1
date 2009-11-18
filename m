Return-Path: <linux-kernel-owner+w=401wt.eu-S1753107AbZKRW3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753107AbZKRW3c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 17:29:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752697AbZKRW3b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 17:29:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55155 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752114AbZKRW3Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 17:29:24 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
X-Fcc: ~/Mail/linus
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 3/4] perf symbols: Record the build_ids of kernel modules too
In-Reply-To: Arnaldo Carvalho de Melo's message of  Wednesday, 18 November 2009 20:20:52 -0200 <1258582853-8579-3-git-send-email-acme@infradead.org>
References: <1258582853-8579-1-git-send-email-acme@infradead.org>
	<1258582853-8579-2-git-send-email-acme@infradead.org>
	<1258582853-8579-3-git-send-email-acme@infradead.org>
Emacs: Lovecraft was an optimist.
Message-Id: <20091118222910.8F6F51983@magilla.sf.frob.com>
Date: Wed, 18 Nov 2009 14:29:10 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +		snprintf(name, sizeof(name),
> +			 "/sys/module/%s/notes/.note.gnu.build-id", line);

The arch linker script for .ko's is free to fold notes into a single
section with a different name or suchlike, and maybe future ones will.  So
it's not pedantically kosher to assume the name of the section rather than
just looking at all the /sys/module/%s/notes/* files present until you find
NT_GNU_BUILD_ID.  (In practice there is probably only ever one file there
to look at, but you never know.)


Thanks,
Roland
