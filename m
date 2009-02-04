Return-Path: <linux-kernel-owner+w=401wt.eu-S1752638AbZBDOCp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638AbZBDOCp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 09:02:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751143AbZBDOCg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 09:02:36 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:57259 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025AbZBDOCf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 09:02:35 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Subject: Re: usr/include/linux/soundcard.h warnings for 'make headers_check'
Date: Wed, 4 Feb 2009 15:02:07 +0100
User-Agent: KMail/1.9.9
Cc: Takashi Iwai <tiwai@suse.de>, Sam Ravnborg <sam@ravnborg.org>,
       alsa-devel@alsa-project.org, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
References: <1232465902.3088.31.camel@localhost.localdomain> <200902041351.18596.arnd@arndb.de> <1233755062.3135.3.camel@localhost.localdomain>
In-Reply-To: <1233755062.3135.3.camel@localhost.localdomain>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200902041502.08055.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+i2Hoahdro7r+uHLd4mKmRQUQQUcnj8JlVHJ7
 5FNtkJMz4rR8SJ32eSdU+5Upq/lx9oprsz9hCHdxj4rG0MqMSs
 Dd7DH7eWTibPWt1GHsQNQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 February 2009, Jaswinder Singh Rajput wrote:
> > +#define _SEQ_EXTERN extern
> > +#define SEQ_USE_EXTBUF() \
> > +             _SEQ_EXTERN unsigned char _seqbuf[]; \
> > +             _SEQ_EXTERN int _seqbuflen;_SEQ_EXTERN int _seqbufptr
> 
> hmm, you rename snake as rope, but actually snake is still there ;-)

Yes, that's true.

The alternative would be to remove all those macros entirely, breaking
also the applications from number 2 in my list.

I see this header as another example of the byteorder.h type where
a kernel header provides functionality that is used by existing
applications. While it should have been part of a library to start
with, we cannot change it any more now without breaking stuff.

Maybe a comment should be added to clarify this.

	Arnd <><

--- a/include/linux/soundcard.h
+++ b/include/linux/soundcard.h
@@ -1050,7 +1050,17 @@ typedef struct mixer_vol_table {
  *	Some convenience macros to simplify programming of the
  *	/dev/sequencer interface
  *
- *	These macros define the API which should be used when possible.
+ *	This is a legacy interface for applications written against
+ *	the OSSlib-3.8 style interface. It is no longer possible
+ *	to actually link against OSSlib with this header, but we
+ *	still provide these macros for programs using them.
+ *
+ *	If you want to use OSSlib, it is recommended that you get
+ *	the GPL version of OSS-4.x and build against that version
+ *	of the header.
+ *
+ *	We redefine the extern keyword so that make headers_check
+ *	does not complain about SEQ_USE_EXTBUF.
  */
 #define SEQ_DECLAREBUF()		SEQ_USE_EXTBUF()
 
