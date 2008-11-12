Return-Path: <linux-kernel-owner+w=401wt.eu-S1754544AbYKLTO4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544AbYKLTO4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 14:14:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752072AbYKLTOr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 14:14:47 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:51694 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792AbYKLTOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 14:14:46 -0500
Message-ID: <491B2AC2.6060603@oracle.com>
Date: Wed, 12 Nov 2008 11:13:06 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Werner Almesberger <werner@openmoko.org>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] remove bashisms from scripts/extract-ikconfig
References: <20081112183935.GA8443@almesberger.net>
In-Reply-To: <20081112183935.GA8443@almesberger.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt700.oracle.com [141.146.40.70]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010206.491B2AE8.00D8:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Werner Almesberger wrote:
> unbashify-extract-ikconfig.patch
> 
> scripts/extract-ikconfig contains a lot of gratuituous bashisms,
> which make it fail if /bin/sh isn't bash. This patch replaces them
> with regular Bourne shell constructs.
> 
> Signed-off-by: Werner Almesberger <werner@openmoko.org>

Acked-by: Randy Dunlap <randy.dunlap@oracle.com> # as file author


> ---
> 
> diff --git a/scripts/extract-ikconfig b/scripts/extract-ikconfig
> index 8187e6f..72997c3 100755
> --- a/scripts/extract-ikconfig
> +++ b/scripts/extract-ikconfig
> @@ -8,8 +8,8 @@ test -e $binoffset || cc -o $binoffset ./scripts/binoffset.c || exit 1
>  
>  IKCFG_ST="0x49 0x4b 0x43 0x46 0x47 0x5f 0x53 0x54"
>  IKCFG_ED="0x49 0x4b 0x43 0x46 0x47 0x5f 0x45 0x44"
> -function dump_config {
> -    typeset file="$1"
> +dump_config() {
> +    file="$1"
>  
>      start=`$binoffset $file $IKCFG_ST 2>/dev/null`
>      [ "$?" != "0" ] && start="-1"
> @@ -18,8 +18,8 @@ function dump_config {
>      fi
>      end=`$binoffset $file $IKCFG_ED 2>/dev/null`
>  
> -    let start="$start + 8"
> -    let size="$end - $start"
> +    start=`expr $start + 8`
> +    size=`expr $end - $start`
>  
>      dd if="$file" ibs=1 skip="$start" count="$size" 2>/dev/null | zcat
>  
> --


-- 
~Randy
