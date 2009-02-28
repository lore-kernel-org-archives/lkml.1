Return-Path: <linux-kernel-owner+w=401wt.eu-S1754761AbZB1L3e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761AbZB1L3e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 06:29:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753027AbZB1L3Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 06:29:25 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:9052 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987AbZB1L3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 06:29:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mJzYrWpmT5a5XXN77Gp60gPsAUnEjnRHNNShwb8agYD1ruxIE5F2juCg6DUGURyDYG
         LBbbWXFGOI0JRnGyEJ9CSlmSJjILudbzGXsFoyVpnoGWerBn8Ez+c0n1XRhoR0AzCadT
         Nfuf0n6guHIrigRVEXd0biuM2oEam4jep1it0=
Date: Sat, 28 Feb 2009 14:36:00 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Jeffrey Mogul <Jeff.Mogul@hp.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH] proc: /proc/kpageflags: incorrect arg order in
	kpf_copy_bits()
Message-ID: <20090228113559.GA3449@x200.localdomain>
References: <200902280156.n1S1udEL014057@pobox-pa.hpl.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902280156.n1S1udEL014057@pobox-pa.hpl.hp.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 27, 2009 at 05:56:39PM -0800, Jeffrey Mogul wrote:
> The code in fs/proc/page.c that implements /proc/kpageflags has

Already fixed in mainline:

commit e07a4b9217d1e97d2f3a62b6b070efdc61212110
Author: Helge Bahmann <helge.bahmann@secunet.com>
Date:   Fri Feb 20 16:24:12 2009 +0300

    proc: fix PG_locked reporting in /proc/kpageflags
    
    Expr always evaluates to zero.
    
    Cc: Matt Mackall <mpm@selenic.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>

diff --git a/fs/proc/page.c b/fs/proc/page.c
index 767d95a..2d13451 100644
--- a/fs/proc/page.c
+++ b/fs/proc/page.c
@@ -107,7 +107,7 @@ static ssize_t kpageflags_read(struct file *file, char __user *buf,
 		else
 			kflags = ppage->flags;
 
-		uflags = kpf_copy_bit(KPF_LOCKED, PG_locked, kflags) |
+		uflags = kpf_copy_bit(kflags, KPF_LOCKED, PG_locked) |
 			kpf_copy_bit(kflags, KPF_ERROR, PG_error) |
 			kpf_copy_bit(kflags, KPF_REFERENCED, PG_referenced) |
 			kpf_copy_bit(kflags, KPF_UPTODATE, PG_uptodate) |
