Return-Path: <linux-kernel-owner+w=401wt.eu-S932301AbYCEKRo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932301AbYCEKRo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 05:17:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764776AbYCEKRN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 05:17:13 -0500
Received: from ns2.suse.de ([195.135.220.15]:34009 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762749AbYCEKRH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 05:17:07 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [JANITOR-PATCH] rtc: switch to unlocked_ioctl
Date: Wed, 5 Mar 2008 11:16:45 +0100
User-Agent: KMail/1.9.6
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
       Russell King <rmk@arm.linux.org.uk>,
       LKML <linux-kernel@vger.kernel.org>
References: <1204664803.5698.27.camel@brick> <47CDD3F9.7070801@gmail.com>
In-Reply-To: <47CDD3F9.7070801@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803051116.45769.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 March 2008 23:58:01 Jiri Slaby wrote:
> Harvey Harrison napsal(a):
> > Make the lock/unlock_kernel explicit.
> > 
> > Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> > ---
> >  arch/arm/common/rtctime.c |    7 ++++---
> >  1 files changed, 4 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/arm/common/rtctime.c b/arch/arm/common/rtctime.c
> > index f53bca4..2062f92 100644
> > --- a/arch/arm/common/rtctime.c
> > +++ b/arch/arm/common/rtctime.c
> > @@ -173,8 +173,7 @@ static unsigned int rtc_poll(struct file *file, poll_table *wait)
> >  	return data != 0 ? POLLIN | POLLRDNORM : 0;
> >  }
> >  
> > -static int rtc_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
> > -		     unsigned long arg)
> > +static int rtc_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
> 
> long? I guess you need to get a cross-compiler...

Yes please do these transformations only for code that you can compile.

One easy way to do that is to do an allyesconfig build once and save the log (or 
fetch http://halobates.de/allyes/i386-2.6.24-rc6-git12 and 
http://halobates.de/allyes/x86_64-2.6.24-rc6-git12 as an older example) 
and always check if the file you're changing is compiled in the log.

Then after changing do at least a make allyesconfig ; make path/to/file.o

-Andi
