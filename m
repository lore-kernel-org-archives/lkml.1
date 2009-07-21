Return-Path: <linux-kernel-owner+w=401wt.eu-S1756208AbZGUVR4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208AbZGUVR4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 17:17:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756115AbZGUVRx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 17:17:53 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:57322 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755898AbZGUVP5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 17:15:57 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: Do cpu-endian MMIO accessors exist?
Date: Tue, 21 Jul 2009 23:15:49 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-3-generic; KDE/4.2.96; x86_64; ; )
Cc: Pekka Paalanen <pq@iki.fi>, linux-kernel@vger.kernel.org
References: <20090721234243.1928d9e2@daedalus.pq.iki.fi> <4A662C33.7080505@gmail.com>
In-Reply-To: <4A662C33.7080505@gmail.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <200907212315.50225.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18iai+yafHkOdsJDhZDkWL+lQl+Y7OS+5c3mqI
 yofkgcVYE/cWs2NNDYkYTfE3I00ZdywmGmxDxAznwQZ+FmEKFS
 USIIddaHG/l0fZEEVDLVg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 21 July 2009, Jiri Slaby wrote:
> > Do cpu-endian MMIO accessors exist? What should I use, or do I just
> > have to use #ifdef __BIG_ENDIAN?
> 
> There is __raw_readl which doesn't switch bytes.

__raw_readl is not a replacement for real accessors like
ioread32 or in_be32, because it does not synchronize with the
instruction stream.

The best solution would be if you could find a way to set
the hardware into little-endian mode on all architectures.
>From the description, it sounds like the hardware should allow that.

	Arnd <><
