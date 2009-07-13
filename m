Return-Path: <linux-kernel-owner+w=401wt.eu-S1752120AbZGMSxl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752120AbZGMSxl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 14:53:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751561AbZGMSxl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 14:53:41 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:55197 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbZGMSxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 14:53:40 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg KH <gregkh@suse.de>
Subject: Re: [PATCH 0/2] fbdev: add fillrect and copyarea ioctls
Date: Mon, 13 Jul 2009 20:53:12 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-2-generic; KDE/4.2.96; x86_64; ; )
Cc: Ali Gholami Rudi <ali@rudi.ir>,
       fbdev <linux-fbdev-devel@lists.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrea Righi <righi.andrea@gmail.com>,
       Krzysztof Helt <krzysztof.h1@wp.pl>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Philippe De Muyter <phdm@macqel.be>, linux-kernel@vger.kernel.org
References: <20090713151709.GA1297@lilem.mirepesht> <20090713163530.GA22251@suse.de>
In-Reply-To: <20090713163530.GA22251@suse.de>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200907132053.13032.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+sl+BFieMK0CiGdf1g2jw1ML+8cnMpTqi6Tyi
 8Ow78BhGSWSM6mrsiYFEjcPhLuOHHnE3CClpb/qvTadlq2cpjA
 gM26X9/PHrNAFFmkDvJZQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 13 July 2009, Greg KH wrote:
> On Mon, Jul 13, 2009 at 07:47:09PM +0430, Ali Gholami Rudi wrote:
> > Hi,
> > 
> > Is there any reason for not adding these ioctls to fbdev?  I searched
> > the net and couldn't any.  Anyway, these patches simply implement those
> > ioctls.
> 
> Have you also added the needed 32 vs. 64 bit handlers for these ioctls?
> 

They are not there, but could be trivially added with

diff --git a/drivers/video/fbmem.c b/drivers/video/fbmem.c
index f8a09bf..ce107c4 100644
--- a/drivers/video/fbmem.c
+++ b/drivers/video/fbmem.c
@@ -1285,6 +1285,8 @@ static long fb_compat_ioctl(struct file *file, unsigned int cmd,
 	case FBIOPAN_DISPLAY:
 	case FBIOGET_CON2FBMAP:
 	case FBIOPUT_CON2FBMAP:
+	case FBIOCOPYAREA:
+	case FBIOFILLRECT:
 		arg = (unsigned long) compat_ptr(arg);
 	case FBIOBLANK:
 		ret = do_fb_ioctl(info, cmd, arg);


Unfortunately, it would not be as easy to add an FBIOIMAGE, which sounds
equally useful.

	Arnd <><
