Return-Path: <linux-kernel-owner+w=401wt.eu-S933081AbYAaM6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933081AbYAaM6S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 07:58:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764649AbYAaM6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 07:58:06 -0500
Received: from styx.suse.cz ([82.119.242.94]:36122 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1764530AbYAaM6F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 07:58:05 -0500
Date: Thu, 31 Jan 2008 13:58:04 +0100
From: Jan Kara <jack@suse.cz>
To: marcin.slusarz@gmail.com
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 04/10] udf: constify crc
Message-ID: <20080131125804.GD1461@duck.suse.cz>
References: <1201727040-6769-1-git-send-email-marcin.slusarz@gmail.com> <1201727040-6769-5-git-send-email-marcin.slusarz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1201727040-6769-5-git-send-email-marcin.slusarz@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 30-01-08 22:03:54, marcin.slusarz@gmail.com wrote:
> - constify internal crc table
> - mark udf_crc "in" parameter as const
  Acked-by: Jan Kara <jack@suse.cz>

								Honza

> 
> Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> Cc: Jan Kara <jack@suse.cz>
> ---
>  fs/udf/crc.c     |    4 ++--
>  fs/udf/udfdecl.h |    2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/udf/crc.c b/fs/udf/crc.c
> index b166129..f178c63 100644
> --- a/fs/udf/crc.c
> +++ b/fs/udf/crc.c
> @@ -23,7 +23,7 @@
>  
>  #include "udfdecl.h"
>  
> -static uint16_t crc_table[256] = {
> +static const uint16_t crc_table[256] = {
>  	0x0000U, 0x1021U, 0x2042U, 0x3063U, 0x4084U, 0x50a5U, 0x60c6U, 0x70e7U,
>  	0x8108U, 0x9129U, 0xa14aU, 0xb16bU, 0xc18cU, 0xd1adU, 0xe1ceU, 0xf1efU,
>  	0x1231U, 0x0210U, 0x3273U, 0x2252U, 0x52b5U, 0x4294U, 0x72f7U, 0x62d6U,
> @@ -79,7 +79,7 @@ static uint16_t crc_table[256] = {
>   *	July 21, 1997 - Andrew E. Mileski
>   *	Adapted from OSTA-UDF(tm) 1.50 standard.
>   */
> -uint16_t udf_crc(uint8_t *data, uint32_t size, uint16_t crc)
> +uint16_t udf_crc(const uint8_t *data, uint32_t size, uint16_t crc)
>  {
>  	while (size--)
>  		crc = crc_table[(crc >> 8 ^ *(data++)) & 0xffU] ^ (crc << 8);
> diff --git a/fs/udf/udfdecl.h b/fs/udf/udfdecl.h
> index 0c525e8..c6c457b 100644
> --- a/fs/udf/udfdecl.h
> +++ b/fs/udf/udfdecl.h
> @@ -192,7 +192,7 @@ extern long_ad *udf_get_filelongad(uint8_t *, int, uint32_t *, int);
>  extern short_ad *udf_get_fileshortad(uint8_t *, int, uint32_t *, int);
>  
>  /* crc.c */
> -extern uint16_t udf_crc(uint8_t *, uint32_t, uint16_t);
> +extern uint16_t udf_crc(const uint8_t *, uint32_t, uint16_t);
>  
>  /* udftime.c */
>  extern time_t *udf_stamp_to_time(time_t *, long *, kernel_timestamp);
> -- 
> 1.5.3.7
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
