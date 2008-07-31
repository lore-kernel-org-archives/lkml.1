Return-Path: <linux-kernel-owner+w=401wt.eu-S1756897AbYGaCH5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756897AbYGaCH5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 22:07:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753734AbYGaCHs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 22:07:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35516 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753185AbYGaCHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 22:07:47 -0400
Date: Wed, 30 Jul 2008 19:06:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: vapier.adi@gmail.com, linux-kernel@vger.kernel.org,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH] Missing symbol prefix on vmlinux.lds.h
Message-Id: <20080730190659.fcf01dff.akpm@linux-foundation.org>
In-Reply-To: <87tze6yk3z.wl%ysato@users.sourceforge.jp>
References: <87provuzwk.wl%ysato@users.sourceforge.jp>
	<8bd0f97a0807300911n4ae81b70v97276abf612f6b3e@mail.gmail.com>
	<87hca7npmp.wl%ysato@users.sourceforge.jp>
	<20080730130117.3495cba9.akpm@linux-foundation.org>
	<87tze6yk3z.wl%ysato@users.sourceforge.jp>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jul 2008 20:26:24 -0400 Yoshinori Sato <ysato@users.sourceforge.jp> wrote:

> Sorry.
> 
> I got error ARCH=h8300.
> init/main.c:781: undefined reference to `___early_initcall_end'
> 
> Same problem have
> __start___bug_table
> __stop___bug_table
> __tracedata_start
> __tracedata_end
> __per_cpu_start
> __per_cpu_end
> 
> If define symbol in vmlinux.lds, Use VMLINUX_SYMBOL macro.
> VMLINUX_SYMBOL is add prefix charactor.
> 
> Signed-off-by: Yoshinori Sato <ysato@users.sourceforge.jp>
> 
> ---
>  include/asm-generic/vmlinux.lds.h |   14 +++++++-------
>  1 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
> index 6d88a92..04cae96 100644
> --- a/include/asm-generic/vmlinux.lds.h
> +++ b/include/asm-generic/vmlinux.lds.h
> @@ -333,9 +333,9 @@
>  #define BUG_TABLE							\
>  	. = ALIGN(8);							\
>  	__bug_table : AT(ADDR(__bug_table) - LOAD_OFFSET) {		\
> -		__start___bug_table = .;				\
> +		VMLINUX_SYMBOL(__start___bug_table) = .;		\
>  		*(__bug_table)						\
> -		__stop___bug_table = .;					\
> +		VMLINUX_SYMBOL(__stop___bug_table) = .;			\
>  	}
>  #else
>  #define BUG_TABLE

Strange.  The code you're fixing there was added by

  commit 7664c5a1da4711bb6383117f51b94c8dc8f3f1cd
  Author: Jeremy Fitzhardinge <jeremy@goop.org>
  Date:   Fri Dec 8 02:36:19 2006 -0800

     [PATCH] Generic BUG implementation
    

over a year ago.  I doubt if h8300 has been broken for that long, so
something else must have triggered this failure.

Do you know what it was?
