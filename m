Return-Path: <linux-kernel-owner+w=401wt.eu-S1752747AbYKSHIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747AbYKSHIU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 02:08:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751737AbYKSHIM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 02:08:12 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:42941 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538AbYKSHIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 02:08:11 -0500
Date: Wed, 19 Nov 2008 07:08:06 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Bryan Wu <cooloney@kernel.org>, linux-kernel@vger.kernel.org,
       Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: [PATCH] asm/generic: fix bug - kernel fails to build when
	enable some common audit code on Blackfin
Message-ID: <20081119070806.GV28946@ZenIV.linux.org.uk>
References: <1226991829-30641-1-git-send-email-cooloney@kernel.org> <20081118223308.396ec63b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081118223308.396ec63b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2008 at 10:33:08PM -0800, Andrew Morton wrote:
> > @@ -1,6 +1,8 @@
> >  #include <asm-generic/audit_dir_write.h>
> >  __NR_acct,
> > +#ifdef __NR_swapon
> >  __NR_swapon,
> > +#endif
> >  __NR_quotactl,
> >  __NR_truncate,
> >  #ifdef __NR_truncate64
> 
> hrm.
> 
> Should blackfin define __NR_swapon instead?  afacit
> include/asm/unistd.h is an exported-to-userspace header, so the
> architecture should export __NR_swapon to prevent userspace build
> failures?

Not in the absense of syscall in question.  Patch applied, will push the
tree tomorrow.
