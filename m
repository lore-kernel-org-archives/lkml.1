Return-Path: <linux-kernel-owner+w=401wt.eu-S1759214AbYDGN5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759214AbYDGN5k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 09:57:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758364AbYDGN5b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 09:57:31 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:56963 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759032AbYDGN53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 09:57:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ABLC+1Ju++oSvOU4qPQcW1fpRKJeJVtAiOFDafCXnoOyipIamzKfzgdgcwplg/tcPsbn3kTWTGA3PRm/kLGBZSsefExIYdqBpeUDzM2Hfk+kjHzb0gtIFvnOH4eRkyFQ5emUMTK65z6TImFVMB3OX5rs1n5pdRWo9ZAIuAQ+7W4=
Message-ID: <36ca99e90804070657t4435f1a2ldd78ad5bf5978550@mail.gmail.com>
Date: Mon, 7 Apr 2008 15:57:29 +0200
From: "Bert Wesarg" <bert.wesarg@googlemail.com>
To: "Mike Travis" <travis@sgi.com>
Subject: Re: [PATCH 2/4] x86: modify show_shared_cpu_map in intel_cacheinfo v2
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080405012447.770671000@polaris-admin.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080405012447.440875000@polaris-admin.engr.sgi.com>
	 <20080405012447.770671000@polaris-admin.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 5, 2008 at 3:24 AM, Mike Travis <travis@sgi.com> wrote:
>  --- linux-2.6.x86.orig/arch/x86/kernel/cpu/intel_cacheinfo.c
>  +++ linux-2.6.x86/arch/x86/kernel/cpu/intel_cacheinfo.c
>  @@ -593,14 +593,17 @@ static ssize_t show_size(struct _cpuid4_
>
>   static ssize_t show_shared_cpu_map(struct _cpuid4_info *this_leaf, char *buf)
>   {
>  +       unsigned long end = ALIGN((unsigned long)buf, PAGE_SIZE);
May I suggest this:

           ptrdiff_t len = PTR_ALIGN(buf + PAGE_SIZE - 1, PAGE_SIZE) - buf;

>  +       if (len == 0)
>  +               len = PAGE_SIZE;
Than this is not necessary.

>  +
>  +       if (len >= 2) {
>  +               n = cpus_scnprintf(buf, len-2, this_leaf->shared_cpu_map);
>  +               buf[n++] = '\n';
>  +               buf[n] = '\0';
>         }
>         return n;
>   }
Apart from my suggestion and the use of cpus_scnprintf I think this patch is ok.

Bert

PS: sorry for the long delay.
