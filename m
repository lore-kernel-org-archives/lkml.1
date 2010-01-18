Return-Path: <linux-kernel-owner+w=401wt.eu-S1753521Ab0ARKRY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521Ab0ARKRY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 05:17:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752665Ab0ARKRW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 05:17:22 -0500
Received: from cantor.suse.de ([195.135.220.2]:49663 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752397Ab0ARKRW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 05:17:22 -0500
Date: Mon, 18 Jan 2010 11:17:19 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
       Linus Walleij <linus.ml.walleij@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>,
       Linus Walleij <linus.walleij@stericsson.com>,
       Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: linux-next: trivial tree build failure
In-Reply-To: <20100118200126.0176773d.sfr@canb.auug.org.au>
Message-ID: <alpine.LNX.2.00.1001181115540.30977@pobox.suse.cz>
References: <20100118162412.9944c571.sfr@canb.auug.org.au> <63386a3d1001180036h2bad24cas8c407edde729678e@mail.gmail.com> <20100118200126.0176773d.sfr@canb.auug.org.au>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jan 2010, Stephen Rothwell wrote:

> Hi Jiri,
> 
> Today's linux-next build (x86_64_allmodconfig) failed like this:
> 
> drivers/mfd/ab3100-otp.c: In function 'show_otp':
> drivers/mfd/ab3100-otp.c:101: error: dereferencing pointer to incomplete type
> drivers/mfd/ab3100-otp.c:104: error: implicit declaration of function 'seq_printf'
> drivers/mfd/ab3100-otp.c:102: warning: unused variable 'err'
> drivers/mfd/ab3100-otp.c: In function 'ab3100_otp_open':
> drivers/mfd/ab3100-otp.c:116: error: implicit declaration of function 'single_open'
> drivers/mfd/ab3100-otp.c:116: error: 'ab3100_otp_show' undeclared (first use in this function)
> drivers/mfd/ab3100-otp.c: At top level:
> drivers/mfd/ab3100-otp.c:121: error: 'seq_read' undeclared here (not in a function)
> drivers/mfd/ab3100-otp.c:122: error: 'seq_lseek' undeclared here (not in a function)
> drivers/mfd/ab3100-otp.c:123: error: 'single_release' undeclared here (not in a function)
> drivers/mfd/ab3100-otp.c: In function 'ab3100_otp_init_debugfs':
> drivers/mfd/ab3100-otp.c:134: error: 'err' undeclared (first use in this function)
> drivers/mfd/ab3100-otp.c: In function 'ab3100_otp_exit_debugfs':
> drivers/mfd/ab3100-otp.c:140: error: implicit declaration of function 'debugfs_remove_file'
> 
> Exposed by commit 8dcafdf0475eb4633401d1f0bf0e0d35e4ebb9d5
> "CONFIG_DEBUG_FS wrongly written as CONFIG_DEBUGFS".

Hmm, mea culpa. I have noticed the build failure myself and notified patch 
author about that, but forgot to drop the patch from my tree afterwards. 
Sorry.

On Mon, 18 Jan 2010, Linus Walleij wrote:

> 2010/1/18 Stephen Rothwell <sfr@canb.auug.org.au>:
> 
> > Exposed by commit 8dcafdf0475eb4633401d1f0bf0e0d35e4ebb9d5
> > "CONFIG_DEBUG_FS wrongly written as CONFIG_DEBUGFS".
> > I have reverted that commit for today.
> 
> I have sent a proper patch to Sam last night, that fix the #ifdef and
> makes the code work.

I have dropped the patch from my tree now, and I am not carrying any 
replacement as of now.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
