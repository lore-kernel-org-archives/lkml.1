Return-Path: <linux-kernel-owner+w=401wt.eu-S932888AbZJFSGd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932888AbZJFSGd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 14:06:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932696AbZJFSGc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 14:06:32 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60285 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932635AbZJFSGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 14:06:32 -0400
Date: Tue, 6 Oct 2009 14:05:51 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       lkml <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] perf build questions
Message-ID: <20091006180551.GB11702@bombadil.infradead.org>
References: <20091005131729.78444bfb.randy.dunlap@oracle.com> <1254818939.21044.120.camel@laptop> <20091006102626.8b4f7810.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091006102626.8b4f7810.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 06, 2009 at 10:26:26AM -0700, Randy Dunlap wrote:
> $ make NO_64BIT=1 all
> $ file perf
> perf: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), for GNU/Linux 2.6.4, dynamically linked (uses shared libs), not stripped
> 
> 
> Shouldn't that be a 32-bit executable for i386?
> Am I confused?  (you don't have to answer that)
> 

Are you running a 32-bit userspace, with x86_64 kernel? Or running
x86_64 userspace as well and trying to crossbuild for i386? In the
latter case NO_64BIT won't do what you hope, it's to avoid trying to
build a 64-bit binary in the former case.

You could force -m32 into CFLAGS in the second case, but unless you have
the proper i386 bi-arch toolchain installed (glibc, etc.) it likely
won't build...

regards, Kyle
