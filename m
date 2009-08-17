Return-Path: <linux-kernel-owner+w=401wt.eu-S1756773AbZHQFpP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756773AbZHQFpP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 01:45:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751156AbZHQFpO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 01:45:14 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:1338 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831AbZHQFpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 01:45:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=QpcOYpqrGQP8Qz/0qPJ021oUP1nj2WnBA47zpeOes8oowMUHA+OjY3+wJEB2pkUbkQ
         XmcYLFMfITWR1lQFYa67qljfduc1q9z83zh8Y/pE68sey4ScaAMkE1KoRTXY+8229lJM
         U1BmSCTTHL2pkgJZlmy8kd7dj4XHijg2+QH4U=
Date: Mon, 17 Aug 2009 13:47:32 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: Christian Kujau <lists@nerdbynature.de>
Cc: LKML <linux-kernel@vger.kernel.org>, torvalds@linux-foundation.org
Subject: Re: [PATCH] scripts/ver_linux
Message-ID: <20090817054732.GK5039@cr0.nay.redhat.com>
References: <alpine.DEB.2.01.0908132251000.30417@bogon.housecafe.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.01.0908132251000.30417@bogon.housecafe.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 13, 2009 at 10:57:17PM -0700, Christian Kujau wrote:
>Hi there,
>
>sometimes I'm using scripts/ver_linux to quickly have an overview of my 
>(build-)environment. The output is usually a bit off, since I don't have 
>"kbd" or "console-tools" installed and don't have /sbin:/usr/sbin in my 
>PATH.

Hmm, so probably you are also using a Red Hat distribution?
AFAIK, only some Fedora and RHEL don't have /sbin and /usr/sbin in $PATH.

Anyway, it looks reasonable.

Acked-by: WANG Cong <xiyou.wangcong@gmail.com>

Thanks.



>The patch below makes scripts/ver_linux print a better result, 
>compared to its original output:
>
>-module-init-tools      found
>+module-init-tools      3.4
>+e2fsprogs              1.41.3
>+jfsutils               1.1.12
>+reiserfsprogs          3.6.19
>+reiser4progs           1.0.6
>+xfsprogs               2.9.8
> Linux C Library        2.7
> Procps                 3.2.7
>-Kbd                    loadkeys:
>+Net-tools              1.60
> Sh-utils               6.10
>
>Signed-off-by: Christian Kujau <lists@nerdbynature.de>
>
>--- linux-2.6-git/scripts/ver_linux.orig	2009-08-14 07:47:12.185695350 +0200
>+++ linux-2.6-git/scripts/ver_linux	2009-08-14 07:47:23.642348227 +0200
>@@ -4,6 +4,7 @@
> # /bin /sbin /usr/bin /usr/sbin /usr/local/bin, but it may
> # differ on your system.
> #
>+PATH="$PATH":/sbin:/usr/sbin
> echo 'If some fields are empty or look unusual you may have an old version.'
> echo 'Compare to the current minimal requirements in Documentation/Changes.'
> echo ' '
>@@ -76,7 +77,7 @@ ifconfig --version 2>&1 | grep tools | a
> 
> # Kbd needs 'loadkeys -h',
> loadkeys -h 2>&1 | awk \
>-'(NR==1 && ($3 !~ /option/)) {print "Kbd                   ", $3}'
>+'(NR==1 && ($1 = /^loadkeys/)) {print "Kbd                   ", $3}'
> 
> # while console-tools needs 'loadkeys -V'.
> loadkeys -V 2>&1 | awk \
>
>-- 
>BOFH excuse #17:
>
>fat electrons in the lines
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/
