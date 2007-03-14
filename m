Return-Path: <linux-kernel-owner+w=401wt.eu-S1030824AbXCNJj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030824AbXCNJj3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 05:39:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030825AbXCNJj3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 05:39:29 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:56996 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1030824AbXCNJj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 05:39:28 -0400
Date: Wed, 14 Mar 2007 10:39:27 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Al Viro <viro@ftp.linux.org.uk>
cc: torvalds@linux-foundation.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/17] C99 initializers, proper use of const in drivers/ps3
In-Reply-To: <E1HRPdq-0003Vz-1V@ZenIV.linux.org.uk>
Message-ID: <Pine.LNX.4.62.0703141039060.28462@pademelon.sonytel.be>
References: <E1HRPdq-0003Vz-1V@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Mar 2007, Al Viro wrote:
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Acked-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

> ---
>  drivers/ps3/ps3av_cmd.c |   24 +++++++++++++-----------
>  1 files changed, 13 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/ps3/ps3av_cmd.c b/drivers/ps3/ps3av_cmd.c
> index 21c97c8..bc70e81 100644
> --- a/drivers/ps3/ps3av_cmd.c
> +++ b/drivers/ps3/ps3av_cmd.c
> @@ -485,12 +485,12 @@ static u8 ps3av_cnv_mclk(u32 fs)
>  
>  static const u32 ps3av_ns_table[][5] = {
>  					/*   D1,    D2,    D3,    D4,    D5 */
> -	[PS3AV_CMD_AUDIO_FS_44K-BASE]	{  6272,  6272, 17836, 17836,  8918 },
> -	[PS3AV_CMD_AUDIO_FS_48K-BASE]	{  6144,  6144, 11648, 11648,  5824 },
> -	[PS3AV_CMD_AUDIO_FS_88K-BASE]	{ 12544, 12544, 35672, 35672, 17836 },
> -	[PS3AV_CMD_AUDIO_FS_96K-BASE]	{ 12288, 12288, 23296, 23296, 11648 },
> -	[PS3AV_CMD_AUDIO_FS_176K-BASE]	{ 25088, 25088, 71344, 71344, 35672 },
> -	[PS3AV_CMD_AUDIO_FS_192K-BASE]	{ 24576, 24576, 46592, 46592, 23296 }
> +	[PS3AV_CMD_AUDIO_FS_44K-BASE] =	{  6272,  6272, 17836, 17836,  8918 },
> +	[PS3AV_CMD_AUDIO_FS_48K-BASE] =	{  6144,  6144, 11648, 11648,  5824 },
> +	[PS3AV_CMD_AUDIO_FS_88K-BASE] =	{ 12544, 12544, 35672, 35672, 17836 },
> +	[PS3AV_CMD_AUDIO_FS_96K-BASE] =	{ 12288, 12288, 23296, 23296, 11648 },
> +	[PS3AV_CMD_AUDIO_FS_176K-BASE] =	{ 25088, 25088, 71344, 71344, 35672 },
> +	[PS3AV_CMD_AUDIO_FS_192K-BASE] =	{ 24576, 24576, 46592, 46592, 23296 }
>  };
>  
>  static void ps3av_cnv_ns(u8 *ns, u32 fs, u32 video_vid)
> @@ -543,9 +543,10 @@ static void ps3av_cnv_ns(u8 *ns, u32 fs, u32 video_vid)
>  
>  #undef BASE
>  
> -static u8 ps3av_cnv_enable(u32 source, u8 *enable)
> +static u8 ps3av_cnv_enable(u32 source, const u8 *enable)
>  {
> -	u8 *p, ret = 0;
> +	const u8 *p;
> +	u8 ret = 0;
>  
>  	if (source == PS3AV_CMD_AUDIO_SOURCE_SPDIF) {
>  		ret = 0x03;
> @@ -559,9 +560,10 @@ static u8 ps3av_cnv_enable(u32 source, u8 *enable)
>  	return ret;
>  }
>  
> -static u8 ps3av_cnv_fifomap(u8 *map)
> +static u8 ps3av_cnv_fifomap(const u8 *map)
>  {
> -	u8 *p, ret = 0;
> +	const u8 *p;
> +	u8 ret = 0;
>  
>  	p = map;
>  	ret = p[0] + (p[1] << 2) + (p[2] << 4) + (p[3] << 6);
> @@ -615,7 +617,7 @@ static void ps3av_cnv_info(struct ps3av_audio_info_frame *info,
>  	info->pb5.lsv = mode->audio_downmix_level;
>  }
>  
> -static void ps3av_cnv_chstat(u8 *chstat, u8 *cs_info)
> +static void ps3av_cnv_chstat(u8 *chstat, const u8 *cs_info)
>  {
>  	memcpy(chstat, cs_info, 5);
>  }
> -- 
> 1.5.0-rc2.GIT
> 
> 
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@ozlabs.org
> https://ozlabs.org/mailman/listinfo/linuxppc-dev
> 

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- Sony Network and Software Technology Center Europe (NSCE)
Geert.Uytterhoeven@sonycom.com ------- The Corporate Village, Da Vincilaan 7-D1
Voice +32-2-7008453 Fax +32-2-7008622 ---------------- B-1935 Zaventem, Belgium
