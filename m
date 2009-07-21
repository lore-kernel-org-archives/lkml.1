Return-Path: <linux-kernel-owner+w=401wt.eu-S1755781AbZGUQfp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755781AbZGUQfp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 12:35:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755767AbZGUQfo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 12:35:44 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:61307 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755763AbZGUQfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 12:35:43 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Gurudatt, Sreenidhi B" <sreenidhi.b.gurudatt@intel.com>
Subject: Re: x86: IPC driver patch for Intel Moorestown platform
Date: Tue, 21 Jul 2009 18:35:36 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-3-generic; KDE/4.2.96; x86_64; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@linux.intel.com>
References: <98769532B4BB14429434178695419EAE5F3F9541@bgsmsx501.gar.corp.intel.com> <200907211723.36862.arnd@arndb.de> <98769532B4BB14429434178695419EAE5F45B41A@bgsmsx501.gar.corp.intel.com>
In-Reply-To: <98769532B4BB14429434178695419EAE5F45B41A@bgsmsx501.gar.corp.intel.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200907211835.36195.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+w98lSMOYp8O+oQiv9uJS0q+Aa6gQFoAfCw6s
 uQgFTH+EQguQxnjSFCQ72yEH9/Litmrxm2npl+uOh8xJT4mVHy
 U/gQmOG39itS/7y6QI4mkn25ItWLmB2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 21 July 2009, Gurudatt, Sreenidhi B wrote:
> On Tuesday 21 July 2009, Alan Cox wrote:
> > > 1. built-in code adds platform-device for mrst_ipc
> > > 2. user space auto-loads the mrst_ipc driver
>
> The IPC driver APIs for host drivers communicate with the SCU 
> (System Controller Unit) firmware on the platform. It is used
> by many Moorestown platform specific drivers such as Audio,
> Touch Screen, GPIO, Battery, Power Management etc for accessing
> PMIC (Power Management Interrupt Controller). It will typically
> get loaded during boot and gets unloaded on shutdown.
> I don't think it should be loaded and unloaded by the user-space apps.

Well, all modules get loaded from user space (modprobe)
by definition, I was not referring to interactive applictions.

The real difference is whether it can get autoloaded at
boot time by udev based on the present device nodes, or
you need to manually put it into /etc/modules.

If you simply create platform devices at boot time,
you get both the autoloading and a reasonable representation
in /sys/devices/platform/mrst_ipc/... for free.

	Arnd <><
