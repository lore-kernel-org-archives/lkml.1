Return-Path: <linux-kernel-owner+w=401wt.eu-S1761601AbZBYV7j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761601AbZBYV7j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 16:59:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756590AbZBYV73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 16:59:29 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:62939 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892AbZBYV72 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 16:59:28 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] Make exported headers use strict posix types
Date: Wed, 25 Feb 2009 22:58:29 +0100
User-Agent: KMail/1.9.9
Cc: Kyle McMartin <kyle@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>, mingo@redhat.com,
       dwmw2@infradead.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
References: <20090225032553.GD6690@bombadil.infradead.org> <200902251917.49017.arnd@arndb.de> <20090225201131.GA26110@uranus.ravnborg.org>
In-Reply-To: <20090225201131.GA26110@uranus.ravnborg.org>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200902252258.30489.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+tNh++sTsezaWhb3iZLfDrUZS25cRC+QAqDo6
 2822MmQTE9unUM2YGZLWvnkNFJxMULAjAzorfXpFlMxSeZjY0y
 SaJTJv8lnJmx4qgfoDbbA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 February 2009, Sam Ravnborg wrote:
> > diff --git a/include/linux/mroute6.h b/include/linux/mroute6.h
> > index 5375fac..43dc97e 100644
> > --- a/include/linux/mroute6.h
> > +++ b/include/linux/mroute6.h
> > @@ -65,7 +65,7 @@ struct mif6ctl {
> >       mifi_t  mif6c_mifi;             /* Index of MIF */
> >       unsigned char mif6c_flags;      /* MIFF_ flags */
> >       unsigned char vifc_threshold;   /* ttl limit */
> > -     u_short  mif6c_pifi;            /* the index of the physical IF */
> > +     __u16    mif6c_pifi;            /* the index of the physical IF */
> >       unsigned int vifc_rate_limit;   /* Rate limiter values (NI) */
> >  };
> >  
> This change looks correct - but I assume this is a separate patch.
> 

Actually, this change does belong in here: This is the only user of u_short
in exported headers, and nothing uses u_char, u_int or u_long, so it gets
rid of a whole class of types. The only questionable types left after this
are the standard stdint.h types, many of which are probably legitimate:

grep '\<\(u_\|u\|\)int\(8\|16\|32\|64\)_t\>' obj/usr/include/ -r | \
		 cut -f 1 -d: | uniq -c | grep -v netfilter
      2 obj/usr/include/linux/atmlec.h
     13 obj/usr/include/linux/jffs2.h
      1 obj/usr/include/linux/ivtvfb.h
     12 obj/usr/include/linux/types.h
    121 obj/usr/include/linux/pfkeyv2.h
     13 obj/usr/include/linux/ip_vs.h
     21 obj/usr/include/linux/dm-ioctl.h
      4 obj/usr/include/linux/cm4000_cs.h
      8 obj/usr/include/linux/dlm_netlink.h
      2 obj/usr/include/linux/selinux_netlink.h
     11 obj/usr/include/linux/dvb/video.h
      1 obj/usr/include/linux/dvb/audio.h
     22 obj/usr/include/linux/atmmpc.h
     23 obj/usr/include/linux/coda.h
      1 obj/usr/include/linux/matroxfb.h
     13 obj/usr/include/linux/if_arcnet.h
      8 obj/usr/include/drm/mga_drm.h
      1 obj/usr/include/drm/radeon_drm.h
     20 obj/usr/include/drm/via_drm.h
      9 obj/usr/include/drm/drm.h
     74 obj/usr/include/drm/drm_mode.h
     69 obj/usr/include/drm/i915_drm.h
     15 obj/usr/include/mtd/nftl-user.h
      2 obj/usr/include/mtd/jffs2-user.h
     18 obj/usr/include/mtd/inftl-user.h
     32 obj/usr/include/mtd/mtd-abi.h
     35 obj/usr/include/mtd/ubi-user.h
      4 obj/usr/include/sound/emu10k1.h
      1 obj/usr/include/sound/asound.h

	Arnd <><
