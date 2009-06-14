Return-Path: <linux-kernel-owner+w=401wt.eu-S1752622AbZFNGGd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622AbZFNGGd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 02:06:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751321AbZFNGGZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 02:06:25 -0400
Received: from mail-fx0-f206.google.com ([209.85.220.206]:47302 "EHLO
	mail-fx0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbZFNGGY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 02:06:24 -0400
X-Greylist: delayed 431 seconds by postgrey-1.27 at vger.kernel.org; Sun, 14 Jun 2009 02:06:24 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=jd/QnXnz/GZzFlzN/AikfW+S/ArCKxytz/8qklokb5wbsLKjz+Z/yu15nnZMM9CVku
         x8sJgECjiLtz7Zs+hsT6Xd/cvOS446N+XGpQNU149LY9y7zJkVczp0MX0SVdC5o0z4nr
         QgYjFasO35F+KpnbYZ0fjiq6rK2QPfIuVelGg=
MIME-Version: 1.0
In-Reply-To: <1244958863-28899-1-git-send-email-wuzhangjin@gmail.com>
References: <1244958863-28899-1-git-send-email-wuzhangjin@gmail.com>
Date: Sun, 14 Jun 2009 08:59:15 +0300
X-Google-Sender-Auth: d4504877a94aa285
Message-ID: <84144f020906132259v2637b436vbc42b49c2adf06ff@mail.gmail.com>
Subject: Re: [PATCH] kmemtrace:fix undeclared 'PAGE_SIZE' via asm/page.h
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Wu Zhangjin <wuzhangjin@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       Linux-MIPS <linux-mips@linux-mips.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Ralf Baechle <ralf@linux-mips.org>, Wu Zhangjin <wuzj@lemote.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 14, 2009 at 8:54 AM, Wu Zhangjin<wuzhangjin@gmail.com> wrote:
> From: Wu Zhangjin <wuzj@lemote.com>
>
> when compiling linux-mips with kmemtrace enabled, this error will be
> there:
>
> include/linux/trace_seq.h:12: error: 'PAGE_SIZE' undeclared here (not in
>                                a function)
>
> I checked the source code and found trace_seq.h used PAGE_SIZE but not
> include the relative header file, so, fix it via adding the header file
> <asm/page.h>
>
> this error will not be triggered in linux-x86 for there is a
> <asm/page.h> header file included in a certain header file. but which
> not means <asm/page.h> is not needed in trace_seq.h
>
> Signed-off-by: Wu Zhangjin <wuzj@lemote.com>

This looks like a generic tracing issue, not a kmemtrace problem so
the subject line needs fixing. But the change looks good to me:

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
