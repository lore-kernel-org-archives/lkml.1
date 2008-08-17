Return-Path: <linux-kernel-owner+w=401wt.eu-S1754890AbYHQSYp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890AbYHQSYp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 14:24:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752332AbYHQSYg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 14:24:36 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:49803 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203AbYHQSYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 14:24:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:to:cc:subject:message-id:reply-to:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent:from;
        b=hp7waeEMZTQs6cmRzTpcHG/SXTaD/VYDW3Ni0n//fxu5BI4khfr5EuCJ7g+fOjBIsw
         Pcv5yBb3m3nZe5N4S+z8vrf6DIxcE8U5W1Y1oifUEaGji9ZftMPsYhw7VlGB3oj2kmHX
         3nadIq9iEmzeF/y34l3NvQ+QH5U0choN5aZRs=
Date: Sun, 17 Aug 2008 20:24:33 +0200
To: Joe Perches <joe@perches.com>
Cc: bzolnier@gmail.com, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: [PATCH 3/5] ide: add a driver-wide debugging macro
Message-ID: <20080817182433.GA6849@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com, Joe Perches <joe@perches.com>,
	bzolnier@gmail.com, linux-kernel@vger.kernel.org,
	linux-ide@vger.kernel.org
References: <1218993826-4571-1-git-send-email-petkovbb@gmail.com> <1218993826-4571-4-git-send-email-petkovbb@gmail.com> <1218996786.24527.115.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1218996786.24527.115.camel@localhost>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 17, 2008 at 11:13:06AM -0700, Joe Perches wrote:
> On Sun, 2008-08-17 at 19:23 +0200, Borislav Petkov wrote:
> > diff --git a/include/linux/ide.h b/include/linux/ide.h
> > index c161840..b6d714d 100644
> > --- a/include/linux/ide.h
> > +++ b/include/linux/ide.h
> > []
> > +/* DRV_NAME has to be defined in the driver before using the macro below */
> > +#define __ide_debug_log(lvl, fmt, args...)			\
> > +{								\
> > +	if (unlikely(drive->debug_mask & lvl))			\
> > +		printk(KERN_INFO DRV_NAME ": " fmt, ## args);	\
> > +}
> 
> Shouldn't a debug printk use KERN_DEBUG?

Yes, it should. However, i'm going to have to change the default console
loglevel to see those, aka boot with loglevel=7 and there's the possibility of
other debug messages getting in the way too. Instead, the debugging messages
here are enabled only when you do a debug build of the driver _and_ when enable
them through the debug_mask so you get to see debug messages only you're
interested in without changing anything else in the kernel boot.

-- 
Regards/Gruss,
    Boris.
