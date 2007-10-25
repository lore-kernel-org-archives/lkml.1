Return-Path: <linux-kernel-owner+w=401wt.eu-S1762558AbXJYUNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762558AbXJYUNU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 16:13:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760007AbXJYUNF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 16:13:05 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:58750 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762296AbXJYUND (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 16:13:03 -0400
Date: Thu, 25 Oct 2007 22:14:37 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/6] kill i386 and x86_64 directories
Message-ID: <20071025201437.GA14671@uranus.ravnborg.org>
References: <20071025195644.GA14501@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071025195644.GA14501@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2007 at 09:56:44PM +0200, Sam Ravnborg wrote:
> This series kill the old i386 and x86_64 directories.
> The relevant files are moved and adapted and
> Kconfig.debug was consolidated (thanks to Randy).
> 
> I had to modify both the top-lvel Makefile and the kconfig
> Makefile to accomplish this. It was done in such a way that
> it is trivial for other archs to use the same mechanism
> should they have the need.
> 
> To solve the defconfig issue (i386 and x86_64 cannot share one)
> the arch/x86/configs/ directory were introduced. This has
> been used by other archs for some time now but x86 had not had
> the need until now.
> 
> The Kconfig files could be consolidated much more - I only
> did the minimal changes to make it work in the new place.
> 
> Total diffstat (in git format):
> 
>  Makefile                                           |    7 ++-
>  arch/i386/.gitignore                               |    1 -
>  arch/{i386 => x86}/Kconfig.cpu                     |    0 
>  arch/{i386 => x86}/Kconfig.debug                   |   51 +++++++++++++---
>  arch/{i386/Kconfig => x86/Kconfig.i386}            |    4 +-
>  arch/{x86_64/Kconfig => x86/Kconfig.x86_64}        |    6 +--
>  arch/x86/Makefile                                  |   16 +++++
>  arch/{i386/Makefile => x86/Makefile_32}            |    7 +--
>  arch/{i386/Makefile.cpu => x86/Makefile_32.cpu}    |    0 
>  arch/{x86_64/Makefile => x86/Makefile_64}          |    5 +-
>  .../{i386/defconfig => x86/configs/i386_defconfig} |    0 
>  .../defconfig => x86/configs/x86_64_defconfig}     |    0 
>  arch/x86_64/.gitignore                             |    1 -
>  arch/x86_64/Kconfig.debug                          |   61 --------------------
>  scripts/kconfig/Makefile                           |   35 +++++++-----
>  15 files changed, 89 insertions(+), 105 deletions(-)
> 

By the way I consider this -rc1 material.
Because:
1) It sort of finishes the initial merge
2) Any breakage should be easy to trigger (build breakage) and easy to fix.

It is 1) that make me say this is -rc1 materail,
 and 2) that say that this is an acceptable 'breaking the rules' patch serie.

	Sam
