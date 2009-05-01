Return-Path: <linux-kernel-owner+w=401wt.eu-S1757673AbZEAMxy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757673AbZEAMxy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 08:53:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755119AbZEAMxo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 08:53:44 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:61798 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753181AbZEAMxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 08:53:44 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Subject: Re: [PATCH 04/27] asm-generic: add legacy I/O header files
Date: Fri, 1 May 2009 14:53:31 +0200
User-Agent: KMail/1.9.9
Cc: Michal Simek <monstr@monstr.eu>, linux-arch@vger.kernel.org,
       Remis Lima Baima <remis.developer@googlemail.com>,
       linux-kernel@vger.kernel.org
References: <cover.1241105648.git.arnd@arndb.de> <49FAEA2A.50504@monstr.eu> <20090501123728.GC27799@flint.arm.linux.org.uk>
In-Reply-To: <20090501123728.GC27799@flint.arm.linux.org.uk>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905011453.32006.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+2/LxYLynCVT1VTH40gq2AqRLGqZxTiCRyCT5
 IHc4VYIk6fX4fyS3h1mJaaKU+8rZBAIY9HRk3o6usK0VUBSHuE
 ca7V6VNEU6wlmiK0x/zaQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 01 May 2009, Russell King wrote:
> > > All of these are either PC-specific, or they don't actually care
> > > about the specific value. Most architectures just use the
> > > value from the IBM PC, so we might as well make that the generic
> > > default.
> > 
> > ok. Let's move out from arch to generic location.
> 
> That's only possible once the users have been fixed - otherwise the ARM
> stuff listed above _will_ break.

My idea was to just add a fallback of

#ifndef CLOCK_TICK_RATE
#define CLOCK_TICK_RATE                1193182
#endif

to include/linux/timex.h. Since al existing architectures already define
CLOCK_TICK_RATE as a macro, I don't see anything changing for them.

The only difference would be that all architectures that use the default
value can have an empty timex.h.

Am I missing something?

	Arnd <><
