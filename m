Return-Path: <linux-kernel-owner+w=401wt.eu-S1760418AbYFLUxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760418AbYFLUxS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 16:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754152AbYFLUxI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 16:53:08 -0400
Received: from moutng.kundenserver.de ([212.227.126.179]:64166 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754108AbYFLUxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 16:53:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: eranian@gmail.com
Subject: Re: [patch 02/21] perfmon2 minimal: generic headers
Date: Thu, 12 Jun 2008 22:52:46 +0200
User-Agent: KMail/1.9.9
Cc: "Arjan van de Ven" <arjan@infradead.org>, linux-kernel@vger.kernel.org
References: <484dafc4.0af6660a.54fb.1b26@mx.google.com> <20080610072914.3b6b2cfe@infradead.org> <7c86c4470806110049g76247b4ex5e1b77af78d8dd7c@mail.gmail.com>
In-Reply-To: <7c86c4470806110049g76247b4ex5e1b77af78d8dd7c@mail.gmail.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806122252.46849.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19abnJennJnODEBY0PSglyeokahEekJaBHOOJ6
 r8wpYoxrtxHceJIez/iZUzhLjJNRJ2oaMMy6svR4rvxWPlI/wt
 OWaSXqeUefrWtUEsOHZZQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 11 June 2008, stephane eranian wrote:
> > I'm very nervous when seeing something like this in userspace headers;
> > you need to assume that the app has been compiled with a very different
> > version of the headers than the currently running kernel.... either the
> > version of perfmon doesn't matter, in which case these don't belong
> > here, or it does and it should be a runtime query.
> >
> I think you bring up a good point. There is indeed a way of querying the version
> via /sysfs.
> 
> However the question is how does an application know which API version
> it was compiled
> for, so it can compare with what it finds in /sysfs? That ought to be
> somewhere in the
> public headers that the application was compiled with.
> 

The normal way for an application is to just use a syscall or file
interface, and check for -ENOENT or -ENOSYS error codes in order to
find kernels that are too old. If older kernels had a different way
of doing things, the application can fall back on that mechanism.
An example for this would be pselect() which you can replace with
select(), but only in a racy way that the user should avoid.

When the kernel changes an interface, it must only do that in a
backwards compatible way, so that old binaries do not break. Ever.

	Arnd <><
