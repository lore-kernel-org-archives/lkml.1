Return-Path: <linux-kernel-owner+w=401wt.eu-S1762296AbZATRrg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762296AbZATRrg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 12:47:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757088AbZATRrY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 12:47:24 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:52468 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756693AbZATRrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 12:47:23 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Subject: Re: why usr/include/linux/if_frad.h is required
Date: Tue, 20 Jan 2009 18:47:01 +0100
User-Agent: KMail/1.9.9
Cc: mike.mclagan@linux.org, Ingo Molnar <mingo@elte.hu>,
       Sam Ravnborg <sam@ravnborg.org>, netdev@vger.kernel.org,
       davem@davemloft.net, LKML <linux-kernel@vger.kernel.org>
References: <1232463174.3088.15.camel@localhost.localdomain> <1232463242.3088.16.camel@localhost.localdomain>
In-Reply-To: <1232463242.3088.16.camel@localhost.localdomain>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901201847.03030.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX198St2+I1CAP9KxmMK/gEVXrb/MNVbwzaZYT0x
 zA7iUvHmML1BngiP+55wE3PwMc+wksvnPygXpNkwymtlxfrB/A
 +aRe9Csuy4zgoMjuLdApQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 January 2009, Jaswinder Singh Rajput wrote:
> CC: LKML
> 
> On Tue, 2009-01-20 at 20:23 +0530, Jaswinder Singh Rajput wrote:
> > For if_frad.h I am getting two warnings with 'make headers_check':
> >   usr/include/linux/if_frad.h:29: leaks CONFIG_DLCI to userspace where it is not valid
> >   usr/include/linux/if_frad.h:129: leaks CONFIG_DLCI to userspace where it is not valid
> > 
> > Almost all if_frad.h is covered with #if defined(CONFIG_DLCI) || defined(CONFIG_DLCI_MODULE) 
> > 
> > If I remove this portion so only this what we get in userspace:
> > 
> > #ifndef _FRAD_H_
> > #define _FRAD_H_
> > 
> > #include <linux/if.h>
> > 
> > #endif
> > 
> > So I am surprising what is the point of this ? 
> > 
> > Can I change its name to is_fraud ;-)

The CONFIG_DLCI check in there is clearly in error, the definition in there
is a user interface. The obvious solution is to drop the #if / #endif pair
without a replacement.

	Arnd <><
