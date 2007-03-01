Return-Path: <linux-kernel-owner+w=401wt.eu-S965057AbXCANiD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965057AbXCANiD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 08:38:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965061AbXCANiC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 08:38:02 -0500
Received: from smtp.ocgnet.org ([64.20.243.3]:59141 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965057AbXCANiA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 08:38:00 -0500
Date: Thu, 1 Mar 2007 22:35:28 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Ben Dooks <ben@fluff.org.uk>,
       Linux Frame Buffer Device Development 
	<linux-fbdev-devel@lists.sourceforge.net>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [Linux-fbdev-devel] [PATCH] fb: sm501fb off-by-1 sysfs store
Message-ID: <20070301133528.GA6504@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Ben Dooks <ben@fluff.org.uk>,
	Linux Frame Buffer Device Development <linux-fbdev-devel@lists.sourceforge.net>,
	Linux Kernel Development <linux-kernel@vger.kernel.org>
References: <20070301082456.GA3701@linux-sh.org> <Pine.LNX.4.62.0703011423060.766@pademelon.sonytel.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.62.0703011423060.766@pademelon.sonytel.be>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 01, 2007 at 02:25:55PM +0100, Geert Uytterhoeven wrote:
> On Thu, 1 Mar 2007, Paul Mundt wrote:
> > @@ -1074,9 +1074,9 @@ static ssize_t sm501fb_crtsrc_store(struct device *dev,
> >  	if (len < 1)
> >  		return -EINVAL;
> >  
> > -	if (strnicmp(buf, "crt", sizeof("crt")) == 0)
> > +	if (strnicmp(buf, "crt", 3) == 0)
> >  		head = HEAD_CRT;
> > -	else if (strnicmp(buf, "panel", sizeof("panel")) == 0)
> > +	else if (strnicmp(buf, "panel", 5) == 0)
> >  		head = HEAD_PANEL;
> >  	else
> >  		return -EINVAL;
> 
> What about using just `strlen("string")' instead? ISTR gcc optimizes this to a
> constant. Not that it matters that much, as the actual string won't be
> duplicated.
> 
I stuck with the constants since they were already referenced in the
function, and there are enough other places in the kernel where they're
used for these things. I didn't figure that 5 was a terribly high number
to count to, but if there's expected difficulty, strlen() is of course an
option.

Personally I find it less visually offensive with constants, but as long
as the end number is the same, I'm not too concerned with how we get
there. Feel free to change it if you wish.
