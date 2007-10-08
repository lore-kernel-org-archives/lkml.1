Return-Path: <linux-kernel-owner+w=401wt.eu-S1755202AbXJHHHi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202AbXJHHHi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 03:07:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753199AbXJHHH3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 03:07:29 -0400
Received: from rv-out-0910.google.com ([209.85.198.187]:62155 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535AbXJHHH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 03:07:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:content-transfer-encoding:in-reply-to:user-agent;
        b=M3DQyVKvbFOmL4fbDjO+7D1yRLIsXkDygdvmyX6am+R0kTldtIrax8Wv1elaY21gsVLo7MP9+CoSoi9wxtTz2+kuAepnLcAtkA0/Sy/aDEg3k5okzW7JLvpSuAA0XK9PEG+zxmr/bsspidb9tCCeBkFNtjWm4K9LQ5lPPihYCZU=
Date: Mon, 8 Oct 2007 15:02:53 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, gregkh@suse.de
Subject: Re: [PATCH] param_sysfs_builtin memchr argument fix
Message-ID: <20071008070253.GD2455@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <20071008065009.GA2862@darkstar.te-china.tietoenator.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20071008065009.GA2862@darkstar.te-china.tietoenator.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 08, 2007 at 02:50:10PM +0800, Dave Young wrote:
>If memchr argument is longer than strlen(kp->name), there will be some
>weird result. 
>
>Signed-off-by: Dave Young <hidave.darkstar@gmail.com> 
>
>---
>params.c |   10 ++++++++--
>1 file changed, 8 insertions(+), 2 deletions(-)


Hmm, you used diffstat without -p1?


>
>diff -upr linux/kernel/params.c linux.new/kernel/params.c
>--- linux/kernel/params.c	2007-10-08 14:30:06.000000000 +0800
>+++ linux.new/kernel/params.c	2007-10-08 14:31:22.000000000 +0800
>@@ -592,15 +592,21 @@ static void __init param_sysfs_builtin(v
> 
> 	for (i=0; i < __stop___param - __start___param; i++) {
> 		char *dot;
>+		int kplen;
> 
> 		kp = &__start___param[i];
>+		kplen = strlen(kp->name);

strlen() returns a size_t value, which is unsigned. ;)

> 
> 		/* We do not handle args without periods. */
>-		dot = memchr(kp->name, '.', MAX_KBUILD_MODNAME);
>+		if (kplen > MAX_KBUILD_MODNAME) {
>+			DEBUGP("kernel parameter %s is too long\n", kp->name);
>+			continue;
>+		}
>+		dot = memchr(kp->name, '.', kplen);
> 		if (!dot) {
> 			DEBUGP("couldn't find period in %s\n", kp->name);
> 			continue;
>-		}
>+		} 

You add an extra whitespace in the end of the line.


-- 
I try to say goodbye and I choke.
I try to walk away and I stumble.
I play it off, but I’m dreaming of you.
Though I try to hide it, it’s clear that
my world crumbles when you are not here.
