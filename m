Return-Path: <linux-kernel-owner+w=401wt.eu-S1753008Ab0ASOKT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753008Ab0ASOKT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 09:10:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752748Ab0ASOKS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 09:10:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43489 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752746Ab0ASOKR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 09:10:17 -0500
Subject: Re: [PATCH] kconfig: dont hardcode path to lsmod
From: Steven Rostedt <srostedt@redhat.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-kbuild@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1263883920-17289-1-git-send-email-vapier@gentoo.org>
References: <1263883920-17289-1-git-send-email-vapier@gentoo.org>
Content-Type: text/plain
Organization: Red Hat
Date: Tue, 19 Jan 2010 09:10:02 -0500
Message-Id: <1263910202.2737.133.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-01-19 at 01:52 -0500, Mike Frysinger wrote:
> The lsmod utility has always been installed into /bin with the newer
> module-init-tools package, so let lsmod be found via PATH instead of
> hardcoding the old modutils /sbin path.
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>

Thanks Mike, I actually have another patch like this. I was first a bit
nervous about using non hard code, but then perhaps it's OK. I my patch
actually checked the main paths first before choosing the "lsmod". But
maybe that would be the better solution, since it would allow someone to
choose their own lsmod.

Thanks!

-- Steve

> ---
>  scripts/kconfig/streamline_config.pl |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/scripts/kconfig/streamline_config.pl b/scripts/kconfig/streamline_config.pl
> index 0d80082..e1dfc8c 100644
> --- a/scripts/kconfig/streamline_config.pl
> +++ b/scripts/kconfig/streamline_config.pl
> @@ -238,7 +238,7 @@ foreach my $makefile (@makefiles) {
>  my %modules;
>  
>  # see what modules are loaded on this system
> -open(LIN,"/sbin/lsmod|") || die "Cant lsmod";
> +open(LIN,"lsmod|") || die "Cant lsmod";
>  while (<LIN>) {
>  	next if (/^Module/);  # Skip the first line.
>  	if (/^(\S+)/) {

