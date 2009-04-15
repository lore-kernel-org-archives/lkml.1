Return-Path: <linux-kernel-owner+w=401wt.eu-S1758864AbZDOLPc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758864AbZDOLPc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 07:15:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753392AbZDOLPX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 07:15:23 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38140 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751267AbZDOLPW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 07:15:22 -0400
Date: Wed, 15 Apr 2009 13:13:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: x86 maintainers <x86@kernel.org>, Sam Ravnborg <sam@ravnborg.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git-pull -tip] Add -Werror to arch/x86/ files only and fix
	warnings
Message-ID: <20090415111355.GB27727@elte.hu>
References: <1239793458.7653.12.camel@ht.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239793458.7653.12.camel@ht.satnam>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

> Hello Ingo,
> 
> As per your suggestion, I added -Werror for x86/files only and
> fix all remaining warnings on 32-bit and 64-bit defconfig and
> allnoconfig.
> 
> Here is pull request:
> The following changes since commit 3965887240cb092f0d568b53165da6a215c7937a:
>   Ingo Molnar (1):
>         Merge branch 'linus'
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-tip.git master
> 
> Jaswinder Singh Rajput (2):
>       x86: Adding -Werror to arch/x86/ files only
>       x86: k8.h convert node_to_k8_nb_misc() from a macro to an inline function
> 
>  arch/x86/boot/Makefile                 |    3 +++
>  arch/x86/boot/compressed/Makefile      |    3 +++
>  arch/x86/crypto/Makefile               |    3 +++
>  arch/x86/ia32/Makefile                 |    3 +++
>  arch/x86/include/asm/k8.h              |   11 ++++++++---
>  arch/x86/kernel/Makefile               |    3 +++
>  arch/x86/kernel/acpi/Makefile          |    3 +++
>  arch/x86/kernel/acpi/realmode/Makefile |    3 +++
>  arch/x86/kernel/apic/Makefile          |    3 +++
>  arch/x86/kernel/cpu/Makefile           |    3 +++
>  arch/x86/kernel/cpu/cpufreq/Makefile   |    3 +++
>  arch/x86/kernel/cpu/mcheck/Makefile    |    3 +++
>  arch/x86/kernel/cpu/mtrr/Makefile      |    3 +++
>  arch/x86/kvm/Makefile                  |    3 +++
>  arch/x86/lguest/Makefile               |    3 +++
>  arch/x86/lib/Makefile                  |    3 +++
>  arch/x86/math-emu/Makefile             |    3 +++
>  arch/x86/mm/Makefile                   |    3 +++
>  arch/x86/mm/kmemcheck/Makefile         |    3 +++
>  arch/x86/oprofile/Makefile             |    3 +++
>  arch/x86/pci/Makefile                  |    3 +++
>  arch/x86/power/Makefile                |    3 +++
>  arch/x86/vdso/Makefile                 |    4 +++-
>  arch/x86/video/Makefile                |    3 +++
>  arch/x86/xen/Makefile                  |    5 ++++-
>  25 files changed, 81 insertions(+), 5 deletions(-)
> 
> Complete diff:
> diff --git a/arch/x86/boot/Makefile b/arch/x86/boot/Makefile
> index 658bc52..aca7d2f 100644
> --- a/arch/x86/boot/Makefile
> +++ b/arch/x86/boot/Makefile
> @@ -22,6 +22,9 @@ ROOT_DEV	:= CURRENT
>  
>  SVGA_MODE	:= -DSVGA_MODE=NORMAL_VGA
>  
> +# Make all warnings into errors

=> 'Turn all warnings into errors'

> +ccflags-y := -Werror
> +
>  targets		:= vmlinux.bin setup.bin setup.elf bzImage
>  targets		+= fdimage fdimage144 fdimage288 image.iso mtools.conf
>  subdir-		:= compressed

> --- a/arch/x86/mm/Makefile
> +++ b/arch/x86/mm/Makefile
> @@ -1,3 +1,6 @@
> +# Make all warnings into errors
> +ccflags-y			:= -Werror
> +
>  obj-y	:=  init.o init_$(BITS).o fault.o ioremap.o extable.o pageattr.o mmap.o \
>  	    pat.o pgtable.o gup.o

i'd suggest to right-align this obj-y rule as well, to move it in 
line with the other lines.

Looks good otherwise.

Sam, any second thoughts?

	Ingo
