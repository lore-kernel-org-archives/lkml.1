Return-Path: <linux-kernel-owner+w=401wt.eu-S1762352AbZJODat@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762352AbZJODat (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 23:30:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755314AbZJODas
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 23:30:48 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:44109 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993AbZJODar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 23:30:47 -0400
Date: Thu, 15 Oct 2009 05:30:10 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Roland McGrath <roland@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, hpa@zytor.com,
       Ian Lance Taylor <iant@google.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] x86: linker script syntax nits
Message-ID: <20091015033010.GB10068@merkur.ravnborg.org>
References: <20091014221024.EFA79E2F@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091014221024.EFA79E2F@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 14, 2009 at 03:10:24PM -0700, Roland McGrath wrote:
> The following changes since commit 80f506918fdaaca6b574ba931536a58ce015c7be:
>   Linus Torvalds (1):
>         Merge branch 'for-linus' of git://git.kernel.dk/linux-2.6-block
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/frob/linux-2.6-roland.git topic/x86-lds-nits
> 
> Roland McGrath (1):
>       x86: linker script syntax nits
> 
>  arch/x86/kernel/acpi/realmode/wakeup.lds.S |    4 ++--
>  arch/x86/kernel/vmlinux.lds.S              |   17 ++++++++---------
>  2 files changed, 10 insertions(+), 11 deletions(-)
> ---
> [PATCH] x86: linker script syntax nits
> 
> The linker scripts grew some use of weirdly wrong linker script syntax.
> It happens to work, but it's not what the syntax is documented to be.
> Clean it up to use the official syntax.
> 
> Signed-off-by: Roland McGrath <roland@redhat.com>
> CC: Ian Lance Taylor <iant@google.com>
> ---
>  arch/x86/kernel/acpi/realmode/wakeup.lds.S |    4 ++--
>  arch/x86/kernel/vmlinux.lds.S              |   17 ++++++++---------
>  2 files changed, 10 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/kernel/acpi/realmode/wakeup.lds.S b/arch/x86/kernel/acpi/realmode/wakeup.lds.S
> index 7da00b7..0e50e1e 100644
> --- a/arch/x86/kernel/acpi/realmode/wakeup.lds.S
> +++ b/arch/x86/kernel/acpi/realmode/wakeup.lds.S
> @@ -56,6 +56,6 @@ SECTIONS
>  	/DISCARD/ : {
>  		*(.note*)
>  	}
> -
> -	. = ASSERT(_end <= WAKEUP_SIZE, "Wakeup too big!");
>  }
> +
> +ASSERT(_end <= WAKEUP_SIZE, "Wakeup too big!");

This breaks with older binutils.
See d2ba8b211bb8abc29aa627dbd4dce08cfbc8082b for reference.

Same goes for the other cahnges in this post.

Yup - it looks ugly :-(

	Sam
