Return-Path: <linux-kernel-owner+w=401wt.eu-S1752869AbXL0OR2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752869AbXL0OR2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 09:17:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751854AbXL0ORU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 09:17:20 -0500
Received: from mail.zelnet.ru ([80.92.97.13]:39884 "EHLO mail.zelnet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751790AbXL0ORU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 09:17:20 -0500
Message-ID: <4773B3DC.20908@namesys.com>
Date: Thu, 27 Dec 2007 17:17:00 +0300
From: Edward Shishkin <edward@namesys.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.13) Gecko/20060411
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: joejamesjoyce@aol.com
CC: linux-kernel@vger.kernel.org
Subject: Re: REISER4: Attention Edward Shishkin (reiser4progs-1.0.6)
References: <8CA163CDBC4A026-5E4-F8F@WEBMAIL-MC02.sysops.aol.com>
In-Reply-To: <8CA163CDBC4A026-5E4-F8F@WEBMAIL-MC02.sysops.aol.com>
X-Enigmail-Version: 0.86.0.0
X-Enigmail-Supports: pgp-inline, pgp-mime
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

joejamesjoyce@aol.com wrote:

> REISER4: Attention Edward Shishkin (reiser4progs-1.0.6)
>
> -------------------------------------------------------------------------
> -
>
> Hi Edward, it has been pointed out that you CHANGED reiser4progs-1.0.6 
> in your version
>
> http://chichkin_i.zelnet.ru/namesys/reiser4progs-1.0.6.tar.gz
>
> from the version previously supplied by namesys.com
>
> ftp://ftp.namesys.com/pub/reiser4progs/reiser4progs-1.0.6.tar.gz


Hmm, but I have found they are synchronized...

>
> Does this have any relevance for REISER4 that I should know about?
>

