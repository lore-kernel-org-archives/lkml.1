Return-Path: <linux-kernel-owner+w=401wt.eu-S1758669AbZKJXM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758669AbZKJXM3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 18:12:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758562AbZKJXM3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 18:12:29 -0500
Received: from aeryn.fluff.org.uk ([87.194.8.8]:47127 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757278AbZKJXM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 18:12:28 -0500
Date: Tue, 10 Nov 2009 23:12:33 +0000
From: Ben Dooks <ben@simtec.co.uk>
To: Andres Salomon <dilinger@collabora.co.uk>
Cc: linux-kernel@vger.kernel.org, Vincent Sanders <vince@simtec.co.uk>,
       Simtec Linux Team <linux@simtec.co.uk>, akpm@linux-foundation.org,
       krzysztof.h1@wp.pl, lethal@linux-sh.org
Subject: Re: SM501: Fix missing uses of resource_size()
Message-ID: <20091110231233.GI20341@fluff.org.uk>
References: <20091110171734.085189722@fluff.org.uk>
 <20091110131536.427b5caf@mycelium.queued.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091110131536.427b5caf@mycelium.queued.net>
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 10, 2009 at 01:15:36PM -0500, Andres Salomon wrote:
> On Tue, 10 Nov 2009 17:17:34 +0000
> Ben Dooks <ben@simtec.co.uk> wrote:
> 
> > There are several places in the SM501 fb driver that could do with
> > using resource_size() to calculate the size of a resource.
> > 
> 
> Yes, please!  Also, as Thiago suggested, please submit this inline.

My mailer shows it in line. using quilt mail to send, and it says
that the content has been inlined.

> [...]
> > @@ -1363,7 +1363,7 @@ static int sm501fb_start(struct sm501fb_
> >  	}
> >  
> >  	info->fbmem_res = request_mem_region(res->start,
> > -					     (res->end -
> > res->start)+1,
> > +					     resource_size(res),
> >  					     pdev->name);
> >  	if (info->fbmem_res == NULL) {
> >  		dev_err(dev, "cannot claim framebuffer\n");
> > @@ -1377,7 +1377,7 @@ static int sm501fb_start(struct sm501fb_
> 
> Looks like you missed one here; the ioremap on line 1374 should also
> use resource_size.

thanks, fixed.

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
