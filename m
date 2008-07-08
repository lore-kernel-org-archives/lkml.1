Return-Path: <linux-kernel-owner+w=401wt.eu-S1756170AbYGHOpk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756170AbYGHOpk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 10:45:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751588AbYGHOpa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 10:45:30 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:49314 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460AbYGHOp3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 10:45:29 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Maxim Shchetynin <maxim@linux.vnet.ibm.com>
Subject: Re: AZFS file system proposal
Date: Tue, 8 Jul 2008 16:42:18 +0200
User-Agent: KMail/1.9.9
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>,
       Segher Boessenkool <segher@kernel.crashing.org>,
       Gunnar von Boehn <VONBOEHN@de.ibm.com>, Mark Nelson <markn@au1.ibm.com>
References: <20080618160629.6cd749a8@mercedes-benz.boeblingen.de.ibm.com> <200807011659.33413.arnd@arndb.de> <20080707173923.17dc6c05@mercedes-benz.boeblingen.de.ibm.com>
In-Reply-To: <20080707173923.17dc6c05@mercedes-benz.boeblingen.de.ibm.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200807081642.19507.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18CrVst8tuEwQfUTCSiiFetZVTL2VuvwUpkddm
 35Wt5Um6DU7jj6Nok4cdbFWaTWatPh7OGDriD9rIhtcQViuCVw
 Fspxyhmy0CqEEKYv7SMdw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 07 July 2008, Maxim Shchetynin wrote:
> > > +           if (copy_to_user(target, (void*) pin, size)) {
> > > +                   rc = -EFAULT;
> > > +                   goto out;
> > > +           }
> > 
> > Question to the powerpc folks: is copy_to_user safe for an __iomem source?
> > Should there be two copies (memcpy_fromio and copy_to_user) instead?
> 
> I leave this question open.
> 

Cc:'ing some more people that might have more of a clue on this question.
_memcpy_fromio does a "sync" at the start and an "eieio" at the end.
IFAICT, neither are needed here because the source is always memory.

It also handles unaligned memory accesses, which copy_to_user should
also do correctly, so it *looks* like it should work with just a
copy_to_user, but it still feels wrong to use an __iomem pointer
as the source for a copy_to_user.

Any ideas?

	Arnd <><
