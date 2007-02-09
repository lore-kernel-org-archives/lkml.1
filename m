Return-Path: <linux-kernel-owner+w=401wt.eu-S1946541AbXBIRfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946541AbXBIRfi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 12:35:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946620AbXBIRfi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 12:35:38 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:46258 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946541AbXBIRfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 12:35:37 -0500
Subject: Re: -mm merge plans for 2.6.21
From: David Woodhouse <dwmw2@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, drepper@redhat.com
In-Reply-To: <20070208150710.1324f6b4.akpm@linux-foundation.org>
References: <20070208150710.1324f6b4.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 09 Feb 2007 17:35:35 +0000
Message-Id: <1171042535.29713.96.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-02-08 at 15:07 -0800, Andrew Morton wrote:
> lutimesat-simplify-utime2.patch
> lutimesat-extend-do_utimes-with-flags.patch
> lutimesat-actual-syscall-and-wire-up-on-i386.patch
> 
>  Do we want this?  Ulrich says so.  Will merge, I guess.

I would strongly recommend that in the general case, you don't merge new
system calls unless the corresponding compat_ system call is
implemented.

This makes sure that people adding system calls will design the API for
the new system call appropriately, rather than trying to implement
compat support as an afterthought and only then realising that they wish
the original had been done differently. We've seen examples of this
where it would have been _trivial_ to adjust the API slightly to make
compat syscalls a non-issue, but the developer just didn't _think_ about
it until the syscall was set in stone.

This new system call seems to need compat_ support but lacks it, so I
would suggest you shouldn't merge it just yet.

-- 
dwmw2

