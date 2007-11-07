Return-Path: <linux-kernel-owner+w=401wt.eu-S1759192AbXKGWHY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759192AbXKGWHY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 17:07:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758928AbXKGWHI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 17:07:08 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:39598 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755133AbXKGWHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 17:07:07 -0500
Subject: Re: [PATCH 1/2] Suppress A.OUT library support in ELF binfmt if
	!CONFIG_BINFMT_AOUT [try #3]
From: David Woodhouse <dwmw2@infradead.org>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@osdl.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-am33-list@redhat.com
In-Reply-To: <20071107174328.31820.62935.stgit@warthog.procyon.org.uk>
References: <20071107174323.31820.65054.stgit@warthog.procyon.org.uk>
	 <20071107174328.31820.62935.stgit@warthog.procyon.org.uk>
Content-Type: text/plain
Date: Wed, 07 Nov 2007 22:07:00 +0000
Message-Id: <1194473220.11490.93.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 (2.12.1-3.fc8.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-11-07 at 17:43 +0000, David Howells wrote:
> --- a/include/linux/a.out.h
> +++ b/include/linux/a.out.h
> @@ -1,6 +1,11 @@
>  #ifndef __A_OUT_GNU_H__
>  #define __A_OUT_GNU_H__
>  
> +#if defined(CONFIG_BINFMT_AOUT) || \
> +       defined(CONFIG_BINFMT_AOUT_MODULE) || \
> +       defined(CONFIG_IA32_AOUT) || \
> +       defined(CONFIG_IA32_AOUT_MODULE)
> +
>  #define __GNU_EXEC_MACROS__
>  
>  #ifndef __STRUCT_EXEC_OVERRIDE__

Ew, no. This is horridly broken. You should never use CONFIG_xxx_MODULE
in the static kernel at all -- and you should _especially_ not be using
it in header files which are exported to userspace.

This abomination certainly doesn't seem to have any direct relation to
mn10300 support -- I think all you really need there is not to attempt
to export {asm,linux}/a.out.h if asm/a.out.h doesn't exist, which is
something you haven't attempted here anyway.

-- 
dwmw2

