Return-Path: <linux-kernel-owner+w=401wt.eu-S1759251AbZGHEt0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759251AbZGHEt0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 00:49:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752479AbZGHEtT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 00:49:19 -0400
Received: from mail-px0-f181.google.com ([209.85.216.181]:47312 "EHLO
	mail-px0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793AbZGHEtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 00:49:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=b5bfN/d9znRjd4uymvilY3NEbjR8hwBaaIHQ96Gwh7If4o9BG99hfzdennNS2VevWm
         TP80AtOBWUYicd1+6d5/BZXjk9JuKuiIVZMPrkH3fd3uJncJEPiEap1+rb/kqtH6h8A4
         nO57wWOtvNPagb3Ck9NKUHilFDe1ti1ADOjds=
Date: Wed, 8 Jul 2009 12:51:26 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: Kees Cook <kees.cook@canonical.com>
Cc: linux-kernel@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH] proc: fix reported unit for RLIMIT_CPU
Message-ID: <20090708045126.GB5917@cr0.nay.redhat.com>
References: <20090708042331.GT11156@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090708042331.GT11156@outflux.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 07, 2009 at 09:23:32PM -0700, Kees Cook wrote:
>/proc/$pid/limits should show RLIMIT_CPU as seconds, which is the unit
>used in kernel/posix-cpu-timers.c:
>
>        unsigned long psecs = cputime_to_secs(ptime);
>        ...
>        if (psecs >= sig->rlim[RLIMIT_CPU].rlim_max) {
>                ...
>                __group_send_sig_info(SIGKILL, SEND_SIG_PRIV, tsk);
>
>Signed-off-by: Kees Cook <kees.cook@canonical.com>


Acked-by: WANG Cong <xiyou.wangcong@gmail.com>

>---
> fs/proc/base.c |    2 +-
> 1 files changed, 1 insertions(+), 1 deletions(-)
>
>diff --git a/fs/proc/base.c b/fs/proc/base.c
>index 3ce5ae9..5891360 100644
>--- a/fs/proc/base.c
>+++ b/fs/proc/base.c
>@@ -461,7 +461,7 @@ struct limit_names {
> };
> 
> static const struct limit_names lnames[RLIM_NLIMITS] = {
>-	[RLIMIT_CPU] = {"Max cpu time", "ms"},
>+	[RLIMIT_CPU] = {"Max cpu time", "seconds"},
> 	[RLIMIT_FSIZE] = {"Max file size", "bytes"},
> 	[RLIMIT_DATA] = {"Max data size", "bytes"},
> 	[RLIMIT_STACK] = {"Max stack size", "bytes"},
>-- 
>1.6.3.3
>
>-- 
>Kees Cook
>Ubuntu Security Team
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/
