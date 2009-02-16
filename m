Return-Path: <linux-kernel-owner+w=401wt.eu-S1752547AbZBPQIg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752547AbZBPQIg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 11:08:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751162AbZBPQI1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 11:08:27 -0500
Received: from rtsoft3.corbina.net ([85.21.88.6]:30434 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750861AbZBPQI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 11:08:26 -0500
Date: Mon, 16 Feb 2009 19:08:24 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <srostedt@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
Subject: Re: [PATCH 1/3] Makefile: Include arch Makefiles as late as
	possible
Message-ID: <20090216160824.GA1616@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20090204150755.GA24163@oksana.dev.rtsoft.ru> <20090204150835.GA30027@oksana.dev.rtsoft.ru> <20090204212612.GN22608@elte.hu> <20090214195702.GB1241@uranus.ravnborg.org> <20090216142001.GA27869@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20090216142001.GA27869@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 16, 2009 at 05:20:01PM +0300, Anton Vorontsov wrote:
[...]
> But then, this commit reverted things back (w/o your Ack):
> 
> commit bef5b54bd7bf8117c75cb943d64549134c6d9a1f
> Author: Ralf Baechle <ralf@linux-mips.org>
> Date:   Wed Jul 16 13:02:24 2008 +0100
> 
>     Fix MIPS cross-compile problem
>     [...]
>     Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
>     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> 
> [...]
> --- a/Makefile
> +++ b/Makefile
> @@ -508,6 +508,8 @@ else
>  KBUILD_CFLAGS  += -O2
>  endif
>  
> +include $(srctree)/arch/$(SRCARCH)/Makefile
> +
>  ifneq (CONFIG_FRAME_WARN,0)
>  KBUILD_CFLAGS += $(call cc-option,-Wframe-larger-than=${CONFIG_FRAME_WARN})
>  endif
> @@ -516,8 +518,6 @@ endif
>  # Arch Makefiles may override this setting
>  KBUILD_CFLAGS += $(call cc-option, -fno-stack-protector)
>  
> -include $(srctree)/arch/$(SRCARCH)/Makefile
> -
>  ifdef CONFIG_FRAME_POINTER
>  KBUILD_CFLAGS  += -fno-omit-frame-pointer -fno-optimize-sibling-calls
>  else

Btw, I wonder if x86's CONFIG_CC_STACKPROTECTOR is a no-op since
v2.6.27-rc1? Seems like it is.

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
