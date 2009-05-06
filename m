Return-Path: <linux-kernel-owner+w=401wt.eu-S1759882AbZEFVBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759882AbZEFVBc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 17:01:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757431AbZEFVBV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 17:01:21 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:52137 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171AbZEFVBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 17:01:21 -0400
Date: Wed, 6 May 2009 23:03:30 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Nigel Cunningham <nigel@tuxonice.net>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       tuxonice-devel@lists.tuxonice.net
Subject: Re: [PATCH 9/19] TuxOnIce: Netlink support.
Message-ID: <20090506210330.GA29496@uranus.ravnborg.org>
References: <1241620755-22133-1-git-send-email-nigel@tuxonice.net> <1241620755-22133-10-git-send-email-nigel@tuxonice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241620755-22133-10-git-send-email-nigel@tuxonice.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 07, 2009 at 12:39:05AM +1000, Nigel Cunningham wrote:
> This patch adds support for communicating with a userspace helper via a
> netlink socket. It is used by the userspace user interface support and
> by the storage manager support.
> 
> Signed-off-by: Nigel Cunningham <nigel@tuxonice.net>
> ---
>  kernel/power/Makefile           |    4 +
>  kernel/power/tuxonice_netlink.c |  339 +++++++++++++++++++++++++++++++++++++++
>  2 files changed, 343 insertions(+), 0 deletions(-)
>  create mode 100644 kernel/power/tuxonice_netlink.c
> 
> diff --git a/kernel/power/Makefile b/kernel/power/Makefile
> index 07efc8a..180b89a 100644
> --- a/kernel/power/Makefile
> +++ b/kernel/power/Makefile
> @@ -10,6 +10,10 @@ tuxonice_core-objs := tuxonice_modules.o tuxonice_sysfs.o tuxonice_highlevel.o \
>  
>  obj-$(CONFIG_TOI)		+= tuxonice_builtin.o
>  
> +ifdef CONFIG_NET
> +tuxonice_core-objs		+= tuxonice_netlink.o
> +endif

If you replace tuxonice_core-objs with tuxonice_core-y in your MAkefile the
above can be simplified to:
tuxonice_core-$(CONFIG_NET) += tuxonice_netlink.o

(On the assumption that CONFIG_NET is a bool)

	Sam
