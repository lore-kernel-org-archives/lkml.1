Return-Path: <linux-kernel-owner+w=401wt.eu-S1756813AbYE2OFt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756813AbYE2OFt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 10:05:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753248AbYE2OFj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 10:05:39 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:42214 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753399AbYE2OFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 10:05:38 -0400
Subject: Re: [PATCH] scsi: remove CDROM not ready printk
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jerry Stralko <gerb.stralko@gmail.com>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
In-Reply-To: <20080529004154.bbc7b1d4.akpm@linux-foundation.org>
References: <alpine.LFD.1.10.0805271502370.3985@localhost.localdomain>
	 <20080529004154.bbc7b1d4.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 29 May 2008 09:05:32 -0500
Message-Id: <1212069932.3428.1.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-05-29 at 00:41 -0700, Andrew Morton wrote:
> On Tue, 27 May 2008 15:02:43 -0400 (EDT) Jerry Stralko <gerb.stralko@gmail.com> wrote:
> 
> > Hello,
> 
> let's cc a scsi list which exists ;)
> 
> >    This printk was spamming my dmesg and /var/log/message.  Is there a 
> > reason we have this printk?  Can we simply remove it?
> > 
> > 
> > Signed-off-by: Jerry Stralko <gerb.stralko@gmail.com>
> > ---
> > 
> > 
> > diff --git a/drivers/scsi/sr_ioctl.c b/drivers/scsi/sr_ioctl.c
> > index ae87d08..c37fb1c 100644
> > --- a/drivers/scsi/sr_ioctl.c
> > +++ b/drivers/scsi/sr_ioctl.c
> > @@ -238,8 +238,6 @@ int sr_do_ioctl(Scsi_CD *cd, struct packet_command *cgc)
> >   					break;
> >   				}
> >   			}
> > -			if (!cgc->quiet)
> > -				printk(KERN_INFO "%s: CDROM not ready.  Make sure there is a disc in the drive.\n", cd->cdi.name);
> >   #ifdef DEBUG
> >   			scsi_print_sense_hdr("sr", &sshdr);
> >   #endif
> 
> The answer may be that you need to enable cgc->quiet.  If that is
> user-enableable - I can't work out how from a quick grep.

That's correct.  cgc is the data from the packet command that was sent
in from the ioctl.  The user application is actually the one that
decides whether you get to see the message or not.  Modern apps like hal
set it because they take care of all state updates and notifications
themselves.  Which is the application that's doing this (because it
probably needs updating).

James


