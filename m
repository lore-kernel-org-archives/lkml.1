Return-Path: <linux-kernel-owner+w=401wt.eu-S1758142AbZD2P5t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758142AbZD2P5t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 11:57:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753741AbZD2P5j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 11:57:39 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:54394 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752585AbZD2P5j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 11:57:39 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: monstr@monstr.eu
Subject: Re: [PATCH 20/30] microblaze_mmu_v1: uaccess MMU update
Date: Wed, 29 Apr 2009 17:55:37 +0200
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       john.williams@petalogix.com
References: <1240821139-7247-1-git-send-email-monstr@monstr.eu> <200904291735.28964.arnd@arndb.de> <49F875B1.2050502@monstr.eu>
In-Reply-To: <49F875B1.2050502@monstr.eu>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200904291755.38497.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/jvLPTefXiVZro0lSuZELqx5I9qnPf6t7tGFL
 xi+GtkwhI6fUPvamhhn1zLyhtXsfoNVECMMkaMnxvJ2CNQpHXy
 3MSaR1YBLaShJtOP47HpQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 29 April 2009, Michal Simek wrote:
> For powerpc I found these tree references. Where is the __get_user_bad definition?

> arch/powerpc/include/asm/uaccess.h:216:extern long __get_user_bad(void);
> arch/powerpc/include/asm/uaccess.h:263:         (x) = __get_user_bad();                         \
> arch/powerpc/include/asm/uaccess.h:269: default: (x) = __get_user_bad();                        \
> 

As I tried to explain, the whole point is that there is no definition
at all, just a declaration.
Normally, the compiler will discard the 'default:' case of get_user,
so the function is not called. However, if you pass a variable of
a length other than 1, 2, or 4, the compiler will generate a function
call to __get_user_bad in the object file. When you try to link
the kernel afterwards, you will get an error message like

Unknown symbol __get_user_bad" for drivers/foo/bar.o

which tells you that some function in drivers/foo/bar.c calls
get_user with an invalid argument.

	Arnd <><
