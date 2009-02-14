Return-Path: <linux-kernel-owner+w=401wt.eu-S1752106AbZBNJMH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752106AbZBNJMH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 04:12:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750972AbZBNJLw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 04:11:52 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38382
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750832AbZBNJLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 04:11:51 -0500
Date: Sat, 14 Feb 2009 01:11:45 -0800 (PST)
Message-Id: <20090214.011145.102067430.davem@davemloft.net>
To: benh@kernel.crashing.org
Cc: airlied@linux.ie, dri-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5]: drm: ati_pcigart: Do not access I/O MEM space
 using pointer derefs.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1234602474.26036.83.camel@pasglop>
References: <1234434959.29851.55.camel@pasglop>
	<20090213.220934.236067646.davem@davemloft.net>
	<1234602474.26036.83.camel@pasglop>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Sat, 14 Feb 2009 20:07:54 +1100

> > I did some research, and it does appear that the GART does read the
> > PTEs from the VRAM using the Host Data Path.  This means the surface
> > control byte swapping settings are applied.
> > 
> > So for depths of 16 and 24, the GART is reading garbage PTEs.  And
> > that's why the CP hangs.
> 
> That makes me wonder how the heck did it work for me ! Or maybe... I've
> been using an R5xx which happens to have a bit that I haven't seen on
> R3xx that allows ... to set whether the GART reads come from HDP or
> directly from MC. That might be what saved my ass here.

I wonder.  But I really doubt it.  The bit is off by default
and the radeon DRM code explicitly sets it to off.

> We can do that by registering a surface from the kernel to cover the
> GART I suppose, and clean things a bit so that when using the DRI, X
> doesn't touch the surface registers -at all- and leaves it to the
> kernel.

That actually sounds like a good idea.
