Return-Path: <linux-kernel-owner+w=401wt.eu-S932235Ab0A0X3w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932235Ab0A0X3w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 18:29:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756421Ab0A0X3v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 18:29:51 -0500
Received: from casper.infradead.org ([85.118.1.10]:35078 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932221Ab0A0X3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 18:29:49 -0500
Date: Wed, 27 Jan 2010 21:29:36 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 4/9] perf session: Create kernel maps in the constructor
Message-ID: <20100127232936.GI12567@ghostprotocols.net>
References: <1264633557-17597-1-git-send-email-acme@infradead.org>
 <1264633557-17597-4-git-send-email-acme@infradead.org>
 <4B60C9A6.10704@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B60C9A6.10704@redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Jan 27, 2010 at 06:17:58PM -0500, Masami Hiramatsu escreveu:
> Arnaldo Carvalho de Melo wrote:
> > From: Arnaldo Carvalho de Melo <acme@redhat.com>
> > 
> > Removing one extra step needed in the tools that need this, fixing a bug
> > in 'perf probe' where this was not being done.
> 
> Thanks,
> BTW, when O_WRONLY should be used? I guess I might misunderstand something
> in builtin-probe.c, and it should use O_RDONLY ...

O_RDONLY only when you have a perf.data file, O_WRONLY was thought for
'perf record', then for tools that want only to do symbol lookup it was
reused...

I think we should have a proper enum and more clearly specify these
semantics, as well as adding a MMAP mode so that we can lift the code
now in perf top somehow.

But for now using O_WRONLY provides what 'perf probe' needs, I guess :-)

- Arnaldo
