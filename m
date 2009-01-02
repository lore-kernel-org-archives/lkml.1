Return-Path: <linux-kernel-owner+w=401wt.eu-S1759252AbZABWxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759252AbZABWxY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 17:53:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753958AbZABWxP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 17:53:15 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:51321 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753501AbZABWxP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 17:53:15 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH v2] linux/types.h: always export 64bit aligned defines
Date: Fri, 2 Jan 2009 23:53:06 +0100
User-Agent: KMail/1.9.9
Cc: Andreas Schwab <schwab@suse.de>, linux-kernel@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>, David Woodhouse <dwmw2@infradead.org>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Patrick McHardy <kaber@trash.net>,
       "David S. Miller" <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>
References: <1230885562-11456-1-git-send-email-vapier@gentoo.org> <jer63lfjy0.fsf@sykes.suse.de> <200901021706.25276.vapier@gentoo.org>
In-Reply-To: <200901021706.25276.vapier@gentoo.org>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200901022353.07200.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19tU9e6ULP1OGKsMju7fg43vQiznsv0kfEYp0u
 jcdKSvmCoPureuvZz/9iIcTb+jzRgqtyS6+s9VXNfZbSYxuvGY
 LNebdjqAH8T8KutOGrG+Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 January 2009, Mike Frysinger wrote:
> On Friday 02 January 2009 16:59:35 Andreas Schwab wrote:
>
> > I mean that it may conflict with normal userspace which is the whole
> > point of being hidden.
> 
> no, there is nothing in userspace that i know of that defines this type.  i 
> mentioned this in the changelog already.

What Andreas is trying to explain to you is that the definition of
__KERNEL_STRICT_NAMES is that you would get no definitions that can
possibly pollute the name space, rather than not adding any known
conflicts (which we try with and without __KERNEL_STRICT_NAMES).

The correct patch would add new definitions for __kernel_aligned_{u,be,le}64
types that can be safely used in public data structures even with
__KERNEL_STRICT_NAMES set, and then add the existing names
for convenience for use inside of the kernel, as we do for all the
common types.

	Arnd <><
