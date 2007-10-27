Return-Path: <linux-kernel-owner+w=401wt.eu-S1752050AbXJ0GGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752050AbXJ0GGe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 02:06:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753867AbXJ0GGV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 02:06:21 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:58080 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753507AbXJ0GGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 02:06:19 -0400
Subject: Re: linux-2.6.23-git3: Many sysfs-related warnings in dmesg
From: Kay Sievers <kay.sievers@vrfy.org>
To: Greg KH <gregkh@suse.de>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20071027023612.GC28858@suse.de>
References: <47221E6F.1090607@lwfinger.net>
	 <1193422064.2190.6.camel@lov.site>  <20071027023612.GC28858@suse.de>
Content-Type: text/plain
Date: Sat, 27 Oct 2007 08:08:14 +0200
Message-Id: <1193465294.2190.51.camel@lov.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1+7jrNik10qbuTiRMdyYMssYyMKrXIF0PrD3hf
 cuwOdvbYNpaxjLUsAg4Pcrr0BAe4YiDBvyrMEkRww6g/00APiR
 3Cb760L7asmN+TGf8fzMHLuoQgj0ige
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-10-26 at 19:36 -0700, Greg KH wrote:
> On Fri, Oct 26, 2007 at 08:07:44PM +0200, Kay Sievers wrote:
> > On Fri, 2007-10-26 at 12:05 -0500, Larry Finger wrote:
> > > On my openSUSE 10.3 x86_64 system running v2.6.24-rc1-281-g22d2aa1,
> > > I get the sysfs rename messages.
> > 
> > Care to try this? Seems like a silly bug in the core if
> > SYSFS_DEPRECATED=y. That's why we didn't catch this earlier, sorry.

> > From: Kay Sievers <kay.sievers@vrfy.org>
> > Subject: Driver Core: fix bug in device_rename() for SYSFS_DEPRECATED=y
> > 
> 
> Do you have some more information for the change log here?  Are we just
> not unwinding from errors properly?

The code just shouldn't run if class devices are real directories, it's
an update for the symlink in the class directory. Nobody noticed that as
long as the creation of sysfs files silently failed, and we both missed
it before the merge, because we don't run SYSFS_DEPRECATED=y.

Kay

