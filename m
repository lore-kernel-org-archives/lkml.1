Return-Path: <linux-kernel-owner+w=401wt.eu-S1754537AbXIZIPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537AbXIZIPw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 04:15:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751496AbXIZIPi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 04:15:38 -0400
Received: from ns1.suse.de ([195.135.220.2]:58343 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1749667AbXIZIPg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 04:15:36 -0400
Date: Wed, 26 Sep 2007 10:15:34 +0200
From: Bernhard Walle <bwalle@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [patch 5/7] Use extended crashkernel command line on ppc64
Message-ID: <20070926081534.GD11385@suse.de>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-arch@vger.kernel.org, linuxppc-dev@ozlabs.org
References: <20070925182257.900701776@strauss.suse.de> <20070925182259.398924232@strauss.suse.de> <20070925124534.b9da41a2.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070925124534.b9da41a2.akpm@linux-foundation.org>
Organization: SUSE LINUX Products GmbH
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

* Andrew Morton <akpm@linux-foundation.org> [2007-09-25 21:45]:
> On Tue, 25 Sep 2007 20:23:02 +0200 Bernhard Walle <bwalle@suse.de> wrote:
> 
> > This patch adapts the ppc64 code to use the generic parse_crashkernel()
> > function introduced in the generic patch of that series.
> 
> I really don't like to see patches get a wholesale replacement, especially
> when they've been looked at by a few people and have had some testing, etc.
> It's not possible to see what changed and people need to re-review stuff
> they've already reviewed, etc.

Sorry, I didn't know that this is the preferred way. I just thought
it's more clear if the patches are replaced if the patch set is
finally pushed into Linus' tree.

> diff -puN arch/powerpc/kernel/machine_kexec.c~use-extended-crashkernel-command-line-on-ppc64-update arch/powerpc/kernel/machine_kexec.c
> --- a/arch/powerpc/kernel/machine_kexec.c~use-extended-crashkernel-command-line-on-ppc64-update
> +++ a/arch/powerpc/kernel/machine_kexec.c
> @@ -63,7 +63,7 @@ NORET_TYPE void machine_kexec(struct kim
>  
>  void __init reserve_crashkernel(void)
>  {
> -	unsigned long long crash_size = 0, crash_base;
> +	unsigned long long crash_size, crash_base;
>  	int ret;
>  
>  	/* this is necessary because of lmb_phys_mem_size() */
> _
> 
> 
> which I suspect will now create a compiler warning.

No, it doesn't. I just verified this.

  CHK     include/linux/compile.h
  CC      arch/powerpc/kernel/machine_kexec.o
  LD      arch/powerpc/kernel/built-in.o


Thanks,
   Bernhard
-- 
Bernhard Walle <bwalle@suse.de>, Architecture Maintenance
SUSE LINUX Products GmbH, Nürnberg, Germany
GF: Markus Rex, HRB 16746 (AG Nürnberg)
OpenPGP: F61F 34CC 09CA FB82 C9F6  BA4B 8865 3696 DDAF 6454
