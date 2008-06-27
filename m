Return-Path: <linux-kernel-owner+w=401wt.eu-S1762847AbYF0Un5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762847AbYF0Un5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 16:43:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753815AbYF0Unf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 16:43:35 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:15427 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758114AbYF0Und (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 16:43:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=EUawR8xx58H2WqdrIbIzmyCbBSFL14Dyha6npiuoXy37EwvrO7Ope7Wmc86S1RhP/P
         LXIrlfa22DCf7adWoFkPJFuiGqoyLdkImOL+i6ggfjuAyPlD/e1RKu+6PKm8S7WBsyjm
         je3KaQq/UhGFlyqsItJftDDGydZ3I7YNiNvHE=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 4/5 v2] x86 boot: show pfn addresses in hex not decimal in some kernel info printks
Date: Fri, 27 Jun 2008 22:43:41 +0200
User-Agent: KMail/1.8.2
Cc: Johannes Berg <johannes@sipsolutions.net>, Paul Jackson <pj@sgi.com>,
       hpa@zytor.com, yhlu.kernel@gmail.com, akpm@linux-foundation.org,
       mingo@elte.hu, tglx@linutronix.de, steiner@sgi.com, travis@sgi.com,
       linux-kernel@vger.kernel.org, ying.huang@intel.com, andi@firstfloor.org
References: <20080622142151.5591.4139.sendpatchset@polaris-admin.engr.sgi.com> <1214406026.21847.25.camel@johannes.berg> <alpine.LFD.1.10.0806250813030.4733@hp.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0806250813030.4733@hp.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806272243.41664.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 June 2008 17:19, Linus Torvalds wrote:
> The problem is that right now we absolutely _do_ rely on gcc checking the 
> string, and as such we're forced to use standard patterns, and standard 
> patterns _only_.

Can we have alternative printk?

 asmlinkage int printk(const char * fmt, ...)
         __attribute__ ((format (printf, 1, 2))) __cold;
+asmlinkage int custom_printk(const char * fmt, ...) __cold asm ("printk");

There you go. custom_printk() will not be checked by gcc.
No runtime overhead.

> And that means that %M isn't an option, but also that if  
> we want symbolic names we'd have to use %p, and not some extension.
> 
> But once you drop the 'standard patterns' requirement, I do think you 
> should drop it _entirely_, and not just extend it with some pissant 
> single-character unreadable mess.

It still makes sense to have some more common ones as single char
for size reasons.
--
vda
