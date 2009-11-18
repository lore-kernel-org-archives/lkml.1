Return-Path: <linux-kernel-owner+w=401wt.eu-S1752992AbZKRWeE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752992AbZKRWeE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 17:34:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752532AbZKRWeE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 17:34:04 -0500
Received: from casper.infradead.org ([85.118.1.10]:58751 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbZKRWeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 17:34:03 -0500
Date: Wed, 18 Nov 2009 20:33:41 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Roland McGrath <roland@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 3/4] perf symbols: Record the build_ids of kernel
	modules too
Message-ID: <20091118223341.GC14014@ghostprotocols.net>
References: <1258582853-8579-1-git-send-email-acme@infradead.org> <1258582853-8579-2-git-send-email-acme@infradead.org> <1258582853-8579-3-git-send-email-acme@infradead.org> <20091118222910.8F6F51983@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091118222910.8F6F51983@magilla.sf.frob.com>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Nov 18, 2009 at 02:29:10PM -0800, Roland McGrath escreveu:
> > +		snprintf(name, sizeof(name),
> > +			 "/sys/module/%s/notes/.note.gnu.build-id", line);
> 
> The arch linker script for .ko's is free to fold notes into a single
> section with a different name or suchlike, and maybe future ones will.  So
> it's not pedantically kosher to assume the name of the section rather than
> just looking at all the /sys/module/%s/notes/* files present until you find
> NT_GNU_BUILD_ID.  (In practice there is probably only ever one file there
> to look at, but you never know.)

Ahah! That seems to explain why the kernel one is "notes" while the
modules's are ".note.gnu.build-id"! I'll cook a super-dupa-careful
cooker follow on patch to get that right, thanks again!

- Arnaldo
