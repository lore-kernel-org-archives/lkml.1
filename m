Return-Path: <linux-kernel-owner+w=401wt.eu-S1753286AbYCISNn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286AbYCISNn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 14:13:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750941AbYCISNf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 14:13:35 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:26054 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778AbYCISNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 14:13:34 -0400
Date: Sun, 9 Mar 2008 11:12:03 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andres Salomon <dilinger@queued.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, adaplas@gmail.com,
       linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net
Subject: Re: [PATCH 1/4] gxfb: Replace FBSIZE config option with a kernel
 argument
Message-Id: <20080309111203.97680dc2.randy.dunlap@oracle.com>
In-Reply-To: <20080308201950.28f6eae8@ephemeral>
References: <20080223011045.48e6cb8e@ephemeral>
	<20080227163105.e1b96023.akpm@linux-foundation.org>
	<20080227195839.1e86074e@ephemeral>
	<20080308201950.28f6eae8@ephemeral>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 8 Mar 2008 20:19:50 -0500 Andres Salomon wrote:

> On Wed, 27 Feb 2008 19:58:39 -0500
> Andres Salomon <dilinger@queued.net> wrote:
> 
> > On Wed, 27 Feb 2008 16:31:05 -0800
> > Andrew Morton <akpm@linux-foundation.org> wrote:
> > 
> > > On Sat, 23 Feb 2008 01:10:45 -0500
> > > Andres Salomon <dilinger@queued.net> wrote:
> > > 
> > > > @@ -425,7 +424,10 @@ static int __init gxfb_setup(char *options)
> > > >  		if (!*opt)
> > > >  			continue;
> > > >  
> > > > -		mode_option = opt;
> > > > +		if (!strncmp(opt, "fbsize:", 7))
> > > > +			fbsize = simple_strtoul(opt+7, NULL, 0);
> > > > +		else
> > > > +			mode_option = opt;
> > > >  	}
> > > 
> > > The above shouldn't be necessary.
> > 
> > It looks like that's done in other drivers in case MODULE isn't defined.  I'm
> > assuming this is historical at this point, and manual options parsing can
> > be removed from all fb drivers at this point, or is there another reason
> > why manual parsing would be necessary?
> > 
> 
> Could I get an answer from the fbdevel folks about this?  It looks like
> the fb_get_options stuff is there for backwards compatibility.
> gxfb.fbsize=16777216 (for example) works regardless of whether or not
> CONFIG_MODULES is set.  
> 

It would be very nice to get Mr. Daplas back.

> > 
> > > 
> > > And it should have been documented in Documentation/kernel-parameters.txt.
> > 
> > Yeah, I wasn't actually sure about that; I did check for other fb drivers
> > documenting stuff in kernel-parameters.txt, and didn't see it.  It looks
> > like they instead document stuff in Documentation/fb/.  Which is preferred?
> > 
> 
> I'd also like an opinion on this.

My opinion (only) is that any subsystem that has lots of doc and/or
kernel parameters should put that info into Documentation/<subdir>/,
so adding to Documentation/fb/ is good.  (sound is another big
candidate for this.  All of those "snd-xyz=" entries in
kernel-parameters.txt don't actually help other than to say that there
are some user-settable parameters that someone has to go search for.)
We should probably also extend this entry in kernel-parameters.txt:

 	video=		[FB] Frame buffer configuration
			See Documentation/fb/modedb.txt.

to point to Documentation/fb/ for all frame buffer docs.

---
~Randy
