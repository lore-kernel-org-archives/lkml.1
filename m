Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199Ab0CDAok (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 19:44:40 -0500
Received: from mga14.intel.com ([143.182.124.37]:16166 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752306Ab0CDAod (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 19:44:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,577,1262592000"; 
   d="scan'208";a="250590134"
Date: Thu, 4 Mar 2010 08:44:25 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "H. Peter Anvin" <hpa@linux.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sachin Sant <sachinp@in.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Ian Campbell <ian.campbell@citrix.com>,
       Alok Kataria <akataria@vmware.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Pasi =?utf-8?B?S8Okcmtrw6RpbmVu?= <pasik@iki.fi>
Subject: Re: [GIT PULL] x86/mm fixes
Message-ID: <20100304004425.GA8035@localhost>
References: <201003020010.o220Ax3Z025848@hera.kernel.org> <alpine.LFD.2.00.1003021038410.3616@localhost.localdomain> <4B8D67A4.8080602@zytor.com> <20100303020845.GD6477@localhost> <alpine.LFD.2.00.1003030909590.3627@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1003030909590.3627@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 04, 2010 at 01:10:46AM +0800, Linus Torvalds wrote:
> 
> 
> On Wed, 3 Mar 2010, Wu Fengguang wrote:
> > 
> > Anyway I just hacked /usr/share/quilt/refresh to automatically run the
> > kernel style checker:
> > 
> > # wfg: check for kernel coding style
> > if [ -x scripts/checkpatch.pl ]; then
> >         scripts/checkpatch.pl $patch_file
> > fi
> 
> It's probably sensible to check things, but do remember that some of the 
> things checkpatch warns about are better left the way they are, rather 
> than make the code uglier just to make checkpatch happy.

OK. Here is the simple patch for quilt. I guess it may be hardly
acceptable for quilt upstream, so only intends to share it here.

Thanks,
Fengguang
---

--- /usr/share/quilt/refresh.orig	2010-03-04 08:38:27.000000000 +0800
+++ /usr/share/quilt/refresh	2010-03-04 08:38:29.000000000 +0800
@@ -265,6 +265,12 @@ fi
 
 patch_file=$(patch_file_name $patch)
 
+# check for kernel coding style
+# Linus: please treat its warning as recommendation instead of requirement
+if [ -x scripts/checkpatch.pl ]; then
+	scripts/checkpatch.pl -q $patch_file
+fi
+
 trap "" SIGINT
 
 tmp_result=$(gen_tempfile) || die 1
