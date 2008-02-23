Return-Path: <linux-kernel-owner+w=401wt.eu-S1757260AbYBWNrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757260AbYBWNrV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 08:47:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752986AbYBWNrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 08:47:10 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:54740 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455AbYBWNrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 08:47:09 -0500
X-SBRS: 2.8
X-MesageID: 43203720
X-Ironport-Server: ftlpip02.citrite.net
X-Remote-IP: 216.142.71.134
X-Policy: $Relay
X-IronPort-AV: E=Sophos;i="4.25,394,1199682000"; 
   d="scan'208";a="43203720"
Date: Sat, 23 Feb 2008 14:46:21 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: VT notifier fix for VT switch
Message-ID: <20080223134621.GF4244@implementation>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <20080221202640.GA10976@implementation> <20080223000430.074b3648.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080223000430.074b3648.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton, le Sat 23 Feb 2008 00:04:30 -0800, a écrit :
> On Thu, 21 Feb 2008 21:26:40 +0100 Samuel Thibault <samuel.thibault@ens-lyon.org> wrote:
> 
> > Notify when VT switch is complete.
> > 
> > Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
> > 
> > --- linux-2.6.24-orig/drivers/char/vt.c	2008-01-25 09:32:06.000000000 +0100
> > +++ linux-2.6.24-perso/drivers/char/vt.c	2008-02-21 15:51:13.000000000 +0100
> > @@ -702,6 +702,7 @@
> >  	if (is_switch) {
> >  		set_leds();
> >  		compute_shiftstate();
> > +		notify_update(vc);
> >  	}
> >  }
> >  
> 
> The changelog is too terse, sorry.  What is the reason for making this
> change?  What are the user-visible effects of not having this change?

Ok:

VT notifier callbacks need to be aware of console switches.  This
is already partially done from console_callback(), but at that time
fg_console, cursor positions, etc. are not yet updated and hence screen
readers fetch the old values.

This adds an update notify after all of the values are updated in
redraw_screen(vc, 1).

> If it fixes a bug, should it be backported to 2.6.24.x and earlier?

It would be useful to backport it to 2.6.24.x indeed.  Earlier versions
don't have VT notifiers.

Samuel
