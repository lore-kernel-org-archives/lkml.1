Return-Path: <linux-kernel-owner+w=401wt.eu-S1753854AbZEHHQA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854AbZEHHQA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 03:16:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752599AbZEHHPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 03:15:51 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:38628 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752592AbZEHHPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 03:15:51 -0400
Date: Fri, 8 May 2009 09:17:59 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, vgoyal@redhat.com, hbabu@us.ibm.com,
       kexec@lists.infradead.org, ying.huang@intel.com, mingo@elte.hu,
       tglx@linutronix.de, ebiederm@xmission.com,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 01/14] x86, boot: align the .bss section in the decompressor
Message-ID: <20090508071759.GA12808@uranus.ravnborg.org>
References: <1241735222-6640-1-git-send-email-hpa@linux.intel.com> <1241735222-6640-2-git-send-email-hpa@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241735222-6640-2-git-send-email-hpa@linux.intel.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 07, 2009 at 03:26:49PM -0700, H. Peter Anvin wrote:
> From: H. Peter Anvin <hpa@zytor.com>
> 
> Aligning the .bss section makes it trivially faster, and makes using
> larger transfers for the clear slightly easier.
> 
> [ Impact: trivial performance enhancement, future patch prep ]
> 
> Signed-off-by: H. Peter Anvin <hpa@zytor.com>
> ---
>  arch/x86/boot/compressed/vmlinux.lds.S |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/boot/compressed/vmlinux.lds.S b/arch/x86/boot/compressed/vmlinux.lds.S
> index 0d26c92..27c168d 100644
> --- a/arch/x86/boot/compressed/vmlinux.lds.S
> +++ b/arch/x86/boot/compressed/vmlinux.lds.S
> @@ -42,6 +42,7 @@ SECTIONS
>  		*(.data.*)
>  		_edata = . ;
>  	}
> +	. = ALIGN(32);

Where does this magic 32 comes from?
I would assume the better choice would be:
	. = ALIGN(L1_CACHE_BYTES);

So we match the relevant CPU.

In general for alignmnet of output sections I see the need for:
1) Function call
2) L1_CACHE_BYTES
3) PAGE_SIZE
4) 2*PAGE_SIZE

But I see magic constant used here and there that does not match
the above (when looking at all archs).
So I act when I see a new 'magic' number..

	Sam
