Return-Path: <linux-kernel-owner+w=401wt.eu-S1752395Ab0AHEyj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752395Ab0AHEyj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 23:54:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751633Ab0AHEyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 23:54:39 -0500
Received: from mail-yx0-f188.google.com ([209.85.210.188]:63089 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449Ab0AHEyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 23:54:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=mfepdB3FcU8uUmPoN/64YbTwJsY/P8Bww8fckfNzy0lhPvb86uDVcqqqo+W/XcGH5/
         mCoySBCUMrGIgbbGrgv3D5IkZOV3jkGL8wnvx+isXePXxZkAC7yNgiiSLMhIr1qtRLOt
         usmN1qCog3KEPTQgr8VX+LWnHpZwcdXN+yjmM=
MIME-Version: 1.0
In-Reply-To: <1262925925.27700.15.camel@adam-desktop>
References: <1262925925.27700.15.camel@adam-desktop>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Thu, 7 Jan 2010 23:54:18 -0500
Message-ID: <8bd0f97a1001072054y798833dftdb1b2a744ad52969@mail.gmail.com>
Subject: Re: [PATCH] Ftrace: irqsoff tracer may cause stack overflow
To: Li Yi <yi.li@analog.com>, Arnd Bergmann <arnd@arndb.de>
Cc: rostedt@goodmis.org, linux-kernel@vger.kernel.org,
       uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 7, 2010 at 23:45, Li Yi wrote:
> "irqsoff" tracer may cause stack overflow on architectures using
> asm-generic/atomic.h, due to recursive invoking of, e.g.
> trace_hardirqs_off().
>
> trace_hardirqs_off() -> start_critical_timing() -> atomic_inc() ->
> atomic_add_return() -> local_irq_save() -> trace_hardirqs_off()
>
> Signed-off-by: Yi Li <yi.li@analog.com>
> ---
>  include/asm-generic/atomic.h |   12 ++++++------

Arnd is watching over asm-generic/ atm

> @@ -60,11 +60,11 @@ static inline int atomic_add_return(int i, atomic_t
> *v)
> @@ -82,11 +82,11 @@ static inline int atomic_sub_return(int i, atomic_t
> *v)
> @@ -139,9 +139,9 @@ static inline void atomic_clear_mask(unsigned long
> mask, unsigned long *addr)

looks like your mailer has line wrapping problems ... might want to
fix that.  maybe just find a smtp server in ADI shanghai's office to
send to and use sendemail.smtpersver in your ~/.gitconfig ?
-mike
