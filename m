Return-Path: <linux-kernel-owner+w=401wt.eu-S1752449AbZLaLJA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752449AbZLaLJA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 06:09:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752158AbZLaLJA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 06:09:00 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:39659 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752091AbZLaLI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 06:08:59 -0500
Date: Thu, 31 Dec 2009 09:08:44 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mackerras <paulus@samba.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] perf tools: adjust symbol address
Message-ID: <20091231110843.GF2384@ghostprotocols.net>
References: <4B3AC5CD.1000502@cn.fujitsu.com>
 <4B3AC69F.4070901@cn.fujitsu.com>
 <20091230131016.GC2956@ghostprotocols.net>
 <4B3C1397.8040307@cn.fujitsu.com>
 <20091231102938.GD2384@ghostprotocols.net>
 <4B3C819D.9000809@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B3C819D.9000809@cn.fujitsu.com>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Dec 31, 2009 at 06:49:01PM +0800, Xiao Guangrong escreveu:
> 
> 
> Arnaldo Carvalho de Melo wrote:
> 
> >> vmlinux* not know it's relocation or not, and we just handle the _specific_
> >> kernel at the time which match the current system. 
> > 
> > 'perf record' in one machine + 'perf report' in another should be
> > possible.
> >  
> 
> Yeah, but current code not support this since it not record kernel build-id in
> perf.data while 'perf record' works, maybe you can fix it.

Huh? Checking...

[root@ana tmp]# perf record -a -f sleep 1s
[ perf record: Woken up 3 times to write data ]
[ perf record: Captured and wrote 0.330 MB perf.data (~14404 samples) ]
[root@ana tmp]# perf buildid-list | grep kallsyms
a3301c8755357466e39d71b46e8f69aecf83c0e8 [kernel.kallsyms]
a3301c8755357466e39d71b46e8f69aecf83c0e8 [kernel.kallsyms]
[root@ana tmp]#

In fact there is a bug, but the bug is either in 'perf buildid-list'
showing it twice or it being recorded twice in 'perf record'.

- Arnaldo
