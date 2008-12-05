Return-Path: <linux-kernel-owner+w=401wt.eu-S1757298AbYLEXYZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757298AbYLEXYZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 18:24:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754069AbYLEXYM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 18:24:12 -0500
Received: from mx1.suse.de ([195.135.220.2]:51821 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752815AbYLEXYK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 18:24:10 -0500
Date: Fri, 5 Dec 2008 15:23:21 -0800
From: Greg KH <gregkh@suse.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Christian Lamparter <chunkeey@web.de>, linux-wireless@vger.kernel.org,
       Johannes Berg <johannes@sipsolutions.net>,
       John W Linville <linville@tuxdriver.com>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] p54usb: fix usb_kill_urb hang with slub_debug=P
Message-ID: <20081205232321.GA8557@suse.de>
References: <200812051547.45790.chunkeey@web.de> <20081205155356.GC28030@suse.de> <4939B6AF.2060901@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4939B6AF.2060901@lwfinger.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 05, 2008 at 05:18:07PM -0600, Larry Finger wrote:
> Greg KH wrote:
> > On Fri, Dec 05, 2008 at 03:47:45PM +0100, Christian Lamparter wrote:
> >> This patch fixes a problem identified by Johannes Berg.
> > 
> > No, it only papers over the real problem here, let's work on a correct
> > patch please.
> 
> I can contribute a little info. If SLUB debugging is enabled, and the boot
> command includes 'slub_debug=P', I get a GPF in kref_get(), which is called from
> kobject_get() with the following code:
> 
>         if (kobj)
>                 kref_get(&kobj->kref);
> 
> >From the dump, &kobj->kref is 0x6b6b6b6b6b6b6dbb, a poisoned value.
> 
> Somewhere, the "struct urb" has been freed, but kobj has not been set to NULL.
> 
> As everything I've found is a symptom, I'm still looking for the real cause.

See alan's post on linux-usb, it shows the real cause.

thanks,

greg k-h
