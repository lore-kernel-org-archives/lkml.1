Return-Path: <linux-kernel-owner+w=401wt.eu-S1756566AbYC2VA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756566AbYC2VA1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 17:00:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753041AbYC2VAU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 17:00:20 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:31946 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066AbYC2VAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 17:00:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=FzmF3MrboxGvrAv5dfjfKh2jOW8ZuRUTm7M5cdC3n7BZ0gG3avkuJ+8GOapRUV9Rkv06PDR2VABaly32EjUy3r1Cl1XF8wiQdAO5agST4LCWwhLXO3I2qNEl4hV2QcmTPCXsm6Ck/mzw6897eoNx8MTZtAIuQ9eijBf5KHP+DwU=
Subject: Re: sound/core.h: evil #ifdefs
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Pavel Machek <pavel@suse.cz>
Cc: perex@perex.cz, kernel list <linux-kernel@vger.kernel.org>,
       Trivial patch monkey <trivial@kernel.org>, tiwai@suse.de
In-Reply-To: <20080329205700.GA11295@elf.ucw.cz>
References: <20080329205700.GA11295@elf.ucw.cz>
Content-Type: text/plain
Date: Sat, 29 Mar 2008 14:00:25 -0700
Message-Id: <1206824425.6543.28.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-03-29 at 21:57 +0100, Pavel Machek wrote:
> snd_minor_info_oss_* is an function returning int _or_ comment,
> depending on config parameters. That is truly evil, fix it.
> 
> Signed-off-by: Pavel Machek <pavel@suse.cz>
> 
> diff --git a/include/sound/core.h b/include/sound/core.h
> index 4fc0235..452000d 100644
> --- a/include/sound/core.h
> +++ b/include/sound/core.h
> @@ -277,8 +277,8 @@ #ifdef CONFIG_SND_OSSEMUL
>  int snd_minor_info_oss_init(void);
>  int snd_minor_info_oss_done(void);
>  #else
> -#define snd_minor_info_oss_init() /*NOP*/
> -#define snd_minor_info_oss_done() /*NOP*/
> +static inline snd_minor_info_oss_init(void) { return 0; }
   static inline int snd_minor_info_oss_init(void) { return 0; }

> +static inline snd_minor_info_oss_done(void) { return 0; }
   static inline int snd_minor_info_oss_done(void) { return 0; }
>  #endif
>  
>  /* memory.c */
> 

Cheers,

Harvey

