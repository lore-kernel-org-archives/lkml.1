Return-Path: <linux-kernel-owner+w=401wt.eu-S1755382AbZGUPXr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755382AbZGUPXr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 11:23:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755246AbZGUPXq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 11:23:46 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:56269 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754686AbZGUPXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 11:23:45 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: x86: IPC driver patch for Intel Moorestown platform
Date: Tue, 21 Jul 2009 17:23:36 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-3-generic; KDE/4.2.96; x86_64; ; )
Cc: "Gurudatt, Sreenidhi B" <sreenidhi.b.gurudatt@intel.com>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@linux.intel.com>
References: <98769532B4BB14429434178695419EAE5F3F9541@bgsmsx501.gar.corp.intel.com> <200907211700.21059.arnd@arndb.de> <20090721161023.7607ea7f@lxorguk.ukuu.org.uk>
In-Reply-To: <20090721161023.7607ea7f@lxorguk.ukuu.org.uk>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200907211723.36862.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18Lw0oEK5X0vOkpN0adzgIiXeJWhoW+C2RUTM5
 BfoPv4uwj7j45JXC+ZO1MHENFC3/6XQnqTwEjGIw5rWGuhScWN
 InwnEHolmZKjl9UHgVYyw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 21 July 2009, Alan Cox wrote:
> > 1. built-in code adds platform-device for mrst_ipc
> > 2. user space auto-loads the mrst_ipc driver
> > 3. mrst_ipc driver creates child devices for each of its attached
> >    devices
> 
> The devices talking to it already are devices - but they will be input
> devices, watchdogs, etc. They already belong in existing classes.

Remember that devices normally are both in the /sys/class hierarchy
as a class device and in the /sys/devices hierarchy based on their
attachment.

> I also don't believe the mrst ipc is enumerable either. If it was
> enumerable it would make a lot more sense.

It could be done along the same lines as ./drivers/input/serio/i8042.c:

The platform knows when an i8042 chip is present and adds the
serio devices it statically knows about. The serio driver then
adds input class devices for them. You probably wouldn't /have/
to add a new bus_type but could reuse nested platform devices.

	Arnd <><
