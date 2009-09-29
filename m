Return-Path: <linux-kernel-owner+w=401wt.eu-S1754122AbZI2Mtr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122AbZI2Mtr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 08:49:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754083AbZI2Mtq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 08:49:46 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:56209 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754046AbZI2Mtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 08:49:45 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Andreas Schwab <schwab@linux-m68k.org>
Subject: Re: [PATCH] tty: fix vt_compat_ioctl
Date: Tue, 29 Sep 2009 14:49:46 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-11-generic; KDE/4.3.1; x86_64; ; )
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
References: <m2y6nzgcud.fsf@igel.home> <20090928183337.GA10855@suse.de> <m2tyymho45.fsf@igel.home>
In-Reply-To: <m2tyymho45.fsf@igel.home>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909291449.46371.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19PcebQZ2SFQHewSAhyjmFtPQH5+AbYExdycNG
 aPy5lDbpWsg2wMWtxC3HTMKZaKh2b+YGX/ToJRTz+fiQ/ruD4S
 nLTHjmWa8JFAFDb0l4F3w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 September 2009, Andreas Schwab wrote:
> Greg KH <gregkh@suse.de> writes:
> 
> > On Mon, Sep 28, 2009 at 08:10:02PM +0200, Andreas Schwab wrote:
> >> Call compat_unimap_ioctl, not do_unimap_ioctl.
> >
> > That's a nice description of what the patch does, but why do we need to
> > do that?
> 
> It's a compat ioctl handler, so lets call the compat ioctl handler.
> 

My bad, sorry.

I broke it in e9216651 evidently, thanks for debugging this.

The compat_unimap_ioctl was originally called do_unimap_ioctl in
fs/compat_ioctl.h which got moved to drivers/char/vt_ioctl.c.
In that patch, the caller was not updated and consequently called
the native handler.

Acked-by: Arnd Bergmann <arnd@arndb.de>

	Arnd <><
