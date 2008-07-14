Return-Path: <linux-kernel-owner+w=401wt.eu-S1757951AbYGNUGA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757951AbYGNUGA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 16:06:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756148AbYGNUFw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 16:05:52 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:57275 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756077AbYGNUFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 16:05:51 -0400
Date: Mon, 14 Jul 2008 12:38:58 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Daniel Guilak <guilak@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       daniel@danielguilak.com
Subject: Re: [PATCH] init/version.c: Define version_string only if
 CONFIG_KALLSYMS is not defined.
Message-Id: <20080714123858.2c42227f.randy.dunlap@oracle.com>
In-Reply-To: <1216062286.6497.18.camel@dguilak-desk>
References: <1215552069.10304.6.camel@dguilak-desk>
	<1216062286.6497.18.camel@dguilak-desk>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jul 2008 12:04:46 -0700 Daniel Guilak wrote:

> int Version_* is only used with ksymoops, which is only needed (according to
> README and Documentation/Changes) if CONFIG_KALLSYMS is NOT defined.  Therefore
> this patch defines version_string only if CONFIG_KALLSYMS is not defined.
> 
> Signed-off-by: Daniel Guilak <daniel@danielguilak.com>
> ---
>  init/version.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> Depends on "[PATCH] init/version.c: Silenced sparse warning by declaring the version string."
> 
> diff --git a/init/version.c b/init/version.c
> index 041fd82..52a8b98 100644
> --- a/init/version.c
> +++ b/init/version.c
> @@ -13,11 +13,13 @@
>  #include <linux/utsrelease.h>
>  #include <linux/version.h>
>  
> +#ifndef CONFIG_KALLSYMS
>  #define version(a) Version_ ## a
>  #define version_string(a) version(a)
>  
>  extern int version_string(LINUX_VERSION_CODE);
>  int version_string(LINUX_VERSION_CODE);
> +#endif
>  
>  struct uts_namespace init_uts_ns = {
>  	.kref = {
> -- 

Does not apply cleanly to linux-2.6.26, linux-next-20080714, or Linus-git-head.

and why do we ned both extern int version_string()
and int version_string() ?

---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
