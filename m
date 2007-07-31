Return-Path: <linux-kernel-owner+w=401wt.eu-S934112AbXGaS6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934112AbXGaS6U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 14:58:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758693AbXGaS6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 14:58:10 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46211 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757844AbXGaS6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 14:58:09 -0400
Date: Tue, 31 Jul 2007 11:57:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Satyam Sharma <satyam@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -mm] Introduce U16_MAX and U32_MAX
Message-Id: <20070731115729.64c875d4.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0707312153500.28746@enigma.security.iitk.ac.in>
References: <alpine.LFD.0.999.0707312153500.28746@enigma.security.iitk.ac.in>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Jul 2007 21:56:12 +0530 (IST)
Satyam Sharma <satyam@infradead.org> wrote:

> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -30,6 +30,9 @@ extern const char linux_proc_banner[];
>  #define LLONG_MIN	(-LLONG_MAX - 1)
>  #define ULLONG_MAX	(~0ULL)
>  
> +#define U16_MAX		((u16) ~0U)
> +#define U32_MAX		((u32) ~0U)
> +

hm, I'd have thought that there's a risk of gcc warnings here, forcing
0xffffffff into a u16, but apparently not.

Still, I think it'd be tidier here to tell the truth and use plain
old 0xffff and 0xffffffff?
