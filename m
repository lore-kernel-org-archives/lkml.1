Return-Path: <linux-kernel-owner+w=401wt.eu-S1756126AbZFVLRa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126AbZFVLRa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 07:17:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755932AbZFVLRJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 07:17:09 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:51868 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788AbZFVLRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 07:17:06 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Marco Stornelli <marco.stornelli@gmail.com>
Subject: Re: [PATCH 06/14] Pramfs: Include files
Date: Mon, 22 Jun 2009 13:17:03 +0200
User-Agent: KMail/1.11.90 (Linux/2.6.30-9-generic; KDE/4.2.90; x86_64; ; )
Cc: Sam Ravnborg <sam@ravnborg.org>,
       Linux FS Devel <linux-fsdevel@vger.kernel.org>,
       Linux Embedded <linux-embedded@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
References: <4A33A7EC.6070008@gmail.com> <200906212222.25434.arnd@arndb.de> <2ea1731b0906212323h6ed8621dg22e1bc8638c26e2c@mail.gmail.com>
In-Reply-To: <2ea1731b0906212323h6ed8621dg22e1bc8638c26e2c@mail.gmail.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200906221317.04166.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18hQYR++B+G5ScPJYhHDCwkmSX9dotsbGUKcwr
 Oy32NuvJOSysApZjE0Vh0j7GVneUwv/duWBchKSO2mn/ey5XHj
 xRuXPFLfQimoW/FiPr3zredvu0Y4wQn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 22 June 2009, Marco Stornelli wrote:
> > It's still a problem. You might be creating a file system image
> > for an embedded board with a different endianess.
> 
> It's not possible to create an "image" with pramfs, it's like tmpfs.

But the data is persistant, you even support using it as a root file
system, so the data has to have a way to get there. Even if you
don't do it right now, I don't see any fundamental limitation that
prevents you from creating an image on one machine and dumping it
into the nvram of another machine as part of manufacturing or testing.

> > Or even on the same machine, you could be looking at the file system contents
> > with a 32 bit process running on a 64 bit kernel.
> 
> Yes, indeed the most important thing is to be sure that a 64bit kernel
> works well. I'll try to test it in this environment. If there are
> "64bit guys" to help me to test it, it'd be great.

This particular problem (__kernel_off_t on 64-bit machines) can be avoided
by just switching to __kernel_loff_t, which is 64 bit long on all machines,
while __kernel_off_t is always the register length (32 or 64 bits).

	Arnd <><
