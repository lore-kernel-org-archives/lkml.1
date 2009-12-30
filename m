Return-Path: <linux-kernel-owner+w=401wt.eu-S1752155AbZL3V7L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752155AbZL3V7L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 16:59:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752085AbZL3V7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 16:59:09 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:42469 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989AbZL3V7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 16:59:07 -0500
Date: Wed, 30 Dec 2009 19:58:47 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mackerras <paulus@samba.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       linux-kernel@vger.kernel.org, James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 1/3] x86: record relocation offset
Message-ID: <20091230215847.GB2384@ghostprotocols.net>
References: <4B3AC5CD.1000502@cn.fujitsu.com>
 <4B3AC629.4030504@cn.fujitsu.com>
 <20091230131518.GD2956@ghostprotocols.net>
 <4B3BADDA.8040102@zytor.com>
 <20091230203936.GA2384@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091230203936.GA2384@ghostprotocols.net>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Dec 30, 2009 at 06:39:36PM -0200, Arnaldo Carvalho de Melo escreveu:
> Em Wed, Dec 30, 2009 at 11:45:30AM -0800, H. Peter Anvin escreveu:
> > The kernel already knows where it is loaded -- obviously, by sheer
> > necessity -- and knows how it was itself configured, and as such we
> > can do this calculation in C code without modifying boot_params or
> > the early bootstrap.
> 
> Problem is that at 'perf record' time we may not have access to the
> vmlinux file, and thus not be able to figure out the relocation applied
> in that boot.
> 
> Then, at a later time, and possibly on another machine, on another arch,
> we try to map back IPs to symbols, the /proc/kallsyms is completely
> unrelated and we now have a vmlinux unrelocated...
> 
> So we need a way to get the relocation applied at 'perf record' time and
> encode it in the perf.data header. Ideas about how to do that?

Well, I guess we could do the _stext trick again, storing its value,
taken from /proc/kallsyms, into the perf.data header, then figuring out
the relocation by looking at its value in the vmlinux symtab.

There were concerns in the past about relying on _stext, IIRC, James?

- Arnaldo
