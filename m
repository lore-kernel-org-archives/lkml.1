Return-Path: <linux-kernel-owner+w=401wt.eu-S1760032AbYBPGcb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760032AbYBPGcb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 01:32:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751945AbYBPGcY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 01:32:24 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45246 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751703AbYBPGcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 01:32:23 -0500
Date: Fri, 15 Feb 2008 22:32:01 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: lkml <linux-kernel@vger.kernel.org>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 4/6] h8300 CONFIG_KALLSYMS fix
Message-Id: <20080215223201.c0d08ce6.akpm@linux-foundation.org>
In-Reply-To: <87abm1o2ck.wl%ysato@users.sourceforge.jp>
References: <87abm1o2ck.wl%ysato@users.sourceforge.jp>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Feb 2008 01:13:47 -0500 Yoshinori Sato <ysato@users.sourceforge.jp> wrote:

> Please comment "C_SYMBOL_PREFIX".
> 
>  Makefile           |    3 ++-
>  arch/h8300/Kconfig |    4 ++++
>  2 files changed, 6 insertions(+), 1 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index c162370..745e31f 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -751,7 +751,8 @@ endef
>  # Generate .S file with all kernel symbols
>  quiet_cmd_kallsyms = KSYM    $@
>        cmd_kallsyms = $(NM) -n $< | $(KALLSYMS) \
> -                     $(if $(CONFIG_KALLSYMS_ALL),--all-symbols) > $@
> +                     $(if $(CONFIG_KALLSYMS_ALL),--all-symbols) \
> +                     $(if $(CONFIG_C_SYMBOL_PREFIX),--symbol-prefix='_') > $@
>  
>  .tmp_kallsyms1.o .tmp_kallsyms2.o .tmp_kallsyms3.o: %.o: %.S scripts FORCE
>  	$(call if_changed_dep,as_o_S)
> diff --git a/arch/h8300/Kconfig b/arch/h8300/Kconfig
> index 085dc6e..2804edd 100644
> --- a/arch/h8300/Kconfig
> +++ b/arch/h8300/Kconfig
> @@ -87,6 +87,10 @@ config HZ
>  	int
>  	default 100
>  
> +config C_SYMBOL_PREFIX
> +	bool
> +	default y
> +
>  source "init/Kconfig"
>  
>  source "arch/h8300/Kconfig.cpu"
> -- 

Sam looks after that code.

None of these patches added your Signed-off-by:.  Please confirm that it
is OK if I add it.
