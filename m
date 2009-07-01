Return-Path: <linux-kernel-owner+w=401wt.eu-S1755420AbZGASHf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755420AbZGASHf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 14:07:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753781AbZGASH1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 14:07:27 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:53666 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753475AbZGASH1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 14:07:27 -0400
Date: Wed, 1 Jul 2009 19:07:15 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Wu Zhangjin <wuzhangjin@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mips@linux-mips.org,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: [BUG] MIPS: Hibernation in the latest linux-mips:master branch
	not work
Message-ID: <20090701180715.GA23121@linux-mips.org>
References: <1246372868.19049.17.camel@falcon> <20090630144540.GA18212@linux-mips.org> <1246374687.20482.10.camel@falcon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246374687.20482.10.camel@falcon>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 30, 2009 at 11:11:27PM +0800, Wu Zhangjin wrote:

> hi, ralf, in the latest master branch of linux-mips git repo, seems
> there is a need to select the SYS_SUPPORTS_HOTPLUG_CPU option in every
> uni-processor board, otherwise, the suspend/hibernation can not be used,
> because you have set:
> 
> config ARCH_HIBERNATION_POSSIBLE
>     def_bool y
>     depends on SYS_SUPPORTS_HOTPLUG_CPU
> 
> config ARCH_SUSPEND_POSSIBLE
>     def_bool y
>     depends on SYS_SUPPORTS_HOTPLUG_CPU
> 
> so, the board-specific patch must be pushed by the maintainers of
> boards. and if the board support SMP, they must implement the
> mips-specific hotplug support, is this right? I have selected
> SYS_SUPPORTS_HOTPLUG_CPU in LEMOTE_FULONG and will push a relative patch
> later.

I think below patch should take care of this problem.  It simply assumes
that all uniprocessor systems support suspend and hibernate.  That's an
assumption that I'm not to unhappy with though it may force us to fix a
few systems.

  Ralf

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

 arch/mips/Kconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index df1a92a..3ca0fe1 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -2168,11 +2168,11 @@ menu "Power management options"
 
 config ARCH_HIBERNATION_POSSIBLE
 	def_bool y
-	depends on SYS_SUPPORTS_HOTPLUG_CPU
+	depends on SYS_SUPPORTS_HOTPLUG_CPU || !SMP
 
 config ARCH_SUSPEND_POSSIBLE
 	def_bool y
-	depends on SYS_SUPPORTS_HOTPLUG_CPU
+	depends on SYS_SUPPORTS_HOTPLUG_CPU || !SMP
 
 source "kernel/power/Kconfig"
 
