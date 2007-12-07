Return-Path: <linux-kernel-owner+w=401wt.eu-S1757351AbXLGV6k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757351AbXLGV6k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 16:58:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750767AbXLGV6b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 16:58:31 -0500
Received: from moutng.kundenserver.de ([212.227.126.179]:64405 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753899AbXLGV6a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 16:58:30 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linuxppc-dev@ozlabs.org, balbir@linux.vnet.ibm.com
Subject: Re: [PATCH] Fake NUMA emulation for PowerPC
Date: Fri, 7 Dec 2007 22:58:17 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       LKML <linux-kernel@vger.kernel.org>
References: <20071207211425.10223.91240.sendpatchset@balbir-laptop> <4759BCBA.7060800@linux.vnet.ibm.com> <4759BE88.3020702@linux.vnet.ibm.com>
In-Reply-To: <4759BE88.3020702@linux.vnet.ibm.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200712072258.19331.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+6oO9O92vpDts4pGcX3clSV5y4MgdQ6nTZ1TW
 dXEP+6YCaNrSdePY8YV5mMsb97yGzP5mG5eAAcDzYJVBPF47io
 bmt+yBRTwpFXibfQDHNgQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 December 2007, Balbir Singh wrote:
> Balbir Singh wrote:
> > Geert Uytterhoeven wrote:
> >> On Sat, 8 Dec 2007, Balbir Singh wrote:
> >>> +   if (strstr(p, "fake="))
> >>> +           cmdline = p + 5;        /* 5 is faster than strlen("fake=") */
> >> Really? My gcc is smart enough to replace the `strlen("fake=")' by 5, even
> >> without -O.
> >>
> > 
> > Thanks for pointing that out, but I am surprised that a compiler would
> > interpret library routines like strlen.
> > 
> 
> I just tested it and it turns out that you are right. I'll go hunt to
> see where gcc gets its magic powers from.
> 

Even if it wasn't: Why the heck would you want to optimize this? The function
is run _once_ at boot time and the object code gets thrown away afterwards!

	Arnd <><
