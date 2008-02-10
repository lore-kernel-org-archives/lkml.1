Return-Path: <linux-kernel-owner+w=401wt.eu-S1757730AbYBJLio@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757730AbYBJLio (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 06:38:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756032AbYBJLih
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 06:38:37 -0500
Received: from wa-out-1112.google.com ([209.85.146.183]:26448 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755726AbYBJLig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 06:38:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=XNWC6fXoUKNj44EzUJlW6uXdL4eMhpwchRA4nYGq5gMoUu9/vB7Mh5X5Z1WaLYI8rZnwSaRqWmjL7RBXD76RACgaw9zWyrx2EPB/4rZyFFsyRvyfBetK0+DHl6scrI7Xan0mgZEZSMX2ICXn3LCeqePLe2nNQ53htq2nRYqs9vw=
Message-ID: <661de9470802100338u293b19c3m6fb70f7471e2799e@mail.gmail.com>
Date: Sun, 10 Feb 2008 17:08:35 +0530
From: "Balbir Singh" <balbir@linux.vnet.ibm.com>
To: "Dave Hansen" <haveblue@us.ibm.com>
Subject: Re: [PATCH] make KVM selectable again
Cc: "Avi Kivity" <avi@argo.co.il>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       kvm-devel <kvm-devel@lists.sourceforge.net>,
       "Sam Ravnborg" <sam@ravnborg.org>
In-Reply-To: <1202590755.14165.11.camel@nimitz.home.sr71.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1202590755.14165.11.camel@nimitz.home.sr71.net>
X-Google-Sender-Auth: 7cc8751109b3bc89
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 10, 2008 2:29 AM, Dave Hansen <haveblue@us.ibm.com> wrote:
> Current git for me (b1d0e4f535e10775cffde922208b49629169aeaa) doesn't
> let me build KVM.  In fact, I don't seem to have *ANY* kvm-related
> symbols in my .config at all.
>
> I've verified that arch/x86/kvm/Kconfig was getting run by putting some
> comments in it.  It seems to me like just putting:
>
>         config HAVE_KVM
>                bool
>
> isn't letting anything come into my .config at all.  I'm not sure why we
> do that, and then have:
>
>         select HAVE_KVM
>
> in arch/x86/Kconfig.
>
> This patch just defines HAVE_KVM in the x86 Kconfig and is done with it.
> Seems to work for me.
>
> Was there some reason that it was done this way?  Was it ever tested?
>
> -- Dave
>
> Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
>
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 65a70b7..cbbf35d 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -115,7 +115,8 @@ config ARCH_HAS_CPU_RELAX
>  config HAVE_SETUP_PER_CPU_AREA
>         def_bool X86_64
>
> -select HAVE_KVM
> +config HAVE_KVM
> +       def_bool y
>
>  config ARCH_HIBERNATION_POSSIBLE
>         def_bool y
> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> index 41962e7..f2177ec 100644
> --- a/arch/x86/kvm/Kconfig
> +++ b/arch/x86/kvm/Kconfig
> @@ -1,8 +1,6 @@
>  #
>  # KVM configuration
>  #
> -config HAVE_KVM
> -       bool
>
>  menuconfig VIRTUALIZATION
>         bool "Virtualization"
>

Hi, Dave,

I did not see your email, until just now. I've posted a patch at
http://lkml.org/lkml/2008/2/10/26. Avi has acked it

Balbir
