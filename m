Return-Path: <linux-kernel-owner+w=401wt.eu-S1752335AbZKRW3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752335AbZKRW3Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 17:29:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752018AbZKRW3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 17:29:23 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:35959 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652AbZKRW3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 17:29:23 -0500
Date: Wed, 18 Nov 2009 20:29:11 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Roland McGrath <roland@redhat.com>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 4/4] perf symbols: Capture the running kernel buildid
	too
Message-ID: <20091118222911.GF18283@ghostprotocols.net>
References: <1258582853-8579-1-git-send-email-acme@infradead.org> <1258582853-8579-2-git-send-email-acme@infradead.org> <1258582853-8579-3-git-send-email-acme@infradead.org> <1258582853-8579-4-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258582853-8579-4-git-send-email-acme@infradead.org>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Nov 18, 2009 at 08:20:53PM -0200, Arnaldo Carvalho de Melo escreveu:
> From: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> [root@doppio linux-2.6-tip]# perf record -a -f sleep 3s ; perf
> buildid-list | grep vmlinux
> [ perf record: Woken up 1 times to write data ]
> [ perf record: Captured and wrote 0.171 MB perf.data (~7489 samples) ]
> 18e7cc53db62a7d35e9d6f6c9ddc23017d38ee9a vmlinux
> [root@doppio linux-2.6-tip]#
> 
> Several refactorings were needed so that we can have simmetry between
> dsos__load_modules and dsos__load_kernel, i.e. those functions will
> respectively create and add to the dsos list the loaded modules and
> kernel, with its buildids, but not load its symbols. That is something
> the subcomands that need will have to call dso__load_kernel_sym(), just
> like we do with modules with dsos__load_module_sym()/dso__load_module_sym().

And that can even be deferred to when we get a kernel sample, thinking
about 'perf top --hide_kernel_symbols', this makes a lot of sense 8-)

Tomorrow tho.

- Arnaldo
