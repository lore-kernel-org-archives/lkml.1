Return-Path: <linux-kernel-owner+w=401wt.eu-S935515AbXGQTF4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935515AbXGQTF4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 15:05:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761318AbXGQTFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 15:05:47 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:35983 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762155AbXGQTFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 15:05:47 -0400
Date: Tue, 17 Jul 2007 21:05:08 +0200
From: Adrian Bunk <bunk@stusta.de>
To: "Horst H. von Brand" <vonbrand@inf.utfsm.cl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       v9fs-developer@lists.sourceforge.net
Subject: Re: [PATCH] fs/9p/v9fs.c: Delete unused p9_debug_level setting
Message-ID: <20070717190508.GH3801@stusta.de>
References: <11846967662438-git-send-email-vonbrand@inf.utfsm.cl> <11846967671229-git-send-email-vonbrand@inf.utfsm.cl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <11846967671229-git-send-email-vonbrand@inf.utfsm.cl>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2007 at 02:26:06PM -0400, Horst H. von Brand wrote:
> From: Horst H. von Brand <vonbrand@inf.utfsm.cl>
> 
> Signed-off-by: Horst H. von Brand <vonbrand@inf.utfsm.cl>
> ---
>  fs/9p/v9fs.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/9p/v9fs.c b/fs/9p/v9fs.c
> index 45c3598..72ad365 100644
> --- a/fs/9p/v9fs.c
> +++ b/fs/9p/v9fs.c
> @@ -131,7 +131,6 @@ static void v9fs_parse_options(char *options, struct v9fs_session_info *v9ses)
>  		switch (token) {
>  		case Opt_debug:
>  			v9ses->debug = option;
> -			p9_debug_level = option;
>  			break;
>  		case Opt_port:
>  			v9ses->port = option;

It doesn't seem to be unused:

$ grep -r p9_debug_level *
fs/9p/v9fs.c:                   p9_debug_level = option;
include/net/9p/9p.h:extern unsigned int p9_debug_level;
include/net/9p/9p.h:    if ((p9_debug_level & level) == level) \
net/9p/mod.c:unsigned int p9_debug_level = 0;   /* feature-rific global debug level  */
net/9p/mod.c:EXPORT_SYMBOL(p9_debug_level);
net/9p/mod.c:module_param_named(debug, p9_debug_level, uint, 0);
net/9p/mux.c:           if ((p9_debug_level&P9_DEBUG_FCALL) == P9_DEBUG_FCALL) {
net/9p/mux.c:   if ((p9_debug_level&P9_DEBUG_FCALL) == P9_DEBUG_FCALL) {
net/9p/sysctl.c:                .data           = &p9_debug_level,
$ 

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

