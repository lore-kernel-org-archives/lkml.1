Return-Path: <linux-kernel-owner+w=401wt.eu-S1757862AbZBBRcM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757862AbZBBRcM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 12:32:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757282AbZBBRbv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 12:31:51 -0500
Received: from hera.kernel.org ([140.211.167.34]:59798 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757223AbZBBRbt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 12:31:49 -0500
Subject: Re: [git-pull -tip] fix headers_check warnings
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, David Miller <davem@davemloft.net>,
       LKML <linux-kernel@vger.kernel.org>, reiserfs-devel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20090202172159.GA7479@localhost>
References: <1233593765.3244.14.camel@localhost.localdomain>
	 <20090202172159.GA7479@localhost>
Content-Type: text/plain
Date: Mon, 02 Feb 2009 23:00:55 +0530
Message-Id: <1233595855.28370.1.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-02-02 at 20:21 +0300, Cyrill Gorcunov wrote:
> [Jaswinder Singh Rajput - Mon, Feb 02, 2009 at 10:26:05PM +0530]
> | Ingo,
> | 
> | The following changes since commit 1ff8f739c7cc4eaa89b6ba986494f458ff7bdbef:
> |   Jaswinder Singh Rajput (1):
> |         headers_check fix: xtensa, swab.h
> | 
> | are available in the git repository at:
> | 
> |   git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-tipclean.git core/header-fixes
> | 
> | Jaswinder Singh Rajput (7):
> |       headers_check fix: linux/coda_psdev.h
> |       headers_check fix: linux/in6.h
> |       headers_check fix: linux/nubus.h
> |       headers_check fix: linux/socket.h
> |       headers_check fix: linux/reinserfs_fs.h
> |       headers_check fix: x86, prctl.h
> |       headers_check fix: x86, setup.h
> | 
> |  arch/x86/include/asm/prctl.h |    6 +++-
> |  arch/x86/include/asm/setup.h |   45 ++++++++++++++++++++---------------------
> |  include/linux/coda_psdev.h   |   15 ++++++-------
> |  include/linux/in6.h          |    2 +-
> |  include/linux/nubus.h        |    2 +
> |  include/linux/reiserfs_fs.h  |    8 +++++++
> |  include/linux/socket.h       |    6 +++-
> |  7 files changed, 48 insertions(+), 36 deletions(-)
> | 
> ...
> | 
> | Complete diff:
> | diff --git a/arch/x86/include/asm/prctl.h b/arch/x86/include/asm/prctl.h
> | index a889464..fdbeb85 100644
> | --- a/arch/x86/include/asm/prctl.h
> | +++ b/arch/x86/include/asm/prctl.h
> | @@ -6,8 +6,10 @@
> |  #define ARCH_GET_FS 0x1003
> |  #define ARCH_GET_GS 0x1004
> |  
> | -#ifdef CONFIG_X86_64
> | +#ifdef __KERNEL__
> | +# ifdef CONFIG_X86_64
> |  extern long sys_arch_prctl(int, unsigned long);
> | -#endif /* CONFIG_X86_64 */
> | +# endif /* CONFIG_X86_64 */
> | +#endif /* __KERNEL__ */
> | 
> ...
> 
> Hi Jaswinder,
> 
> it seems we have a clash here :) I thought this part
> was just dropped out
> 
> 	http://lkml.org/lkml/2009/1/14/461
> 
> and Peter had been applying it on tip:x86/header-fixes
> 
> 	http://lkml.org/lkml/2009/1/14/549
> 
> but maybe it's just lost...

No, you cannot remove sys_arch_prctl otherwise you will get sparse
warning like this:

  CHECK   arch/x86/kernel/process_64.c
arch/x86/kernel/process_64.c:833:6: warning: symbol 'sys_arch_prctl' was not declared. Should it be static?

--
JSR

