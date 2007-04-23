Return-Path: <linux-kernel-owner+w=401wt.eu-S1750708AbXDWGHz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750708AbXDWGHz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 02:07:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750719AbXDWGHz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 02:07:55 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:50424 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750708AbXDWGHz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 02:07:55 -0400
Date: Mon, 23 Apr 2007 11:37:39 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Jurriaan <thunder7@xs4all.nl>, Helge Hafting <helgehaf@aitel.hist.no>,
       linux-kernel@vger.kernel.org, Magnus Damm <magnus@valinux.co.jp>,
       Horms <horms@verge.net.au>, fastboot@osdl.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [PATCH 2/2] x86_64: Remove CONFIG_PHYSICAL_START and CONFIG_RELOCATABLE
Message-ID: <20070423060739.GA14664@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <20070331232957.e1c93f19.akpm@linux-foundation.org> <20070402074159.GA13704@in.ibm.com> <m1abxrf9o3.fsf@ebiederm.dsl.xmission.com> <20070402094520.GC13704@in.ibm.com> <m1648eg01d.fsf@ebiederm.dsl.xmission.com> <20070403040152.GA5108@in.ibm.com> <m1zm5qc9q2.fsf@ebiederm.dsl.xmission.com> <20070403100349.GA21759@in.ibm.com> <m18xcjznbm.fsf_-_@ebiederm.dsl.xmission.com> <m14pn7zn5n.fsf_-_@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m14pn7zn5n.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 22, 2007 at 11:15:48PM -0600, Eric W. Biederman wrote:
> 
> Now that the vmlinux is marked as relocatable there is no reason to
> retain the CONFIG_PHYSICAL_START option, as we can put the binary we
> have at any 2MB aligned address in memory.
> 
> With CONFIG_PHYSICAL_START gone the handful of code lines that depend
> on CONFIG_RELOCATABLE no longer make sense to be conditional and can
> be removed.
> 
> The big win of this patch (besides Kconfig simplicity) is that the
> nasty BUILD_BUG_ON test for people misaligning their kernel when using
> CONFIG_PHYSICAL_START can be removed as this case can only happen with
> CONFIG_PHYSICAL_START selected.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
> ---
>  arch/x86_64/Kconfig                |   55 +-----------------------------------
>  arch/x86_64/Makefile               |    2 -
>  arch/x86_64/boot/compressed/head.S |   13 +--------
>  arch/x86_64/boot/setup.S           |    4 --
>  arch/x86_64/defconfig              |    2 -
>  arch/x86_64/kernel/head64.c        |    7 ----
>  include/asm-x86_64/page.h          |    2 +-
>  7 files changed, 3 insertions(+), 82 deletions(-)
> 
> diff --git a/arch/x86_64/Kconfig b/arch/x86_64/Kconfig
> index 773b487..713c1ad 100644
> --- a/arch/x86_64/Kconfig
> +++ b/arch/x86_64/Kconfig
> @@ -565,62 +565,9 @@ config CRASH_DUMP
>            which are loaded in the main kernel with kexec-tools into
>            a specially reserved region and then later executed after
>            a crash by kdump/kexec. The crash dump kernel must be compiled
> -	  to a memory address not used by the main kernel or BIOS using
> -	  PHYSICAL_START.
> +	  to a memory address not used by the main kernel or BIOS
>            For more details see Documentation/kdump/kdump.txt

Hi Eric,

I think "must be compiled" should be replaced with "must be loaded" now.

Otherwise both the patches look fine.  I am planning to test these.

This change will also require modifications to Documentation/kdump/kdump.txt
file.

Thanks
Vivek
