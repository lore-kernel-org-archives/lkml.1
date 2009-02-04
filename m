Return-Path: <linux-kernel-owner+w=401wt.eu-S1756268AbZBDNpT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756268AbZBDNpT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 08:45:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751423AbZBDNpE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 08:45:04 -0500
Received: from hera.kernel.org ([140.211.167.34]:43289 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751239AbZBDNpC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 08:45:02 -0500
Subject: Re: usr/include/linux/soundcard.h warnings for 'make headers_check'
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Takashi Iwai <tiwai@suse.de>, Sam Ravnborg <sam@ravnborg.org>,
       alsa-devel@alsa-project.org, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <200902041351.18596.arnd@arndb.de>
References: <1232465902.3088.31.camel@localhost.localdomain>
	 <1233747097.5563.29.camel@localhost.localdomain>
	 <s5hk586a0mw.wl%tiwai@suse.de>  <200902041351.18596.arnd@arndb.de>
Content-Type: text/plain
Date: Wed, 04 Feb 2009 19:14:22 +0530
Message-Id: <1233755062.3135.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-02-04 at 13:51 +0100, Arnd Bergmann wrote:

> ---
> This patch breaks building against OSSlib with the kernel headers
> instead of its own headers. It should still work with any
> version of the library from the 2003 onwards which provide
> their own headers for the latest interface.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> 
> --- a/include/linux/soundcard.h
> +++ b/include/linux/soundcard.h
> @@ -1045,7 +1045,7 @@ typedef struct mixer_vol_table {
>   */
>  #define LOCL_STARTAUDIO		1
>  
> -#if (!defined(__KERNEL__) && !defined(KERNEL) && !defined(INKERNEL) && !defined(_KERNEL)) || defined(USE_SEQ_MACROS) 
> +#if !defined(__KERNEL__) || defined(USE_SEQ_MACROS)
>  /*
>   *	Some convenience macros to simplify programming of the
>   *	/dev/sequencer interface
> @@ -1056,39 +1056,15 @@ typedef struct mixer_vol_table {
>  
>  void seqbuf_dump(void);	/* This function must be provided by programs */
>  
> -extern int OSS_init(int seqfd, int buflen);
> -extern void OSS_seqbuf_dump(int fd, unsigned char *buf, int buflen);
> -extern void OSS_seq_advbuf(int len, int fd, unsigned char *buf, int buflen);
> -extern void OSS_seq_needbuf(int len, int fd, unsigned char *buf, int buflen);
> -extern void OSS_patch_caching(int dev, int chn, int patch,
> -			      int fd, unsigned char *buf, int buflen);
> -extern void OSS_drum_caching(int dev, int chn, int patch,
> -			      int fd, unsigned char *buf, int buflen);
> -extern void OSS_write_patch(int fd, unsigned char *buf, int len);
> -extern int OSS_write_patch2(int fd, unsigned char *buf, int len);
> -
>  #define SEQ_PM_DEFINES int __foo_bar___
> -#ifdef OSSLIB
> -#  define SEQ_USE_EXTBUF() \
> -		extern unsigned char *_seqbuf; \
> -		extern int _seqbuflen;extern int _seqbufptr
> -#  define SEQ_DEFINEBUF(len) SEQ_USE_EXTBUF();static int _requested_seqbuflen=len
> -#  define _SEQ_ADVBUF(len) OSS_seq_advbuf(len, seqfd, _seqbuf, _seqbuflen)
> -#  define _SEQ_NEEDBUF(len) OSS_seq_needbuf(len, seqfd, _seqbuf, _seqbuflen)
> -#  define SEQ_DUMPBUF() OSS_seqbuf_dump(seqfd, _seqbuf, _seqbuflen)
> -
> -#  define SEQ_LOAD_GMINSTR(dev, instr) \
> -		OSS_patch_caching(dev, -1, instr, seqfd, _seqbuf, _seqbuflen)
> -#  define SEQ_LOAD_GMDRUM(dev, drum) \
> -		OSS_drum_caching(dev, -1, drum, seqfd, _seqbuf, _seqbuflen)
> -#else /* !OSSLIB */
> -
> -#  define SEQ_LOAD_GMINSTR(dev, instr)
> -#  define SEQ_LOAD_GMDRUM(dev, drum)
> -
> -#  define SEQ_USE_EXTBUF() \
> -		extern unsigned char _seqbuf[]; \
> -		extern int _seqbuflen;extern int _seqbufptr
> +
> +#define SEQ_LOAD_GMINSTR(dev, instr)
> +#define SEQ_LOAD_GMDRUM(dev, drum)
> +
> +#define _SEQ_EXTERN extern
> +#define SEQ_USE_EXTBUF() \
> +		_SEQ_EXTERN unsigned char _seqbuf[]; \
> +		_SEQ_EXTERN int _seqbuflen;_SEQ_EXTERN int _seqbufptr

hmm, you rename snake as rope, but actually snake is still there ;-)

--
JSR

