Return-Path: <linux-kernel-owner+w=401wt.eu-S1756505AbZDNOoZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756505AbZDNOoZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 10:44:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752564AbZDNOoQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 10:44:16 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:54855 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243AbZDNOoP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 10:44:15 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Kevin Cernekee <kpc.mtd@gmail.com>
Subject: Re: [PATCH 3/4] [MTD] compat_ioctl cleanup
Date: Tue, 14 Apr 2009 16:43:47 +0200
User-Agent: KMail/1.9.9
Cc: David Woodhouse <dwmw2@infradead.org>,
       Adrian Hunter <adrian.hunter@nokia.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Linux MTD <linux-mtd@lists.infradead.org>
References: <a95a62fe0904082253i119f8660y6a73835a163394f5@mail.gmail.com>
In-Reply-To: <a95a62fe0904082253i119f8660y6a73835a163394f5@mail.gmail.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200904141643.48345.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+MRvlQRgDI107pE8e5ZJudweIeUUKj+yUhhqG
 xbFUXKcuq1lf2nne1E1QD42t9zHOmUcMoraQUSdHEiySPL+rIE
 oSR72c3tcnXD7ORAP1XzQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 09 April 2009, Kevin Cernekee wrote:

>    
> 1) Move the MEMREADOOB/MEMWRITEOOB compat_ioctl wrappers from
> fs/compat_ioctl.c into mtdchar.c .  Original request was here:
> 
> http://lkml.org/lkml/2009/4/1/295

Very nice cleanup, thanks for doing this!

> 2) Add missing COMPATIBLE_IOCTL lines, so that mtd-utils does not error
> out when running in 64/32 compatibility mode.

This looks correct, but I think it would be better to just remove all
those lines from fs/compat_ioctl.c and add a default: statement in
mtd_compat_ioctl that calls mtd_ioctl for all ioctl numbers that
don't have an explicit handler.

	Arnd <><
