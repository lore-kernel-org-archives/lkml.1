Return-Path: <linux-kernel-owner+w=401wt.eu-S1751374AbXBVDgL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751374AbXBVDgL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 22:36:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751493AbXBVDgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 22:36:11 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:41408 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbXBVDgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 22:36:10 -0500
Date: Thu, 22 Feb 2007 03:35:56 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Roland McGrath <roland@redhat.com>
Cc: Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.20-mm1: PTRACE=y, PROC_FS=n compile error
Message-ID: <20070222033556.GA9027@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Roland McGrath <roland@redhat.com>, Adrian Bunk <bunk@stusta.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <20070220000816.GM13958@stusta.de> <20070221101510.C48121800E4@magilla.sf.frob.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070221101510.C48121800E4@magilla.sf.frob.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 21, 2007 at 02:15:10AM -0800, Roland McGrath wrote:
> > This causes the following compile error with CONFIG_PTRACE=y, 
> > CONFIG_PROC_FS=n:
> 
> Bah.  I moved ptrace_may_attach to fs/proc/base.c so that CONFIG_PTRACE=n
> could just omit kernel/ptrace.c entirely and still get the function for
> fs/proc/base.c to use (and because that uses it many more times than ptrace
> does).  I'd forgotten that procfs could be disabled, since noone ever does.
> 
> What do people suggest?  It's not a very big function.

Put it into some other place in kernel/ that's always build, e.g.
kernel/sys.c and while you;re at it please give it a name that doesn't
include the word ptrace.

I remember mentioning that in my long utrace review mail.. :)
