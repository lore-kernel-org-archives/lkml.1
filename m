Return-Path: <linux-kernel-owner+w=401wt.eu-S1761304AbZJISl4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761304AbZJISl4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 14:41:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761239AbZJISlz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 14:41:55 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:50565 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761180AbZJISlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 14:41:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=aw2ZTvBGRuwJkyVa2stcj41u/6cIXSiydwPEjBAT2lD4Y1ru6b+2kL+tGyLhIWB5E1
         +7Gp+hiLTVasyrdS0RT/mY6sKTaE8rZM2Knar92cLhSGrTWb9njaNjMHSt063WDT8RrD
         ebHPCvVWSAizEBpIK/CttlCeJ9SEi6VQdkkpk=
Date: Fri, 9 Oct 2009 20:41:13 +0200
From: Johan Hovold <jhovold@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Johan Hovold <jhovold@gmail.com>, Alan Stern <stern@rowland.harvard.edu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-usb@vger.kernel.org,
       e9hack <e9hack@googlemail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: serial: Fix read regression in 2.6.31.
Message-ID: <20091009184113.GE21054@localhost>
References: <Pine.LNX.4.44L0.0909191217430.15223-100000@netrider.rowland.org>
 <20090920201836.GA5602@localhost>
 <20091009175602.GC5718@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091009175602.GC5718@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 09, 2009 at 10:56:02AM -0700, Greg KH wrote:
> On Sun, Sep 20, 2009 at 10:18:36PM +0200, Johan Hovold wrote:
> > Use ASYNCB_INITIALIZED to determine when to stop reading.
> > 
> > Port count can no longer be used to determine when to stop reading from
> > the device as it can be zero when the first read callbacks are made (see
> > tty_port_block_til_read where port count is temporarily decremented
> > during serial_open).
> > 
> > Signed-off-by: Johan Hovold <jhovold@gmail.com>
> > ---
> > 
> > Hi, 
> > 
> > Here's a patch which fixes the port count issue for all drivers. I only
> > have access to an ftdi device at the moment so that's the only driver
> > I've been able to test (against latest git with latest patches from
> > Greg's tree). 
> 
> Hm, this doesn't apply on top of the other ftdi patches.  Could you
> respin this?

There were some issues with that patch, so please disregard that one.
Sorry. There are probably still some problems with some of the other
drivers (at least theoretical ones) due to the tty changes that broke
ftdi, but there is currently no patch to fix them all.

/Johan

