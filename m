Return-Path: <linux-kernel-owner+w=401wt.eu-S1756963AbXHOLHo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756963AbXHOLHo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 07:07:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753641AbXHOLHe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 07:07:34 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:23202 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108AbXHOLHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 07:07:33 -0400
X-IronPort-AV: i="4.19,266,1183348800"; 
   d="scan'208"; a="37129739:sNHT34418916"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Mike Frysinger" <vapier@gentoo.org>
Subject: Re: ignoring unimplemented functions that are old and crusty on shiny new ports
Date: Wed, 15 Aug 2007 07:11:34 -0400
User-Agent: KMail/1.9.5
Cc: "LKML" <linux-kernel@vger.kernel.org>, vapier.adi@gmail.com,
       sam@ravnborg.org, "Andrew Morton" <akpm@linux-foundation.org>
References: <200708132205.20454.vapier@gentoo.org>
In-Reply-To: <200708132205.20454.vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708150711.34700.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 15 Aug 2007 11:07:32.0230 (UTC) FILETIME=[7A08CA60:01C7DF2C]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 13 Aug 2007 22:05, Mike Frysinger pondered:
> would it be possible to get the class of "old and crusty" functions
> permanently ignored ?  i'm thinking of course of "uselib" and "sysfs"
> ...
> Blackfin does not implement either of these and i think that's a good
> thing
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> ---
> diff --git a/scripts/checksyscalls.sh b/scripts/checksyscalls.sh
> index 0dcc01c..7f1a830 100755
> --- a/scripts/checksyscalls.sh
> +++ b/scripts/checksyscalls.sh
> @@ -104,6 +104,10 @@ cat << EOF
>  #define __IGNORE_sync_file_range
>  #endif
>  
> +/* Old optional stuff no one actually uses */
> +#define __IGNORE_sysfs
> +#define __IGNORE_uselib
> +
>  /* Unmerged syscalls for AFS, STREAMS, etc. */
>  #define __IGNORE_afs_syscall
>  #define __IGNORE_getpmsg
> -

This seems like a good idea to me - as checksyscalls.sh is currently warning 
about things we didn't implement on purpose.

-Robin
