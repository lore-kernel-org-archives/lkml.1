Return-Path: <linux-kernel-owner+w=401wt.eu-S1753387AbZHCSBE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387AbZHCSBE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 14:01:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753325AbZHCSBC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 14:01:02 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:58080 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318AbZHCSA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 14:00:59 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mark Lord <lkml@rtr.ca>
Subject: Re: [PATCH] fs/compat_ioctl.c: add missing FS_IOC_FIEMAP support
Date: Mon, 3 Aug 2009 20:00:11 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-3-generic; KDE/4.2.98; x86_64; ; )
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org,
       Eric Sandeen <sandeen@sandeen.net>,
       Andrew Morton <akpm@linux-foundation.org>
References: <4A74584D.2010300@rtr.ca> <4A7722DF.80704@rtr.ca>
In-Reply-To: <4A7722DF.80704@rtr.ca>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200908032000.12260.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19JxihBG6GQSqHo7AVfCUtUbi63hwPg4qtXDj4
 O4KXRJhPyDIIm/1/VrDqaIN+0F3HQCfcwLmGYNCmG3Dw3gtRiU
 7y2hlS3u8q318iEEk0JZw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 August 2009, Mark Lord wrote:
> (resending, no ack from anyone first time around).

I actually wrote a lengthy reply on how I think the code around it
should be done differently and then realized why we had done it
that way originally and did not send out my reply.

Your addition looks ok, the data structures are compatible
on all architectures.

> Add support for the FIEMAP ioctl for 32-bit user on 64-bit kernel.
> 
> When using a 32-bit runtime on top of a 64-bit kernel,
> programs like "filefrag" and "hdparm --fibmap" do not work correctly.
> 
> This is because there's no compat ioctl entry for the FIEMAP call.
> FIEMAP returns file extent info, similar to FIBMAP (but better).
> 
> Since FIBMAP itself is b0rked on ext4, this leaves no way for a 32-bit
> program to reliably get detailed block information for a file
> when run on top of a 64-bit kernel.  This patch addresses the issue.
> 
> Once upstream, this patch could also be a candidate for -stable.
> 
> Signed-off-by: Mark Lord <mlord@pobox.com>

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
