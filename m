Return-Path: <linux-kernel-owner+w=401wt.eu-S1760091AbYCZT2i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760091AbYCZT2i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 15:28:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755738AbYCZT2b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 15:28:31 -0400
Received: from wr-out-0506.google.com ([64.233.184.237]:61536 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754883AbYCZT2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 15:28:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=o5p37EDZ273bmY35VqNqDrQpNwCULN0FddLmUzpN614yjRCXFUjDoYIoC2tlzd/A9dVpD7Hy7w3qn9H6kXsh588Vbj6eS6S0c+F4FBqhfkXdYunqLi/spMp5SqJcPVLFBHtfudJ6tD1ftaltHx55dxiJBvI11itQiTFV4DTNlVA=
Message-ID: <86802c440803261228m5026bca1x46047c0dc656545c@mail.gmail.com>
Date: Wed, 26 Mar 2008 12:28:28 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Mike Travis" <travis@sgi.com>
Subject: Re: [PATCH 2/2] x86: Modify Kconfig to allow up to 4096 cpus
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Ingo Molnar" <mingo@elte.hu>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080326014138.292294000@polaris-admin.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080326014137.934171000@polaris-admin.engr.sgi.com>
	 <20080326014138.292294000@polaris-admin.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2008 at 6:41 PM, Mike Travis <travis@sgi.com> wrote:
> Increase the limit of NR_CPUS to 4096 and introduce a boolean
>  called "MAXSMP" which when set (e.g. "allyesconfig"), will set
>  NR_CPUS = 4096 and NODES_SHIFT = 9 (512).
>
>  Based on:
>         git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
>         git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git
>
>  Signed-off-by: Mike Travis <travis@sgi.com>
>  ---
>   arch/x86/Kconfig |   20 ++++++++++++++++----
>   1 file changed, 16 insertions(+), 4 deletions(-)
>
>  --- linux.trees.git.orig/arch/x86/Kconfig
>  +++ linux.trees.git/arch/x86/Kconfig
>  @@ -522,16 +522,24 @@ config SWIOTLB
>           access 32-bits of memory can be used on systems with more than
>           3 GB of memory. If unsure, say Y.
>
>  +config MAXSMP
>  +       bool "Configure Maximum number of SMP Processors"
>  +       depends on X86_64 && SMP
>  +       default n
>  +       help
>  +         Configure maximum number of CPUS for this architecture.
>  +         If unsure, say N.
>
>   config NR_CPUS
>  -       int "Maximum number of CPUs (2-255)"
>  -       range 2 255
>  +       int "Maximum number of CPUs (2-4096)"
>  +       range 2 4096
>         depends on SMP
>  +       default "4096" if MAXSMP
>         default "32" if X86_NUMAQ || X86_SUMMIT || X86_BIGSMP || X86_ES7000
>         default "8"
>         help
>           This allows you to specify the maximum number of CPUs which this
>  -         kernel will support.  The maximum supported value is 255 and the
>  +         kernel will support.  The maximum supported value is 4096 and the
>           minimum value which makes sense is 2.
>
>           This is purely to save memory - each supported CPU adds

or put
if  MAXSMP around NR_CPUS...

YH
