Return-Path: <linux-kernel-owner+w=401wt.eu-S1764175AbZAUMNz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764175AbZAUMNz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 07:13:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757943AbZAUMNp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 07:13:45 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:62608 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757575AbZAUMNo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 07:13:44 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: Confusion in usr/include/asm-generic/fcntl.h
Date: Wed, 21 Jan 2009 13:13:16 +0100
User-Agent: KMail/1.9.9
Cc: Helge Deller <deller@gmx.de>, David Miller <davem@davemloft.net>,
       jaswinder@kernel.org, mingo@elte.hu, x86@kernel.org,
       linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
       Kyle McMartin <kyle@mcmartin.ca>
References: <1232496257.3123.19.camel@localhost.localdomain> <200901210924.23484.arnd@arndb.de> <20090121113853.GB1579@uranus.ravnborg.org>
In-Reply-To: <20090121113853.GB1579@uranus.ravnborg.org>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200901211313.17394.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18j7iXv/AAuslwcLlDS0eK1Lf5TdLZ66HH7aLR
 ZygF2RfLfNz5hEuuyfeIBkmX4GGGeQ57U2AM+JtnzZJEvTl32W
 423SSfIAdJmsqtS5TBctA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 January 2009, Sam Ravnborg wrote:
> Could we add a new symbol for this?
> We know we are going to use this in several places so a simpler variant
> would be more readable.
> 
> Something like:
> 
> #ifdef __64BIT
> ...
> #endif
> 
> When we define __64BIT we would use the  __BITS_PER_LONG == 64 check.

I would prefer using the __BITS_PER_LONG == 64 check directly, because
it gives you a warning when __BITS_PER_LONG is undefined, whereas the
#ifdef check gets easily fooled by include order problems. Note that
this is not a problem in the kernel for CONFIG_* symbols which are
always defined before the first #include.

	Arnd <><
