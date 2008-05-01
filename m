Return-Path: <linux-kernel-owner+w=401wt.eu-S1764280AbYEAV3t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764280AbYEAV3t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 17:29:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758334AbYEAV3m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 17:29:42 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2955 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbYEAV3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 17:29:41 -0400
Subject: Re: [PATCH 1/4] lib: add ascii hex helper functions
From: Joe Perches <joe@perches.com>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1209675067.24729.165.camel@brick>
References: <1209675067.24729.165.camel@brick>
Content-Type: text/plain
Date: Thu, 01 May 2008 14:28:34 -0700
Message-Id: <1209677314.4841.13.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3-1.2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-05-01 at 13:51 -0700, Harvey Harrison wrote:
> Everyone rolls their own version around the tree, centralize
> in lib/hexdump.c
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
>  include/linux/kernel.h |    6 +++++-
>  lib/hexdump.c          |   25 +++++++++++++++++++++++--
>  2 files changed, 28 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index 4d46e29..20cae9a 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -276,7 +276,11 @@ extern void print_hex_dump(const char *level, const char *prefix_str,
>  				const void *buf, size_t len, bool ascii);
>  extern void print_hex_dump_bytes(const char *prefix_str, int prefix_type,
>  			const void *buf, size_t len);
> -#define hex_asc(x)	"0123456789abcdef"[x]
> +
> +extern const char hex_asc[];

I don't see a reason hex_asc should be extern.
It's only used by hexdump.
I think it better to remove hex_asc from kernel.h altogether.


