Return-Path: <linux-kernel-owner+w=401wt.eu-S937734AbYBWAyp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937734AbYBWAyp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 19:54:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935123AbYBWAqm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 19:46:42 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:60443 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937054AbYBWAqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 19:46:39 -0500
Date: Fri, 22 Feb 2008 16:46:17 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [patch 34/38] kbuild: allow -fstack-protector to take effect
Message-ID: <20080222164617.50c8ec2e@laptopd505.fenrus.org>
In-Reply-To: <20080223003133.GI7268@suse.de>
References: <20080223001946.979768610@mini.kroah.org>
	<20080223003133.GI7268@suse.de>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Feb 2008 16:31:33 -0800
Greg KH <gregkh@suse.de> wrote:

> 2.6.24-stable review patch.  If anyone has any objections, please let
> us know.


not ready for -stable yet. if ever for backporting (doubtful)

> 
> ------------------
> From: Sam Ravnborg <sam@ravnborg.org>
> 
> commit: e06b8b98da071f7dd78fb7822991694288047df0
> 
> Arjan van de Ven <arjan@infradead.org> wrote:
> ===
> I just read the excellent LWN writeup of the vmsplice
> security thing, and that got me wondering why this attack
> wasn't stopped by the CONFIG_CC_STACKPROTECTOR option...
> because it plain should have been...
> 
> Some analysis later.. it turns out that the following line
> in the top level Makefile, added by you in October 2007,
> entirely disables CONFIG_CC_STACKPROTECTOR ;(
> With this line removed the exploit will be nicely stopped.
> 
> CFLAGS          += $(call cc-option, -fno-stack-protector)
> 
> Now I realize that certain distros have patched gcc to
> compensate for their lack of distro wide CFLAGS, and it's
> great to work around that... but would there be a way to NOT
> disable this for CONFIG_CC_STACKPROTECTOR please?
> It would have made this exploit not possible for those kernels
> that enable this feature (and that includes distros like Fedora)
> ===
> 
> Move the assignment to KBUILD_CFLAGS up before including
> the arch specific Makefile so arch makefiles may override
> the setting.
> 
> Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
> Cc: Arjan van de Ven <arjan@infradead.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> ---
>  Makefile |    7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> --- a/Makefile
> +++ b/Makefile
> @@ -507,6 +507,10 @@ else
>  KBUILD_CFLAGS	+= -O2
>  endif
>  
> +# Force gcc to behave correct even for buggy distributions
> +# Arch Makefiles may override this setting
> +KBUILD_CFLAGS += $(call cc-option, -fno-stack-protector)
> +
>  include $(srctree)/arch/$(SRCARCH)/Makefile
>  
>  ifdef CONFIG_FRAME_POINTER
> @@ -520,9 +524,6 @@ KBUILD_CFLAGS	+= -g
>  KBUILD_AFLAGS	+= -gdwarf-2
>  endif
>  
> -# Force gcc to behave correct even for buggy distributions
> -KBUILD_CFLAGS         += $(call cc-option, -fno-stack-protector)
> -
>  # arch Makefile may override CC so keep this after arch Makefile is
> included NOSTDINC_FLAGS += -nostdinc -isystem $(shell $(CC)
> -print-file-name=include) CHECKFLAGS     += $(NOSTDINC_FLAGS)
> 


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
