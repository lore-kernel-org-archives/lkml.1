Return-Path: <linux-kernel-owner+w=401wt.eu-S1760095AbZAIX4Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760095AbZAIX4Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 18:56:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753742AbZAIX4K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 18:56:10 -0500
Received: from styx.suse.cz ([82.119.242.94]:45842 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753449AbZAIX4J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 18:56:09 -0500
Date: Sat, 10 Jan 2009 00:56:08 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Alexey Zaytsev <alexey.zaytsev@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>,
       Trivial Kernel Patches <trivial@kernel.org>
Subject: Re: [PATCH 3/5] Fix dubious bitwise 'and' usage spotted by sparse.
In-Reply-To: <20090109234813.11800.84518.stgit@zaytsev.su>
Message-ID: <alpine.LNX.1.10.0901100055050.5377@jikos.suse.cz>
References: <20090109234113.11800.55672.stgit@zaytsev.su> <20090109234813.11800.84518.stgit@zaytsev.su>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Jan 2009, Alexey Zaytsev wrote:

> It doesn't change the semantics, but it looks like
> the logical 'and' was meant to be used here.
> ---
>  drivers/media/video/gspca/m5602/m5602_s5k4aa.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/video/gspca/m5602/m5602_s5k4aa.c b/drivers/media/video/gspca/m5602/m5602_s5k4aa.c
> index 14b1eac..c3ebcca 100644
> --- a/drivers/media/video/gspca/m5602/m5602_s5k4aa.c
> +++ b/drivers/media/video/gspca/m5602/m5602_s5k4aa.c
> @@ -114,7 +114,7 @@ int s5k4aa_read_sensor(struct sd *sd, const u8 address,
>  	if (err < 0)
>  		goto out;
>  
> -	for (i = 0; (i < len) & !err; i++) {
> +	for (i = 0; (i < len) && !err; i++) {
>  		err = m5602_read_bridge(sd, M5602_XB_I2C_DATA, &(i2c_data[i]));
>  
>  		PDEBUG(D_CONF, "Reading sensor register "

Hi Alexey,

this one doesn't apply to Linus' tree anymore, the whole 
s5k4aa_read_sensor() function is not there.

-- 
Jiri Kosina
SUSE Labs
