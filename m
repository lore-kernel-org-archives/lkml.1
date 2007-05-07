Return-Path: <linux-kernel-owner+w=401wt.eu-S967164AbXEGWkK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967164AbXEGWkK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 18:40:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967157AbXEGWkG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 18:40:06 -0400
Received: from canuck.infradead.org ([209.217.80.40]:60254 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967154AbXEGWj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 18:39:59 -0400
Subject: Re: [PATCH 1/3] kbuild: complain about missing system calls.
From: David Woodhouse <dwmw2@infradead.org>
To: Tony Luck <tony.luck@intel.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, Andrew Morton <akpm@linux-foundation.org>,
       Kees Cook <kees@outflux.net>, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <12c511ca0705071529w38f71b09je0d9b460c7bc3025@mail.gmail.com>
References: <20070319205623.299d0378.akpm@linux-foundation.org>
	 <20070320103151.f65c81b6.randy.dunlap@oracle.com>
	 <20070320192016.GC22797@outflux.net>
	 <20070320214714.0e584cd4.akpm@linux-foundation.org>
	 <20070321221905.GA22623@uranus.ravnborg.org>
	 <20070321222236.GB22623@uranus.ravnborg.org>
	 <12c511ca0705071529w38f71b09je0d9b460c7bc3025@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 07 May 2007 23:39:35 +0100
Message-Id: <1178577575.11851.242.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7.dwmw2.2) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-05-07 at 15:29 -0700, Tony Luck wrote:
> On 3/21/07, Sam Ravnborg <sam@ravnborg.org> wrote:
> > Most system calls seem to get added to i386 first. This patch
> > automatically generates a warning for any new system call which is
> > implemented on i386 but not the architecture currently being compiled.
> 
> This is now upstream, and so I see a bunch of warnings for every ia64
> build.  Some of them are real, I need to add some syscalls, but there
> are a few bogus ones because ia64 chose different names (e.g. we have
> a sys_clone() that glibc uses to implement fork() and vfork()).
> 
> Just checking that the right way for me to shut checksyscalls.sh up is
> to add:
> 
> #define __IGNORE_fork
> #define __IGNORE_vfork
> 
> etc. to include/asm-ia64/unistd.h for each of the bogus ones.  Or is there
> some other preferred mechanism?

You could add them to scripts/checksyscalls.sh itself -- I think it's
fairly unlikely that those are syscalls which a new arch port is going
to 'forget' :)

-- 
dwmw2

