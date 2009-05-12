Return-Path: <linux-kernel-owner+w=401wt.eu-S1758738AbZELAUL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758738AbZELAUL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 20:20:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755033AbZELAT5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 20:19:57 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:40835 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753738AbZELAT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 20:19:57 -0400
Date: Mon, 11 May 2009 19:19:56 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Cedric Le Goater <clg@fr.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] ipc: use __ARCH_WANT_IPC_PARSE_VERSION in ipc/util.h
Message-ID: <20090512001956.GA22859@us.ibm.com>
References: <20090511222702.352192505@arndb.de>> <200905112302.04437.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200905112302.04437.arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Arnd Bergmann (arnd@arndb.de):
> The definition of ipc_parse_version depends on
> __ARCH_WANT_IPC_PARSE_VERSION, but the header file
> declares it conditionally based on the architecture.
> 
> Use the macro consistently to make it easier to add
> new architectures.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Makes sense!

Acked-by: Serge Hallyn <serue@us.ibm.com>

thanks,
-serge

> ---
>  ipc/util.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/ipc/util.h b/ipc/util.h
> index 1187332..f9fe90e 100644
> --- a/ipc/util.h
> +++ b/ipc/util.h
> @@ -128,7 +128,7 @@ void ipc_update_perm(struct ipc64_perm *in, struct kern_ipc_perm *out);
>  struct kern_ipc_perm *ipcctl_pre_down(struct ipc_ids *ids, int id, int cmd,
>  				      struct ipc64_perm *perm, int extra_perm);
> 
> -#if defined(__ia64__) || defined(__x86_64__) || defined(__hppa__) || defined(__XTENSA__)
> +#ifndef __ARCH_WANT_IPC_PARSE_VERSION
>    /* On IA-64, we always use the "64-bit version" of the IPC structures.  */ 
>  # define ipc_parse_version(cmd)	IPC_64
>  #else
> -- 
> 1.6.0.4
> 
> -- 
> 