I guess you have downloaded your reiser4progs-1.0.6 before it was
announced at 14 Mar 2007 ( http://lkml.org/lkml/2007/3/14/446 )
There is nothing criminal here: the latest version uses more progressive
compression mode as default one, plus some options got other name.

Thanks,
Edward.

> I have included a diff between the two versions.
>
> -------------------------------------------------------------------------
> -
>
> diff -pruN reiser4progs-1.0.6-namesys/include/reiser4/plugin.h 
> reiser4progs-1.0.6-shinkin/include/reiser4/plugin.h
> --- reiser4progs-1.0.6-namesys/include/reiser4/plugin.h 2006-11-01 
> 14:50:34.000000000 +0000
> +++ reiser4progs-1.0.6-shinkin/include/reiser4/plugin.h 2007-02-27 
> 15:25:16.000000000 +0000
> @@ -273,11 +273,10 @@ enum reiser4_crypto_id {
>
> enum reiser4_compress_mode_id {
>    CMODE_NONE_ID   = 0x0,
> -   CMODE_COL8_ID   = 0x1,
> -   CMODE_COL16_ID  = 0x2,
> -   CMODE_COL32_ID  = 0x3,
> +   CMODE_LATTD_ID  = 0x1,
> +   CMODE_ULTIM_ID  = 0x2,
> +   CMODE_FORCE_ID  = 0x3,
>    CMODE_CONVX_ID  = 0x4,
> -   CMODE_FORCE_ID  = 0x5,
>    CMODE_LAST_ID
> };
>
> diff -pruN reiser4progs-1.0.6-namesys/libreiser4/factory.c 
> reiser4progs-1.0.6-shinkin/libreiser4/factory.c
> --- reiser4progs-1.0.6-namesys/libreiser4/factory.c 2006-11-01 
> 14:50:34.000000000 +0000
> +++ reiser4progs-1.0.6-shinkin/libreiser4/factory.c 2007-02-27 
> 15:40:43.000000000 +0000
> @@ -269,11 +269,10 @@ errno_t reiser4_factory_init(void) {
>    __load_plug(gzip1);
>
>    __load_plug(nocompress);
> -   __load_plug(col8);
> -   __load_plug(col16);
> -   __load_plug(col32);
> -   __load_plug(convx);
> +   __load_plug(lattd);
> +   __load_plug(ultim);
>    __load_plug(force);
> +   __load_plug(convx);
>
>    __load_plug(clust64);
>    __load_plug(clust32);
> diff -pruN reiser4progs-1.0.6-namesys/libreiser4/profile.c 
> reiser4progs-1.0.6-shinkin/libreiser4/profile.c
> --- reiser4progs-1.0.6-namesys/libreiser4/profile.c 2006-11-01 
> 14:50:34.000000000 +0000
> +++ reiser4progs-1.0.6-shinkin/libreiser4/profile.c 2007-01-20 
> 11:08:31.000000000 +0000
> @@ -145,7 +145,7 @@ reiser4_profile_t defprof = {
>            .hidden = 0,
>            .max = CMODE_LAST_ID,
> #endif
> -           .id = {CMODE_COL8_ID, 0, CMODE_PLUG_TYPE},
> +           .id = {CMODE_CONVX_ID, 0, CMODE_PLUG_TYPE},
>        },
>        [PROF_CRYPTO] = {
> #ifndef ENABLE_MINIMAL
> diff -pruN reiser4progs-1.0.6-namesys/plugin/compress/compress_mode.c 
> reiser4progs-1.0.6-shinkin/plugin/compress/compress_mode.c
> --- reiser4progs-1.0.6-namesys/plugin/compress/compress_mode.c  
> 2006-11-01 14:50:34.000000000 +0000
> +++ reiser4progs-1.0.6-shinkin/plugin/compress/compress_mode.c  
> 2007-02-27 15:32:30.000000000 +0000
> @@ -19,22 +19,22 @@ reiser4_plug_t nocompress_plug = {
>    .desc  = "'Don't compress' compression mode plugin.",
> };
>
> -reiser4_plug_t col8_plug = {
> -   .id    = {CMODE_COL8_ID, 0, CMODE_PLUG_TYPE},
> -   .label = "col8",
> -   .desc  = "'Check on lattice-8' compression mode plugin.",
> +reiser4_plug_t lattd_plug = {
> +   .id    = {CMODE_LATTD_ID, 0, CMODE_PLUG_TYPE},
> +   .label = "latt",
> +   .desc  = "'Check on dynamic lattice' compression mode plugin.",
> };
>
> -reiser4_plug_t col16_plug = {
> -   .id    = {CMODE_COL16_ID, 0, CMODE_PLUG_TYPE},
> -   .label = "col16",
> -   .desc  = "'Check on lattice-16' compression mode plugin.",
> +reiser4_plug_t ultim_plug = {
> +   .id    = {CMODE_ULTIM_ID, 0, CMODE_PLUG_TYPE},
> +   .label = "ultim",
> +   .desc  = "'Check ultimately' compression mode plugin.",
> };
>
> -reiser4_plug_t col32_plug = {
> -   .id    = {CMODE_COL32_ID, 0, CMODE_PLUG_TYPE},
> -   .label = "col32",
> -   .desc  = "'Check on lattice-32' compression mode plugin.",
> +reiser4_plug_t force_plug = {
> +   .id    = {CMODE_FORCE_ID, 0, CMODE_PLUG_TYPE},
> +   .label = "force",
> +   .desc  = "'Compress evrything' compression mode plugin.",
> };
>
> reiser4_plug_t convx_plug = {
> @@ -42,11 +42,4 @@ reiser4_plug_t convx_plug = {
>    .label = "conv",
>    .desc  = "'Convert to extent' compression mode plugin.",
> };
> -
> -reiser4_plug_t force_plug = {
> -   .id    = {CMODE_FORCE_ID, 0, CMODE_PLUG_TYPE},
> -   .label = "force",
> -   .desc  = "'Compress evrything' compression mode plugin.",
> -};
> -
> #endif
>
>
>
> ________________________________________________________________________
> More new features than ever.  Check out the new AOL Mail ! - 
> http://webmail.aol.com
> -- 
> To unsubscribe from this list: send the line "unsubscribe 
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>
>
>

